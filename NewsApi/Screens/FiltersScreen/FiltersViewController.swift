//
//  FiltersViewController.swift
//  NewsApi
//
//  Created by Philip on 07.01.2021.
//

import UIKit
import RxCocoa
import RxSwift

protocol FiltersViewControllerDelegate {
    func updateFilters(filters: [ArticlesFilterModel])
}

final class FiltersViewController: BaseViewController {
    
    @IBOutlet private weak var filtersTableView: UITableView!
    @IBOutlet private weak var acceptNavigationButton: UIBarButtonItem!
    
    private let filterCommonCellID = String(describing: FilterCommonCell.self)
    
    let viewModel = FiltersViewModel()
        
    var delegate: FiltersViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
//        setupObservers()
        setupSubviews()
        
        viewModel.handleViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        filtersTableView.reloadData()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        guard parent == nil else { return }
        delegate?.updateFilters(filters: viewModel.filters)
    }
    
    private func setupSubviews() {
        filtersTableView.register(UINib(nibName: filterCommonCellID, bundle: nil), forCellReuseIdentifier: filterCommonCellID)
        filtersTableView.tableFooterView = UIView()
        
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
    }
    
    private func setupObservers() {
        viewModel.filtersRx
            .asObservable()
            .bind(to: filtersTableView.rx.items(cellIdentifier: filterCommonCellID, cellType: FilterCommonCell.self)) { index, filter, cell in
                return cell.setup(withFilter: filter)
            }.disposed(by: disposeBag)

        filtersTableView
            .rx
            .modelSelected(ArticlesFilterModel.self)
            .subscribe(onNext: { filter in
                self.showFilterOptions(forFilter: filter)
            }).disposed(by: disposeBag)
        
        acceptNavigationButton
            .rx
            .tap.subscribe(onNext: { [weak self] in
                // TODO: Accepted
                self?.popToArticles()
            }).disposed(by: disposeBag)
    }
    
    // MARK: navigation
    
    private func showFilterOptions(forFilter filter: ArticlesFilterModel) {
        guard let filterOptionsVC = navigationController?.initControllerFromStoryboard(of: FilterOptionsViewController.self) as? FilterOptionsViewController else { return }
        filterOptionsVC.setup(withFiler: filter)
        navigationController?.pushViewController(filterOptionsVC, animated: true)
    }
    
    private func popToArticles() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - FilterOptionsDelegate

extension FiltersViewController: FilterOptionsViewControllerDelegate {
    func updateFilter(_ filter: ArticlesFilterModel) {
        viewModel.filters.filter {$0.name == filter.name }.first?.options = filter.options
    }
}

// MARK: - TableView logic

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: filterCommonCellID) as? FilterCommonCell else {
            return UITableViewCell()
        }
        cell.setup(withFilter: viewModel.filters[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showFilterOptions(forFilter: viewModel.filters[indexPath.row])
    }
}

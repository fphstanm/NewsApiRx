//
//  FiltersViewController.swift
//  NewsApi
//
//  Created by Philip on 07.01.2021.
//

import UIKit
import RxCocoa
import RxSwift

final class FiltersViewController: BaseViewController {
    
    @IBOutlet private weak var filtersTableView: UITableView!
    
    private let filterCommonCellID = String(describing: FilterCommonCell.self)
    
    let viewModel = FiltersViewModel()
            
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setupSubviews()
        setupBindings()
        viewModel.handleViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        filtersTableView.reloadData()
    }
    
    // MARK: - setup methods
    
    private func setupSubviews() {
        filtersTableView.register(UINib(nibName: filterCommonCellID, bundle: nil), forCellReuseIdentifier: filterCommonCellID)
        filtersTableView.tableFooterView = UIView()
    }
    
    private func setupBindings() {
        viewModel.state.filters
            .asObservable()
            .bind(to: filtersTableView.rx.items(cellIdentifier: filterCommonCellID, cellType: FilterCommonCell.self)) { index, filter, cell in
                return cell.setup(withFilter: filter)
            }.disposed(by: disposeBag)

        filtersTableView
            .rx
            .modelSelected(ArticlesFilterModel.self)
            .subscribe(onNext: { [weak self] filter in
                if filter.isActive {
                    self?.showFilterOptions(forFilter: filter)
                } else {
                    self?.viewModel.handleFilterTapped(ofType: filter.type)
                }
            }).disposed(by: disposeBag)
    }
    
    // MARK: - navigation
    
    private func showFilterOptions(forFilter filter: ArticlesFilterModel) {
        guard let filterOptionsVC = navigationController?.initControllerFromStoryboard(of: FilterOptionsViewController.self) as? FilterOptionsViewController else { return }
        filterOptionsVC.setup(withFiler: filter)
        navigationController?.pushViewController(filterOptionsVC, animated: true)
    }
    
    private func popToArticles() {
        navigationController?.popViewController(animated: true)
    }
}

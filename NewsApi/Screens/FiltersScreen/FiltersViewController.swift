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
    @IBOutlet private weak var acceptNavigationButton: UIBarButtonItem!
    
    private let filterCommonCellID = String(describing: FilterCommonCell.self)
    
    private let viewModel = FiltersViewModel()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setupObservers()
        setupSubviews()
        
        viewModel.handleViewDidLoad()
    }
    
    private func setupSubviews() {
        filtersTableView.register(UINib(nibName: filterCommonCellID, bundle: nil), forCellReuseIdentifier: filterCommonCellID)
        filtersTableView.tableFooterView = UIView()
    }
    
    private func setupObservers() {
//        viewModel.filters
//            .asObservable()
//            .bind(to: filtersTableView.rx.items) { tableView, index, item in
//                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterCommonCell.self)) as! FilterCommonCell
//                cell.setup(withFilter: item)
//
//                return cell
//            }.disposed(by: disposeBag)
        
        viewModel.filters
            .asObservable()
            .bind(to: filtersTableView.rx.items(cellIdentifier: filterCommonCellID, cellType: FilterCommonCell.self)) { index, filter, cell in
                return cell.setup(withFilter: filter)
            }.disposed(by: disposeBag)

        filtersTableView
            .rx
            .modelSelected(ArticlesFilter.self)
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
    
    private func showFilterOptions(forFilter filter: ArticlesFilter) {
        guard let filterOptionsVC = navigationController?.initControllerFromStoryboard(of: FilterOptionsViewController.self) as? FilterOptionsViewController else { return }
        filterOptionsVC.setup(withFiler: filter)
        navigationController?.pushViewController(filterOptionsVC, animated: true)
    }
    
    private func popToArticles() {
        navigationController?.popViewController(animated: true)
    }
}

//
//  FilterOptionsViewController.swift
//  NewsApi
//
//  Created by Philip on 07.01.2021.
//

import UIKit
import RxCocoa
import RxSwift

final class FilterOptionsViewController: BaseViewController {
    
    @IBOutlet private weak var filterItemsTableView: UITableView!
    
    var viewModel = FilterOptionsViewModel(filterType: .category)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupObservers()
        
        viewModel.handleViewDidLoad()
    }
    
    func setup(withFiler filter: ArticlesFilterModel) {
        viewModel.filter = filter
    }
    
    private func setupSubviews() {
        title = viewModel.title
        
        filterItemsTableView.register(UINib(nibName: viewModel.filterItemCellId, bundle: nil), forCellReuseIdentifier: viewModel.filterItemCellId)
        filterItemsTableView.tableFooterView = UIView()
        
        setupActivityIndicator()
    }
    
    private func setupObservers() {
        viewModel.itemsRx
            .asObservable()
            .bind(to: filterItemsTableView.rx.items(cellIdentifier: viewModel.filterItemCellId, cellType: FilterItemCell.self)) {
                index, filterOption, cell in
                return cell.setup(withOption: filterOption)
            }.disposed(by: disposeBag)
        
        filterItemsTableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.handleDidSelectItem(withIndex: indexPath.row)
                strongSelf.filterItemsTableView.reloadData()
            }).disposed(by: disposeBag)

        viewModel.isActivityIndicatorHidden
            .asObservable()
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}

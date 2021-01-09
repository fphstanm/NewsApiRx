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
    
    private var itemsRx = BehaviorRelay<[ArticlesFilterOption]>(value: [])
    
    var viewModel = FilterOptionsViewModel(filterType: .category)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        title = viewModel.title
    }
    
    func setup(withFiler filter: ArticlesFilterModel) {
        viewModel.filter = filter
    }
    
    private func setupSubviews() {
        filterItemsTableView.register(UINib(nibName: viewModel.filterItemCellId, bundle: nil), forCellReuseIdentifier: viewModel.filterItemCellId)
        filterItemsTableView.tableFooterView = UIView()
        
        filterItemsTableView.delegate = self
        filterItemsTableView.dataSource = self
    }
    
    private func setupObservers() {
        itemsRx
            .asObservable()
            .bind(to: filterItemsTableView.rx.items(cellIdentifier: viewModel.filterItemCellId, cellType: FilterItemCell.self)) {
                index, filterOption, cell in
                return cell.setup(withOption: filterOption)
            }.disposed(by: disposeBag)
    }
    
}

extension FilterOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filter.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.filterItemCellId) as? FilterItemCell else { return UITableViewCell() }
        cell.setup(withOption: viewModel.filter.options[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.handleDidSelectItem(withIndex: indexPath.row)
        tableView.reloadData()
    }
}

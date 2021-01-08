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
    
    var filter: ArticlesFilter?
    
    private var items = BehaviorRelay<[ArticlesFilterOption]>(value: [])
    
    private let filterItemCellId = String(describing: FilterItemCell.self)

    
    // TODO: make init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupObservers()
        
        items.accept(filter!.options)
        title = "Choose a \(filter!.name)"
    }
    
    func setup(withFiler filter: ArticlesFilter) {
        self.filter = filter
    }
    
    private func setupSubviews() {
        filterItemsTableView.register(UINib(nibName: filterItemCellId, bundle: nil), forCellReuseIdentifier: filterItemCellId)
        filterItemsTableView.tableFooterView = UIView()
    }
    
    private func setupObservers() {
        items
            .asObservable()
            .bind(to: filterItemsTableView.rx.items(cellIdentifier: filterItemCellId, cellType: FilterItemCell.self)) {
                index, filterOption, cell in
                return cell.setup(withOption: filterOption)
            }.disposed(by: disposeBag)
    }
}

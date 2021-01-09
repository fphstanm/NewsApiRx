//
//  FilterOptionsViewController.swift
//  NewsApi
//
//  Created by Philip on 07.01.2021.
//

import UIKit
import RxCocoa
import RxSwift

protocol FilterOptionsViewControllerDelegate {
    func updateFilter(_ filter: ArticlesFilterModel)
}

final class FilterOptionsViewController: BaseViewController {
    
    @IBOutlet private weak var filterItemsTableView: UITableView!
    
    private var itemsRx = BehaviorRelay<[ArticlesFilterOption]>(value: [])
    
    private let filterItemCellId = String(describing: FilterItemCell.self)
    
    private var priviousSelectedCellIndex = 0
    
    var filter: ArticlesFilterModel?

    var delegate: FilterOptionsViewControllerDelegate?
    
    
    // TODO: make init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
//        setupObservers()
//        itemsRx.accept(filter!.options)
        title = "Choose a \(filter!.name)"
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        guard parent == nil else { return }
        delegate?.updateFilter(filter!)
    }
    
    func setup(withFiler filter: ArticlesFilterModel) {
        self.filter = filter
    }
    
    private func setupSubviews() {
        filterItemsTableView.register(UINib(nibName: filterItemCellId, bundle: nil), forCellReuseIdentifier: filterItemCellId)
        filterItemsTableView.tableFooterView = UIView()
        
        filterItemsTableView.delegate = self
        filterItemsTableView.dataSource = self
    }
    
    private func setupObservers() {
        itemsRx
            .asObservable()
            .bind(to: filterItemsTableView.rx.items(cellIdentifier: filterItemCellId, cellType: FilterItemCell.self)) {
                index, filterOption, cell in
                return cell.setup(withOption: filterOption)
            }.disposed(by: disposeBag)
    }
    
}

extension FilterOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filter?.options.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: filterItemCellId) as? FilterItemCell else { return UITableViewCell() }
        cell.setup(withOption: filter!.options[indexPath.row])
        
        if filter!.options[indexPath.row].isSelected {
            priviousSelectedCellIndex = indexPath.row
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == priviousSelectedCellIndex {
            filter!.options[indexPath.row].isSelected = !filter!.options[indexPath.row].isSelected
            if filter!.options[indexPath.row].isSelected {
                filter!.selectedOption = filter!.options[indexPath.row].name
            }
        } else {
            filter!.options[priviousSelectedCellIndex].isSelected = false
            filter!.options[indexPath.row].isSelected = true
            filter!.selectedOption = filter!.options[indexPath.row].name
            
            priviousSelectedCellIndex = indexPath.row
        }
        tableView.reloadData()
    }
}

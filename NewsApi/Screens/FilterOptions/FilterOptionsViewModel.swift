//
//  FilterOptionsViewModel.swift
//  NewsApi
//
//  Created by Philip on 09.01.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class FilterOptionsViewModel: BaseViewModel {
    private let filterManager = ArticlesFilterManager.shared
    
    private lazy var previousSelectedItemIndex: Int = filter.items.firstIndex { $0.isSelected == true } ?? 0
    
    let filterItemCellId = String(describing: FilterItemCell.self)
    
    let itemsRx = BehaviorRelay<[ArticlesFilterItem]>(value: [])
    
    var isMultipleSelectionEnabled = false
    
    var isActivityIndicatorHidden = BehaviorRelay<Bool>(value: true)
    
    var filter: ArticlesFilterModel
    
    lazy var title = "Choose a \(filter.name)"
    
    
    // MARK: init
    
    init(filterType: ArticlesFilterType) {
        filter = filterManager.getFilter(ofType: filterType)
    }
    
    // MARK: handlers
    
    func handleViewDidLoad() {
        configureInitialData()
    }
    
    func handleDidSelectItem(withIndex index: Int) {
        if index == previousSelectedItemIndex {
            filter.items[index].isSelected = !filter.items[index].isSelected
        } else {
            if !isMultipleSelectionEnabled {
                filter.items[previousSelectedItemIndex].isSelected = false
            }
            filter.items[index].isSelected = !filter.items[index].isSelected
            previousSelectedItemIndex = index
        }
    }
    
    // MARK: private methods
    
    private func configureInitialData() {
        switch filter.type {
        case .sources:
            isMultipleSelectionEnabled = true
            
            if !filter.items.isEmpty {
                itemsRx.accept(filter.items)
            } else {
                getSources() { sources in
                    let items = self.formSourcesFilterItems(fromSources: sources)
                    self.filterManager.updateFilterItems(filterOfType: self.filter.type, items: items)
                    self.itemsRx.accept(items)
                }
            }
        default:
            itemsRx.accept(filter.items)
        }
    }
    
    private func formSourcesFilterItems(fromSources sources: [Source]) -> [ArticlesFilterItem]{
        var sourcesItems: [ArticlesFilterItem] = []
        sources.forEach { source in
            guard let name = source.name, let id = source.id else { return }
            let item = ArticlesFilterItem(name: name, id: id, isSelected: false)
            sourcesItems.append(item)
        }
        return sourcesItems
    }

    
    // MARK: network
    
    private func getSources(completion: @escaping (([Source]) -> ())) {
        
        isActivityIndicatorHidden.accept(false)
        ApiClient.getSources()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] sourcesModel in
                guard let sources = sourcesModel.sources
                else { return }
                completion(sources)
            }, onError: { error in
                print("Error: ", error)
            },onCompleted: { [weak self] in
                self?.isActivityIndicatorHidden.accept(true)
            }).disposed(by: disposeBag)
    }
    
}

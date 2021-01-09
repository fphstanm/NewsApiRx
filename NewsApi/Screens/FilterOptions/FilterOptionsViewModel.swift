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
    private lazy var previousSelectedItemIndex: Int = filter.options.firstIndex { $0.isSelected == true } ?? 0
    
    let filterItemCellId = String(describing: FilterItemCell.self)
    
    let itemsRx = BehaviorRelay<[ArticlesFilterOption]>(value: [])
    
    var isMultipleSelectionEnabled = false
    
    var filter: ArticlesFilterModel
    
    lazy var title = "Choose a \(filter.name)"
    
    
    // MARK: init
    
    init(filterType: ArticlesFilterType) {
        filter = filterManager.getFilter(ofType: filterType)
    }
    
    // MARK: handlers
    
    func handleViewDidLoad() {
        switch filter.type {
        case .sources:
            isMultipleSelectionEnabled = true
            
            if !filter.options.isEmpty {
                itemsRx.accept(filter.options)
            } else {
                getSources() { sources in
                    let items = self.formSourcesFilterItems(fromSources: sources)
                    self.filterManager.updateFilterItems(filterOfType: self.filter.type, items: items)
                    self.itemsRx.accept(items)
                }
            }
        default:
            itemsRx.accept(filter.options)
        }
    }
    
    func handleDidSelectItem(withIndex index: Int) {
        if index == previousSelectedItemIndex {
            filter.options[index].isSelected = !filter.options[index].isSelected
            if filter.options[index].isSelected {
                filter.selectedOption = filter.options[index].name
            }
        } else {
            if !isMultipleSelectionEnabled {
                filter.options[previousSelectedItemIndex].isSelected = false
            }
            filter.options[index].isSelected = true
            filter.selectedOption = filter.options[index].name
            
            previousSelectedItemIndex = index
        }
    }
    
    // MARK: network
    
    private func getSources(completion: @escaping (([Source]) -> ())) {
        ApiClient.getSources()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { sourcesModel in
                guard let sources = sourcesModel.sources
                else { return }
                completion(sources)
            }, onError: { error in
                print("Error: ", error)
            }).disposed(by: disposeBag)
    }
    
    private func formSourcesFilterItems(fromSources sources: [Source]) -> [ArticlesFilterOption]{
        var sourcesItems: [ArticlesFilterOption] = []
        sources.forEach { source in
            guard let name = source.name, let id = source.id else { return }
            let item = ArticlesFilterOption(name: name, id: id, isSelected: false)
            sourcesItems.append(item)
        }
        return sourcesItems
    }

}

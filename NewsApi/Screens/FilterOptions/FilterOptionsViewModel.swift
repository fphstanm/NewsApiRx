//
//  FilterOptionsViewModel.swift
//  NewsApi
//
//  Created by Philip on 09.01.2021.
//

import Foundation

final class FilterOptionsViewModel {
    private let filterManager = ArticlesFilterManager.shared
    private lazy var previousSelectedItemIndex: Int = filter.options.firstIndex { $0.isSelected == true } ?? 0
    
    let filterItemCellId = String(describing: FilterItemCell.self)
    
    var filter: ArticlesFilterModel
    
    lazy var title = "Choose a \(filter.name)"
    
    
    // MARK: init
    
    init(filterType: ArticlesFilterType) {
        filter = filterManager.getFilter(ofType: filterType)
    }
    
    // MARK: handlers
    
    func handleDidSelectItem(withIndex index: Int) {
        if index == previousSelectedItemIndex {
            filter.options[index].isSelected = !filter.options[index].isSelected
            if filter.options[index].isSelected {
                filter.selectedOption = filter.options[index].name
            }
        } else {
            filter.options[previousSelectedItemIndex].isSelected = false
            filter.options[index].isSelected = true
            filter.selectedOption = filter.options[index].name
            
            previousSelectedItemIndex = index
        }
    }

}

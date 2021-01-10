//
//  FiltersViewModel.swift
//  NewsApi
//
//  Created by Philip on 07.01.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class FiltersViewModelState {
    let filters = BehaviorRelay<[ArticlesFilterModel]>(value: [])
}

final class FiltersViewModel {
    
    private let filterManager = ArticlesFilterManager.shared
    
    private var bufferFilters: [ArticlesFilterModel] = []
    
    let state = FiltersViewModelState()
    
    
    // MARK: - handlers
    
    func handleViewDidLoad() {
        bufferFilters = filterManager.filters
        state.filters.accept(bufferFilters)
    }
    
    func handleFilterTapped(ofType type: ArticlesFilterType) {
        let singleFilterType: ArticlesFilterType = .sources
        
        if type == singleFilterType {
            bufferFilters.forEach { $0.isActive = $0.type == singleFilterType }
        } else {
            bufferFilters.forEach { $0.isActive = $0.type != singleFilterType }
        }
        
        state.filters.accept(bufferFilters)
    }
}

//
//  FiltersViewModel.swift
//  NewsApi
//
//  Created by Philip on 07.01.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class FiltersViewModel {
    
    private let filterManager = ArticlesFilterManager.shared

    let filtersRx = BehaviorRelay<[ArticlesFilterModel]>(value: [])
    var filters: [ArticlesFilterModel] = []
    var selectedFilters: [ArticlesFilterType] = []
    
    
    func handleViewDidLoad() {
        filtersRx.accept(filters)
        filters = filterManager.filters
        selectedFilters = filters.filter { $0.isActive }.map { $0.type }
    }
    
    func handleFilterTapped(ofType type: ArticlesFilterType) {
        let singleFilterType: ArticlesFilterType = .sources
        
        if type == singleFilterType {
            filters.forEach { $0.isActive = $0.type == singleFilterType }
        } else {
            filters.forEach { $0.isActive = $0.type != singleFilterType }
        }
        
        filtersRx.accept(filters)
    }
}

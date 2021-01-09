//
//  ArticlesFilterManager.swift
//  NewsApi
//
//  Created by Philip on 09.01.2021.
//

import Foundation

public typealias Parameters = [String: Any]

class ArticlesFilterManager {
    
    static let shared = ArticlesFilterManager()
    
    public private(set) var filters: [ArticlesFilterModel]
    
    var parameters: Parameters {
        return transformFiltersToRequestParameters(filters: filters)
    }
    
    // MARK: init
    
    private init() {
        filters = [
            ArticlesFilterModel(name: "Country",
                           type: .country,
                           items: [ArticlesFilterItem(name: "Ukraine", id: "ua", isSelected: true),
                                     ArticlesFilterItem(name: "USA", id: "us", isSelected: false),
                                     ArticlesFilterItem(name: "Russia", id: "ru", isSelected: false),
                                     ArticlesFilterItem(name: "France", id: "fr", isSelected: false)],
                           isActive: true),
            ArticlesFilterModel(name: "Category",
                           type: .category,
                           items: [ArticlesFilterItem(name: "Business", id: "business", isSelected: false),
                                     ArticlesFilterItem(name: "Sport", id: "sport", isSelected: false)],
                           isActive: false),
            ArticlesFilterModel(name: "Sources",
                           type: .sources,
                           items: [],
                           isActive: false)
        ]
    }
    
    // MARK: public methods
    
    func getFilter(ofType type: ArticlesFilterType) -> ArticlesFilterModel {
        return filters.filter { $0.type == type }.first!
    }
    
    func updateFilterItems(filterOfType type: ArticlesFilterType, items: [ArticlesFilterItem]) {
        guard let index = (filters.firstIndex { $0.type == type }) else { return }
        filters[index].items = items
    }
    
    func updateFilters(_ filters: [ArticlesFilterModel]) {
        self.filters = filters
    }
    
    // MARK: private methods
    
    private func transformFiltersToRequestParameters(filters: [ArticlesFilterModel]) -> Parameters {
        var parameters: Parameters = [:]
        
        filters.forEach { filter in
            if filter.isActive {
                filter.items.forEach { option in
                    if option.isSelected {
                        parameters[filter.type.rawValue] = option.id
                    }
                }
            }
        }
        
        return parameters
    }
    
}

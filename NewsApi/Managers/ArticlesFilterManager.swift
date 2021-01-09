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
            ArticlesFilterModel(name: "Coutry",
                           type: .country,
                           defaultOption: "Select country",
                           options: [ArticlesFilterOption(name: "Ukraine", id: "ua", isSelected: true),
                                     ArticlesFilterOption(name: "USA", id: "us", isSelected: false),
                                     ArticlesFilterOption(name: "Russia", id: "ru", isSelected: false),
                                     ArticlesFilterOption(name: "France", id: "fr", isSelected: false)],
                           isActive: true),
            ArticlesFilterModel(name: "Category",
                           type: .category,
                           defaultOption: "Select category",
                           options: [ArticlesFilterOption(name: "Business", id: "business", isSelected: false),
                                     ArticlesFilterOption(name: "Sport", id: "sport", isSelected: false)],
                           isActive: false),
            ArticlesFilterModel(name: "Sources",
                           type: .sources,
                           defaultOption: "Select sources",
                           options: [],
                           isActive: false)
        ]
    }
    
    // MARK: public methods
    
    func getFilter(ofType type: ArticlesFilterType) -> ArticlesFilterModel {
        return filters.filter { $0.type == type }.first!
    }
    
    func updateFilterItems(filterOfType type: ArticlesFilterType, items: [ArticlesFilterOption]) {
        guard let index = (filters.firstIndex { $0.type == type }) else { return }
        filters[index].options = items
    }
    
    func updateFilters(_ filters: [ArticlesFilterModel]) {
        self.filters = filters
    }
    
    // MARK: private methods
    
    private func transformFiltersToRequestParameters(filters: [ArticlesFilterModel]) -> Parameters {
        var parameters: Parameters = [:]
        
        filters.forEach { filter in
            if filter.isActive {
                filter.options.forEach { option in
                    if option.isSelected {
                        parameters[filter.type.rawValue] = option.id
                    }
                }
            }
        }
        
        return parameters
    }
    
}

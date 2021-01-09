//
//  ArticlesFilter.swift
//  NewsApi
//
//  Created by Philip on 09.01.2021.
//

import Foundation

class ArticlesFilterModel {
    let name: String
    let type: ArticlesFilterType
    var items: [ArticlesFilterItem]
    let isActive: Bool
    
    var selectedItems: [String] {
        items
            .filter { $0.isSelected }
            .map { $0.name }
    }
    
    init(name: String,
         type: ArticlesFilterType,
         items: [ArticlesFilterItem],
         isActive: Bool) {
        self.name = name
        self.type = type
        self.items = items
        self.isActive = isActive
    }
}

class ArticlesFilterItem {
    let name: String
    let id: String
    var isSelected: Bool
    
    init(name: String, id: String, isSelected: Bool) {
        self.name = name
        self.id = id
        self.isSelected = isSelected
    }
    
}

enum ArticlesFilterType: String {
    case country = "country"
    case category = "category"
    case sources = "sources"
}

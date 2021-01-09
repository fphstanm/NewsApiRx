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
    let defaultOption: String
    var options: [ArticlesFilterOption]
    let isActive: Bool
    
    lazy var selectedOption: String? = {
        options.filter { $0.isSelected }.first?.name
    }()
    
    init(name: String,
         type: ArticlesFilterType,
         defaultOption: String,
         options: [ArticlesFilterOption],
         isActive: Bool) {
        self.name = name
        self.type = type
        self.defaultOption = defaultOption
        self.options = options
        self.isActive = isActive
    }
}

class ArticlesFilterOption {
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

//
//  FiltersViewModel.swift
//  NewsApi
//
//  Created by Philip on 07.01.2021.
//

import Foundation
import RxSwift
import RxCocoa

struct ArticlesFilter {
    let name: String
    let type: ArticlesFilterType
    let selectedOption: String?
    let defaultOption: String
    let options: [ArticlesFilterOption]
    let isActive: Bool
}

struct ArticlesFilterOption {
    let name: String
    let id: String
    var isSelected: Bool
}

enum ArticlesFilterType {
    case country
    case category
    case sources
}

final class FiltersViewModel {
    
    // TODO: Replace publishReley
    let filters = BehaviorRelay<[ArticlesFilter]>(value: [])
    
    
    func handleViewDidLoad() {
        let filters = [
            ArticlesFilter(name: "Coutry",
                           type: .country,
                           selectedOption: nil,
                           defaultOption: "Select country",
                           options: [ArticlesFilterOption(name: "Ukraine", id: "ua", isSelected: false),
                                     ArticlesFilterOption(name: "USA", id: "us", isSelected: false)],
                           isActive: false),
            ArticlesFilter(name: "Category",
                           type: .category,
                           selectedOption: nil,
                           defaultOption: "Select category",
                           options: [ArticlesFilterOption(name: "Business", id: "business", isSelected: false),
                                     ArticlesFilterOption(name: "Sport", id: "sport", isSelected: false)],
                           isActive: false),
            ArticlesFilter(name: "Sources",
                           type: .sources,
                           selectedOption: nil,
                           defaultOption: "Select sources",
                           options: [ArticlesFilterOption(name: "Source", id: "sourceID", isSelected: false)],
                           isActive: false)
        ]
        
        self.filters.accept(filters)
    }
}

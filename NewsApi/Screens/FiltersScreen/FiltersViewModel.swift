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
    let selectedOption: String?
    let defaultOption: String
    let options: [String]
    let isActive: Bool
}

final class FiltersViewModel {
    
    let filters = PublishRelay<[ArticlesFilter]>()

//    let filtersObs = Observable<[ArticlesFilter]>()
    
    init() {

    }
    
    func handleViewDidLoad() {
        let filters = [
            ArticlesFilter(name: "Coutry",
                           selectedOption: nil,
                           defaultOption: "Select country",
                           options: ["us", "ua"],
                           isActive: false),
            ArticlesFilter(name: "Category",
                           selectedOption: nil,
                           defaultOption: "Select category",
                           options: ["business", "sport"],
                           isActive: false),
            ArticlesFilter(name: "Sources",
                           selectedOption: nil,
                           defaultOption: "Select sources",
                           options: [""],
                           isActive: false)
        ]
        
        self.filters.accept(filters)
    }
}

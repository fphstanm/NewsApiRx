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
    
    
    func handleViewDidLoad() {
        self.filtersRx.accept(filters)
        self.filters = filterManager.filters
    }
}

//
//  NewsViewModel.swift
//  NewsApi
//
//  Created by Philip on 04.01.2021.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class ArticlesViewModel: BaseViewModel {

    // TODO: Replace publishReley
    let articles = BehaviorRelay<[Article]>(value: [])
    var filters: [ArticlesFilterModel] = [
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
                       isActive: true),
        ArticlesFilterModel(name: "Sources",
                       type: .sources,
                       defaultOption: "Select sources",
                       options: [ArticlesFilterOption(name: "Source", id: "sourceID", isSelected: false)],
                       isActive: false)
    ]
    
    var parameters: Parameters {
        transformFiltersToRequestParameters(filters: filters)
    }
    
    
    // MARK: Handlers
    
    func handleViewDidLoad() {
        getNews(parameters: parameters)
    }
    
    func handleRefreshArticles(completion: @escaping (() -> ())) {
        getNews(parameters: parameters) {
            completion()
        }
    }
    
    func transformFiltersToRequestParameters(filters: [ArticlesFilterModel]) -> Parameters {
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

    
    // MARK: Network
    
    private func getNews(parameters: Parameters? = nil, completion: @escaping (() -> ()) = {}) {
        let country = parameters?["country"] as? String ?? ""
        let sources = parameters?["source"] as? [String] ?? []
        let category = parameters?["category"] as? String ?? ""

        ApiClient.getTopHeadlines(country: country, category: category, sources: sources)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] news in
                guard let articles = news.articles else { return }
                self?.articles.accept(articles)
                completion()
            }, onError: { error in
                print("Error: ", error)
                completion()
            })
            .disposed(by: disposeBag)
    }
}



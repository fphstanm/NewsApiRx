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

    private let filterManager = ArticlesFilterManager.shared
    
    let articles = BehaviorRelay<[Article]>(value: [])
    
    var filters: [ArticlesFilterModel] {
        return filterManager.filters
    }
    
    // MARK: Handlers
    
    func handleViewDidLoad() {
        getNews(parameters: filterManager.parameters)
    }
    
    func handleRefreshArticles(completion: @escaping (() -> ())) {
        getNews(parameters: filterManager.parameters) {
            completion()
        }
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



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
    
    let searchSubject = PublishSubject<String>()
    
    let articles = BehaviorRelay<[Article]>(value: [])
    
    lazy var searchObserver: AnyObserver<String> = searchSubject.asObserver()
    
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
    
    func handleSearch(phrase: String) {
        print(phrase)
        getNews(parameters: filterManager.parameters, phrase: phrase, completion: {
            
        })
    }
    
    // MARK: Network
    
    private func getNews(parameters: Parameters? = nil, phrase: String? = nil, completion: @escaping (() -> ()) = {}) {
        let country = parameters?["country"] as? String
        let sources = parameters?["sources"] as? String
        let category = parameters?["category"] as? String

        ApiClient.getTopHeadlines(country: country, category: category, sources: sources, phrase: phrase)
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



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

final class ArticlesViewModelState {
    let searchText = PublishSubject<String>()
    let articles = BehaviorRelay<[Article]>(value: [])
    let isFetching = PublishRelay<Bool>()
    lazy var searchObserver: AnyObserver<String> = searchText.asObserver()
}

final class ArticlesViewModelParameters {
    var filters: [ArticlesFilterModel] = ArticlesFilterManager.shared.filters
}

final class ArticlesViewModel: BaseViewModel {
    private let filterManager = ArticlesFilterManager.shared

    let state = ArticlesViewModelState()

    let params = ArticlesViewModelParameters()
    
    
    // MARK: - Handlers
    
    func handleViewDidLoad() {
        getNews(parameters: filterManager.parameters)
    }
    
    func handleRefreshArticles() {
        getNews(parameters: filterManager.parameters)
    }
    
    func handleSearch(phrase: String) {
        print(phrase)
        getNews(parameters: filterManager.parameters, phrase: phrase)
    }
    
    // MARK: - Network
    
    private func getNews(parameters: Parameters? = nil, phrase: String? = nil) {
        
        // TODO: Should be removed
        let country = parameters?["country"] as? String
        let sources = parameters?["sources"] as? String
        let category = parameters?["category"] as? String

        state.isFetching.accept(true)
        
        ApiClient.getTopHeadlines(country: country, category: category, sources: sources, phrase: phrase)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] news in
                guard let articles = news.articles else { return }
                self?.state.articles.accept(articles)
            }, onError: { error in
                print("Error: ", error)
            }, onCompleted: {
                self.state.isFetching.accept(false)
            })
            .disposed(by: disposeBag)
    }
}



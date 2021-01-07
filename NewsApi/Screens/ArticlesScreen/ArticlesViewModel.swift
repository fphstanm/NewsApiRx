//
//  NewsViewModel.swift
//  NewsApi
//
//  Created by Philip on 04.01.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class ArticlesViewModel: BaseViewModel {

    // TODO: Replace publishReley
    let articles = BehaviorRelay<[Article]>(value: [])
    
    // MARK: Handlers
    
    func handleViewDidLoad() {
        getNews()
    }
    
    func handleRefreshArticles(completion: @escaping (() -> ())) {
        getNews() {
            completion()
        }
    }
    
    // MARK: Network
    
    private func getNews(completion: @escaping (() -> ()) = {}) {
        ApiClient.getTopHeadlines(country: "ua")
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



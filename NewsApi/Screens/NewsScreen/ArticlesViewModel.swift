//
//  NewsViewModel.swift
//  NewsApi
//
//  Created by Philip on 04.01.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class ArticlesViewModel {
    
    private let disposeBag = DisposeBag()

    let articles = PublishRelay<[Article]>()
    
    
    // MARK: Handlers
    
    func handleViewDidLoad() {
        getNews()
    }
    
    // MARK: Network
    
    private func getNews() {
        ApiClient.getTopHeadlines(country: "ua")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] news in
                guard let articles = news.articles else { return }
                self?.articles.accept(articles)
            }, onError: { error in
                print("Error: ", error)
            })
            .disposed(by: disposeBag)
    }
}



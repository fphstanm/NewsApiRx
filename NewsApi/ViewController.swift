//
//  ViewController.swift
//  NewsApi
//
//  Created by Philip on 04.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController {
    @IBOutlet private weak var postsTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    private var newsCellId: String { String(describing: NewsCell.self) }
        
    let articles = PublishRelay<[Article]>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupStateObservers()
    }
    
    private func setupSubviews() {
        postsTableView.register(UINib(nibName: newsCellId, bundle: nil), forCellReuseIdentifier: newsCellId)
    }
    
    private func setupStateObservers() {
        articles
            .asObservable()
            .bind(to: postsTableView.rx.items) {
                tableView, row, article in
                let cell = tableView.dequeueReusableCell(withIdentifier: self.newsCellId) as! NewsCell
                cell.setup(withArticle: article)
                
                return cell
            }.disposed(by: disposeBag)
    }
    
    private func getNews() {
        ApiClient.getNews()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { news in
                guard let articles = news.articles else { return }
                self.articles.accept(articles)
            }, onError: { error in
                print("Error: ", error)
            }, onCompleted: {
                self.postsTableView.reloadData()
            }, onDisposed: {
                
            })
            .disposed(by: disposeBag)
    }
    
}

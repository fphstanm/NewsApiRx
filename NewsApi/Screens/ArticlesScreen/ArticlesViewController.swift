//
//  ViewController.swift
//  NewsApi
//
//  Created by Philip on 04.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class ArticlesViewController: BaseViewController {
    
    @IBOutlet private weak var articlesTableView: UITableView!
    @IBOutlet private weak var filtersNavigationButton: UIBarButtonItem!
    
    private let articleCellID = String(describing: ArticleCell.self)
    
    private lazy var refreshControl = UIRefreshControl()
        
    private let viewModel = ArticlesViewModel()
    

    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupSubviews()
        setupObservers()
        setupRefreshControl()
        
        viewModel.handleViewDidLoad()
    }
    
    // MARK: - setup
    
    private func setupSubviews() {
        articlesTableView.register(UINib(nibName: articleCellID, bundle: nil), forCellReuseIdentifier: articleCellID)
        articlesTableView.tableFooterView = UIView()
    }
    
    private func setupObservers() {
        viewModel.articles
            .asObservable()
            .bind(to: articlesTableView.rx.items) {
                tableView, row, article in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: self.articleCellID) as! ArticleCell
                cell.setup(withArticle: article)
                
                return cell
            }.disposed(by: disposeBag)
        
        articlesTableView
            .rx
            .modelSelected(Article.self)
            .subscribe(onNext: { [weak self] article in
                guard let urlString = article.url else { return }
                self?.showArticleWebView(urlString: urlString)
            }).disposed(by: disposeBag)
        
        filtersNavigationButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.showFilters()
            }).disposed(by: disposeBag)
    }
    
    // TODO: make refresher rx way
    // MARK: RefreshControl
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        articlesTableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        viewModel.handleRefreshArticles() {
            sender.endRefreshing()
        }
    }
    
    // MARK: navigation
    
    private func showFilters() {
        guard let filtersVC = initControllerFromStoryboard(of: FiltersViewController.self) as? FiltersViewController else { return }
        filtersVC.viewModel.filters = viewModel.filters
        navigationController?.pushViewController(filtersVC, animated: true)
    }
    
    private func showArticleWebView(urlString: String) {
        guard let webVC = initControllerFromStoryboard(of: WebViewController.self) as? WebViewController else { return }
        webVC.urlString = urlString
        navigationController?.pushViewController(webVC, animated: true)
    }
}

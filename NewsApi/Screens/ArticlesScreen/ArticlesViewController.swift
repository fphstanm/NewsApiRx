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
    
    private let refreshControl = UIRefreshControl()
    
    private let searchController = UISearchController()
    
    private let articleCellID = String(describing: ArticleCell.self)
        
    private let viewModel = ArticlesViewModel()
    

    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupSubviews()
        setupBindings()
        
        viewModel.handleViewDidLoad()
    }
    
    // MARK: - setup methods
    
    private func setupSubviews() {
        articlesTableView.register(UINib(nibName: articleCellID, bundle: nil), forCellReuseIdentifier: articleCellID)
        articlesTableView.tableFooterView = UIView()
        articlesTableView.refreshControl = refreshControl
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            articlesTableView.tableHeaderView = searchController.searchBar
        }
    }
    
    private func setupBindings() {
        
        // == articlesTableView ==
        
        viewModel.state.articles
            .asObservable()
            .bind(to: articlesTableView.rx.items) { tableView, row, article in
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
        
        // == navigationButtons ==
        
        filtersNavigationButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.showFilters()
            }).disposed(by: disposeBag)
        
        // == searchController ==
        
        viewModel.state.searchText
            .asObservable()
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] phrase in
                self?.viewModel.handleSearch(phrase: phrase)
            }).disposed(by: disposeBag)
        
        searchController.searchBar
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.state.searchObserver)
            .disposed(by: disposeBag)
        
        searchController.searchBar
            .rx
            .cancelButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.viewModel.handleRefreshArticles()
            }).disposed(by: disposeBag)
        
        // == refreshControl ==
        
        viewModel.state.isFetching
            .asObservable()
            .subscribe(onNext: { [weak self] isFetching in
                if !isFetching {
                    self?.refreshControl.endRefreshing()
                }
            }).disposed(by: disposeBag)
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.handleRefreshArticles()
            }).disposed(by: disposeBag)
    }
    
    // MARK: - navigation
    
    private func showFilters() {
        guard let filtersVC = initControllerFromStoryboard(of: FiltersViewController.self) as? FiltersViewController else { return }
        navigationController?.pushViewController(filtersVC, animated: true)
    }
    
    private func showArticleWebView(urlString: String) {
        guard let webVC = initControllerFromStoryboard(of: WebViewController.self) as? WebViewController else { return }
        webVC.urlString = urlString
        navigationController?.pushViewController(webVC, animated: true)
    }
}

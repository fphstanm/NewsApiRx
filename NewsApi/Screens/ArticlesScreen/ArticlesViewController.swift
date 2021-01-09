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
                
                // TODO: Replace it with reactive technic
                let cell = tableView.dequeueReusableCell(withIdentifier: self.articleCellID) as! ArticleCell
                cell.setup(withArticle: article)

                return cell
            }.disposed(by: disposeBag)
        
        filtersNavigationButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.showFilters()
            }).disposed(by: disposeBag)
        
//        refreshControl
//            .rx.controlEvent(UIControlEvents.valueChanged)
//            .subscribe(onNext: { [weak self] in
//                self?.refreshControl.endRefreshing()
//            }, onCompleted: nil, onDisposed: nil)
//            .disposed(by: disposeBag)
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
}

extension ArticlesViewController: FiltersViewControllerDelegate {
    func updateFilters(filters: [ArticlesFilterModel]) {
        viewModel.filters = filters
    }
}

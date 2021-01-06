//
//  ViewController.swift
//  NewsApi
//
//  Created by Philip on 04.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class ArticlesViewController: UIViewController {
    @IBOutlet private weak var newsTableView: UITableView!
        
    private let disposeBag = DisposeBag()
    
    private let articleCellID = String(describing: ArticleCell.self)
        
    private let viewModel = ArticlesViewModel()
    
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top headlines"
        
        setupSubviews()
        setupObservers()
        
        viewModel.handleViewDidLoad()
    }
    
    // MARK: - setup
    
    private func setupSubviews() {
        newsTableView.register(UINib(nibName: articleCellID, bundle: nil), forCellReuseIdentifier: articleCellID)
    }
    
    private func setupObservers() {
        viewModel.articles
            .asObservable()
            .bind(to: newsTableView.rx.items) {
                tableView, row, article in
                
                // TODO: Replace it with reactive technic
                let cell = tableView.dequeueReusableCell(withIdentifier: self.articleCellID) as! ArticleCell
                cell.setup(withArticle: article)

                return cell
            }.disposed(by: disposeBag)
    }
    
}

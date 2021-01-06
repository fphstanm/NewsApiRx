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
    
    private let newsCellId = String(describing: NewsCell.self)
        
    private let viewModel = NewsViewModel()
    
    
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
        newsTableView.register(UINib(nibName: newsCellId, bundle: nil), forCellReuseIdentifier: newsCellId)
    }
    
    private func setupObservers() {
        viewModel.articles
            .asObservable()
            .bind(to: newsTableView.rx.items) {
                tableView, row, article in
                
                // TODO: Replace it with reactive technic
                let cell = tableView.dequeueReusableCell(withIdentifier: self.newsCellId) as! NewsCell
                cell.setup(withArticle: article)

                return cell
            }.disposed(by: disposeBag)
//        viewModel.articles
//            .asObservable()
//            .bind(to: newsTableView.rx.items(cellIdentifier: newsCellId, cellType: NewsCell.self)) { _,_,_ in in
//
//            }
    }
    
}

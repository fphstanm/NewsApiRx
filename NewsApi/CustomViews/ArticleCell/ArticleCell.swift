//
//  ArticleCell.swift
//  NewsApi
//
//  Created by Philip on 06.01.2021.
//

import UIKit
import Kingfisher

final class ArticleCell: UITableViewCell {
    
    @IBOutlet private weak var articleImage: UIImageView!
    @IBOutlet private weak var articleTitle: UILabel!
    @IBOutlet private weak var articleDescription: UILabel!
    @IBOutlet private weak var articleSource: UILabel!
    
    
    func setup(withArticle article: Article) {
        articleTitle.text = article.title
        articleDescription.text = article.descr
        articleSource.text = article.source?.name
        
        guard let imageUrlString = article.urlToImage else { return }
        articleImage.kf.setImage(with: URL(string: imageUrlString))
    }

}

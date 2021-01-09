//
//  NewsModel.swift
//  NewsApi
//
//  Created by Philip on 04.01.2021.
//

import Foundation

class ArticlesModel: Codable {
    var status: String?
    var totalResult: Int?
    var articles: [Article]?
}

class Article: Codable {
    var source: SourceInfo?
    var author: String?
    var title: String?
    var descr: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    private enum CodingKeys : String, CodingKey {
        case descr = "description"
        case source, author, title, url, urlToImage, publishedAt, content
    }
}

class SourceInfo: Codable {
    var id: String?
    var name: String?
}

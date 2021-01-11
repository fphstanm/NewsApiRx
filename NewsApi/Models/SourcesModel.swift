//
//  SourcesModel.swift
//  NewsApi
//
//  Created by Philip on 06.01.2021.
//

import Foundation

class SourcesModel: Codable {
    var sources: [Source]?
}

class Source: Codable {
    var id: String?
    var name: String?
    var descr: String?
    var url: String?
    var category: String?
    var language: String?
    var country: String?
    
    private enum CodingKeys : String, CodingKey {
        case descr = "description"
        case id, name, url, category, language, country
    }
}


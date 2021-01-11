//
//  APIConstants.swift
//  NewsApi
//
//  Created by Philip on 04.01.2021.
//

import Foundation

struct APIConstants {
    
    static let baseUrl = "https://newsapi.org/v2/"
    static let apiKey = "21f0cdebbaa641908dbf9c735724c9b9" //"21cacbba225c428583b807fe6a5971c1"
    
    //https://newsapi.org/v2/top-headlines?country=ua&apiKey=21cacbba225c428583b807fe6a5971c1
    
    struct Parameters {
        static let apiKey = "apikey"
        
        static let country = "country"
        static let sources = "sources"
        static let category = "category"
        static let q = "q" //To search a phrase
    }
    
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
}

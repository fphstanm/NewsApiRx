//
//  APIRouter.swift
//  NewsApi
//
//  Created by Philip on 04.01.2021.
//

import Foundation
import Alamofire

//top-headlines


enum ApiRouter: URLRequestConvertible {
    
    case topHeadlines(country: String?, category: String?, sources: String?, phrase: String?)
    case everything
    case sources
    
    //"https://newsapi.org/v2/top-headlines?country=ua&apiKey=21cacbba225c428583b807fe6a5971c1"
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try APIConstants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField: APIConstants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField: APIConstants.HttpHeaderField.contentType.rawValue)
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        var completeParameters = parameters ?? [:]
        // add apiKey
        completeParameters[APIConstants.Parameters.apiKey] = APIConstants.apiKey
        
        let urlRequestPrint = try encoding.encode(urlRequest, with: completeParameters)
        print(" -> -> ", urlRequestPrint.url ?? "")
        
        return try encoding.encode(urlRequest, with: completeParameters)
    }
    
    //MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
            
        case .topHeadlines:
            return .get
            
        case .everything:
            return .get
            
        case .sources:
            return .get
        }
    }
    
    //MARK: - Path
    private var path: String {
        switch self {
            
        case .topHeadlines:
            return "top-headlines"
            
        case .everything:
            return "everything"
            
        case .sources:
            return "sources"
        }
    }
    
    // TODO: think about better implementation of optional parameters in dictionary
    //MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .topHeadlines(let country, let category, let sources, let phrase):
            var completeParameters: Parameters = [:]
            if let country = country {
                completeParameters[APIConstants.Parameters.country] = country
            }
            if let category = category {
                completeParameters[APIConstants.Parameters.category] = category
            }
            if let sources = sources {
                completeParameters[APIConstants.Parameters.sources] = sources
            }
            if let phrase = phrase {
                completeParameters[APIConstants.Parameters.q] = phrase
            }
            return completeParameters

        case .everything:
            return [:]
            
        case .sources:
            return [:]
        }
    }
}

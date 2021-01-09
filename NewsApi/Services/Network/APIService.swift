//
//  APIService.swift
//  NewsApi
//
//  Created by Philip on 04.01.2021.
//

import Foundation
import Alamofire
import RxSwift

class ApiClient {
    
    static func getTopHeadlines(country: String? = nil,
                                category: String? = nil,
                                sources: String? = nil) -> Observable<ArticlesModel> {
        return request(ApiRouter.topHeadlines(country: country, category: category, sources: sources))
    }
    
    static func getSources() -> Observable<SourcesModel> {
        return request(ApiRouter.sources)
    }
    
    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            
            //Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

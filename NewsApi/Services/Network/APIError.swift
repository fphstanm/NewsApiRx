//
//  APIError.swift
//  NewsApi
//
//  Created by Philip on 04.01.2021.
//

import Foundation

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}

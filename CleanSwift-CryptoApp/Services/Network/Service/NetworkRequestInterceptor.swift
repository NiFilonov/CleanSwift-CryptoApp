//
//  NetworkRequestInterceptor.swift
//  CleanSwift-CryptoApp
//
//  Created by Nikita Filonov on 31.03.2025.
//

import Foundation
import Alamofire

protocol NetworkRequestInterceptorOutput : AnyObject {
    func authorizationLost(_ interceptor: NetworkRequestInterceptor, request: Request)
}

class NetworkRequestInterceptor : RequestInterceptor {

    weak var output: NetworkRequestInterceptorOutput?
    
    let retryLimit: UInt
    let retryDelay: TimeInterval
    
    init(retryLimit: UInt, retryDelay: TimeInterval) {
        self.retryLimit = retryLimit
        self.retryDelay = retryDelay
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void) {
            let response = request.task?.response as? HTTPURLResponse

            if let statusCode = response?.statusCode {
                switch statusCode {
                case 401:
                    output?.authorizationLost(self, request: request)
                    return completion(.doNotRetry)
                case 500..<600:
                    if request.retryCount < retryLimit {
                        completion(.retryWithDelay(retryDelay))
                    } else {
                        return completion(.doNotRetry)
                    }
                default:
                    return completion(.doNotRetry)
                }
            } else {
                return completion(.doNotRetry)
            }
      }
}


//
//  ErrorInfo.swift
//  CleanSwift-CryptoApp
//
//  Created by Nikita Filonov on 31.03.2025.
//

import Foundation

struct ErrorInfo: Error, Decodable {
    let errorData: Data?
    let statusCode: Int?
    
    init(errorData: Data?, statusCode: Int?) {
        self.errorData = errorData
        self.statusCode = statusCode
    }
    
    static var unknown = ErrorInfo(errorData: nil, statusCode: 401)
}

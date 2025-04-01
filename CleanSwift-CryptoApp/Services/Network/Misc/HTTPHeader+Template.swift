//
//  HTTPHeader+Template.swift
//  CleanSwift-CryptoApp
//
//  Created by Nikita Filonov on 31.03.2025.
//

import Alamofire

extension HTTPHeaders {
    static var defaultHeaders: HTTPHeaders {
        var headers = [HTTPHeader]()
        headers.append(HTTPHeader.acceptTextPlain)
        headers.append(HTTPHeader.token)
        return HTTPHeaders(headers)
    }
}

extension HTTPHeader {
    static let acceptTextPlain = HTTPHeader(name: "accept", value: "text/plain")
    static let acceptApplicationJson = HTTPHeader(name: "accept", value: "application/json")
    static let token: HTTPHeader = HTTPHeader(name: "X-API-Key", value: ApiConfig.token)
}

//
//  NetworkService.swift
//  CleanSwift-CryptoApp
//
//  Created by Nikita Filonov on 31.03.2025.
//

import Foundation
import Alamofire

protocol NetworkServicing {}

class NetworkService: NetworkServicing {
    
    enum Constants {
        static let urlApi = URL(string: "https://rest.coinapi.io/")!
        static let retryLimit = UInt(4)
        static let retryDelay = TimeInterval(1)
        static let timeout = TimeInterval(20)
        static let httpMaximumConnectionsPerHost = 3
    }
    
    static let requestInterceptor = NetworkRequestInterceptor(retryLimit: Constants.retryLimit,
                                                              retryDelay: Constants.retryDelay)
    
    static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = Constants.timeout
        configuration.httpMaximumConnectionsPerHost = Constants.httpMaximumConnectionsPerHost
        configuration.httpShouldUsePipelining = true
        return Session(configuration: configuration,
                       interceptor: requestInterceptor)
    }()
    
    func getRequest(_ endpointName: String,
                    parameters: Parameters? = nil,
                    headers: HTTPHeaders? = nil,
                    encoding: ParameterEncoding = URLEncoding(boolEncoding: .literal),
                    completion: @escaping (Result<Void, ErrorInfo>) -> Void) {
        
        NetworkService.sessionManager.request(Constants.urlApi.appendingPathComponent(endpointName),
                                              parameters: parameters,
                                              encoding: encoding,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success(_):
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(ErrorInfo(errorData: response.data, statusCode: error.responseCode)))
            }
        }
    }
    
    func getRequest<R: Decodable>(_ endpointName: String,
                                  parameters: Parameters? = nil,
                                  headers: HTTPHeaders? = nil,
                                  completion: @escaping (Result<R, ErrorInfo>) -> Void) {
        
        NetworkService.sessionManager.request(Constants.urlApi.appendingPathComponent(endpointName),
                                              parameters: parameters,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: R.self) { response in
            switch response.result {
            case .success(let reply):
                completion(.success(reply))
            case .failure(let error):
                completion(.failure(ErrorInfo(errorData: response.data, statusCode: error.responseCode)))
            }
        }
    }
    
    func getRequestImage(_ endpointName: String,
                         completion: @escaping (Result<Data, ErrorInfo>) -> Void) {
        
        NetworkService.sessionManager.request(endpointName)
            .responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(ErrorInfo(errorData: response.data, statusCode: error.responseCode)))
                }
            })
    }
    
    func postRequest(_ endpointName: String,
                     urlParameters: Parameters? = nil,
                     headers: HTTPHeaders? = nil,
                     encoding: ParameterEncoding = URLEncoding(arrayEncoding: .indexInBrackets, boolEncoding: .literal),
                     completion: @escaping (Result<Void, ErrorInfo>) -> Void)
    {
        var url = Constants.urlApi.appendingPathComponent(endpointName)
        if let parameters = urlParameters, let newUrl = url.appending(parameters) {
            url = newUrl
        }
        NetworkService.sessionManager.request(url,
                                              method: .post,
                                              encoding: encoding,
                                              headers: headers)
        .validate()
        .response { response in
            switch response.result {
            case .success:
                completion(.success(Void()))
            case .failure(_):
                completion(.failure(.unknown))
            }
        }
    }
    
    func postRequest<P: Encodable>(_ endpointName: String,
                                   parameters: P,
                                   urlParameters: Parameters? = nil,
                                   headers: HTTPHeaders? = nil,
                                   completion: @escaping (Result<Void, ErrorInfo>) -> Void)
    {
        var jsonBody = Parameters()
        do {
            let data = try JSONEncoder().encode(parameters)
            jsonBody = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Parameters
        } catch {
            completion(.failure(.unknown))
        }
        var url = Constants.urlApi.appendingPathComponent(endpointName)
        if let parameters = urlParameters, let newUrl = url.appending(parameters) {
            url = newUrl
        }
        NetworkService.sessionManager.request(url,
                                              method: .post,
                                              parameters: jsonBody,
                                              encoding: JSONEncoding.default,
                                              headers: headers)
        .validate()
        .response { response in
            switch response.result {
            case .success:
                completion(.success(Void()))
            case .failure(_):
                completion(.failure(.unknown))
            }
        }
    }
    
    func postRequest<P: Encodable, R: Decodable>(_ endpointName: String,
                                                 parameters: P,
                                                 urlParameters: Parameters? = nil,
                                                 headers: HTTPHeaders? = nil,
                                                 encoder: ParameterEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(boolEncoding: .literal)),
                                                 completion: @escaping (Result<R, ErrorInfo>) -> Void) {
        var jsonBody = Parameters()
        do {
            let data = try JSONEncoder().encode(parameters)
            jsonBody = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Parameters
        } catch {
            completion(.failure(.unknown))
        }
        var url = Constants.urlApi.appendingPathComponent(endpointName)
        if let uParameters = urlParameters, let newUrl = url.appending(uParameters) {
            url = newUrl
        }
        
        NetworkService.sessionManager.request(url,
                                              method: .post,
                                              parameters: jsonBody,
                                              encoding: JSONEncoding.default,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: R.self) { response in
            switch response.result {
            case .success(let reply):
                completion(.success(reply))
            case .failure(let error):
                completion(.failure(ErrorInfo(errorData: response.data, statusCode: error.responseCode)))
            }
        }
    }
    
    func putRequest<P: Encodable, R: Decodable>(_ endpointName: String,
                                                parameters: P,
                                                urlParameters: Parameters? = nil,
                                                headers: HTTPHeaders? = nil,
                                                encoder: ParameterEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(boolEncoding: .literal)),
                                                completion: @escaping (Result<R, ErrorInfo>) -> Void) {
        var jsonBody = Parameters()
        do {
            let data = try JSONEncoder().encode(parameters)
            jsonBody = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Parameters
        } catch {
            completion(.failure(.unknown))
        }
        var url = Constants.urlApi.appendingPathComponent(endpointName)
        if let uParameters = urlParameters, let newUrl = url.appending(uParameters) {
            url = newUrl
        }
        
        NetworkService.sessionManager.request(url,
                                              method: .put,
                                              parameters: jsonBody,
                                              encoding: JSONEncoding.default,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: R.self) { response in
            switch response.result {
            case .success(let reply):
                completion(.success(reply))
            case .failure(let error):
                completion(.failure(ErrorInfo(errorData: response.data, statusCode: error.responseCode)))
            }
        }
    }
    
    func putRequest<P: Encodable>(_ endpointName: String,
                                  parameters: P,
                                  urlParameters: Parameters? = nil,
                                  headers: HTTPHeaders? = nil,
                                  encoding: ParameterEncoding = URLEncoding(arrayEncoding: .indexInBrackets, boolEncoding: .literal),
                                  completion: @escaping (Result<Void, ErrorInfo>) -> Void)
    {
        var jsonBody = Parameters()
        do {
            let data = try JSONEncoder().encode(parameters)
            jsonBody = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Parameters
        } catch {
            completion(.failure(.unknown))
        }
        var url = Constants.urlApi.appendingPathComponent(endpointName)
        if let parameters = urlParameters, let newUrl = url.appending(parameters) {
            url = newUrl
        }
        NetworkService.sessionManager.request(url,
                                              method: .put,
                                              parameters: jsonBody,
                                              encoding: JSONEncoding.default,
                                              headers: headers)
        .validate()
        .response { response in
            switch response.result {
            case .success:
                completion(.success(Void()))
            case .failure(_):
                completion(.failure(.unknown))
            }
        }
    }
    
    func deleteRequest<R: Decodable>(_ endpointName: String,
                                     parameters: Parameters? = nil,
                                     headers: HTTPHeaders? = nil,
                                     completion: @escaping (Result<R, ErrorInfo>) -> Void) {
        
        NetworkService.sessionManager.request(Constants.urlApi.appendingPathComponent(endpointName),
                                              method: .delete,
                                              parameters: parameters,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: R.self) { response in
            switch response.result {
            case .success(let reply):
                completion(.success(reply))
            case .failure(let error):
                completion(.failure(ErrorInfo(errorData: response.data, statusCode: error.responseCode)))
            }
        }
    }
    
    func deleteRequest(_ endpointName: String,
                       parameters: Parameters? = nil,
                       headers: HTTPHeaders? = nil,
                       completion: @escaping (Result<Void, ErrorInfo>) -> Void) {
        
        NetworkService.sessionManager.request(Constants.urlApi.appendingPathComponent(endpointName),
                                              method: .delete,
                                              parameters: parameters,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success(_):
                completion(.success({}()))
            case .failure(let error):
                completion(.failure(ErrorInfo(errorData: response.data, statusCode: error.responseCode)))
            }
        }
    }
}

extension URL {
    func appending(_ parameters: Parameters) -> URL? {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        
        parameters.forEach {
            let queryItem = URLQueryItem(name: $0.key, value: "\($0.value)")
            queryItems.append(queryItem)
        }
        
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}


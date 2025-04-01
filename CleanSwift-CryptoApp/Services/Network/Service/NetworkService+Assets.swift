//
//  NetworkService+Assets.swift
//  CleanSwift-CryptoApp
//
//  Created by Nikita Filonov on 31.03.2025.
//

import Foundation

protocol AssetsNetworkServicing {
    func getAssets(completion: @escaping ((Result<[AssetDTO], ErrorInfo>) -> Void))
}

extension NetworkService: AssetsNetworkServicing {
    
    private enum EnpointName {
        static let assets = "/v1/assets"
    }
    
    func getAssets(completion: @escaping ((Result<[AssetDTO], ErrorInfo>) -> Void)) {
        getRequest(EnpointName.assets,
                   headers: .defaultHeaders,
                   completion: completion)
    }
}

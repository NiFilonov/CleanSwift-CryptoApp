//
//  ApiConfig.swift
//  CleanSwift-CryptoApp
//
//  Created by Nikita Filonov on 31.03.2025.
//

import Foundation

enum ApiConfig {
    private static let plistName = "ApiInfo"
    
    private static var plist: [String: Any]? {
        guard let path = Bundle.main.path(forResource: plistName, ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainers, format: nil) as? [String: Any]
        else {
            fatalError("ApiInfo.plist not found")
        }
        return plist
    }
    
    static var token: String {
        guard let value = plist?["API_TOKEN"] as? String else {
            fatalError("API_TOKEN not set in plist")
        }
        return value
    }
    
    static var baseURL: String {
        guard let value = plist?["BASE_URL"] as? String else {
            fatalError("BASE_URL not set in plist")
        }
        return value
    }
}

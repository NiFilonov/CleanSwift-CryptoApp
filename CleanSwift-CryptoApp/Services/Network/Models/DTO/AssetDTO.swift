//
//  AssetDTO.swift
//  CleanSwift-CryptoApp
//
//  Created by Nikita Filonov on 31.03.2025.
//

import Foundation

struct AssetDTO: Codable {
    struct ChainAddress: Codable {
        let chainId: String?
        let networkId: String?
        let address: String?
        
        enum CodingKeys: String, CodingKey {
            case chainId = "chain_id"
            case networkId = "network_id"
            case address
        }
    }
    
    let assetId: String?
    let name: String?
    let typeIsCrypto: Int?
    let dataQuoteStart: String?
    let dataQuoteEnd: String?
    let dataOrderbookStart: String?
    let dataOrderbookEnd: String?
    let dataTradeStart: String?
    let dataTradeEnd: String?
    let dataSymbolsCount: Int?
    let volume1HrsUsd: Double?
    let volume1DayUsd: Double?
    let volume1MthUsd: Double?
    let priceUsd: Double?
    let chainAddresses: [ChainAddress]?
    let dataStart: String?
    let dataEnd: String?
    
    enum CodingKeys: String, CodingKey {
        case assetId = "asset_id"
        case name
        case typeIsCrypto = "type_is_crypto"
        case dataQuoteStart = "data_quote_start"
        case dataQuoteEnd = "data_quote_end"
        case dataOrderbookStart = "data_orderbook_start"
        case dataOrderbookEnd = "data_orderbook_end"
        case dataTradeStart = "data_trade_start"
        case dataTradeEnd = "data_trade_end"
        case dataSymbolsCount = "data_symbols_count"
        case volume1HrsUsd = "volume_1hrs_usd"
        case volume1DayUsd = "volume_1day_usd"
        case volume1MthUsd = "volume_1mth_usd"
        case priceUsd = "price_usd"
        case chainAddresses = "chain_addresses"
        case dataStart = "data_start"
        case dataEnd = "data_end"
    }
}

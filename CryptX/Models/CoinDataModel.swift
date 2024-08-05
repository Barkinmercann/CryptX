//
//  CoinDataModel.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 24.07.2024.
//

import Foundation

// MARK: - CoinDataModel
struct CoinDataModel: Codable {
    let status: Status?
    let data: [String: Coin]?
}

// MARK: - Coin
struct Coin: Codable {
    let id: Int?
    let name, symbol, slug: String?
    let numMarketPairs: Int?
    let dateAdded: String?
    let tags: [Tag]?
    let maxSupply: Int?
    let circulatingSupply, totalSupply: Double?
    let isActive: Int?
    let infiniteSupply: Bool?
    let platform: String?
    let cmcRank: Int?
    let isFiat: Int?
    let selfReportedCirculatingSupply: Double?
    let selfReportedMarketCap: SelfReportedMarketCap?
    let tvlRatio: Double?
    let lastUpdated: String?
    let quote: Quote?

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, slug
        case numMarketPairs = "num_market_pairs"
        case dateAdded = "date_added"
        case tags
        case maxSupply = "max_supply"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case isActive = "is_active"
        case infiniteSupply = "infinite_supply"
        case platform
        case cmcRank = "cmc_rank"
        case isFiat = "is_fiat"
        case selfReportedCirculatingSupply = "self_reported_circulating_supply"
        case selfReportedMarketCap = "self_reported_market_cap"
        case tvlRatio = "tvl_ratio"
        case lastUpdated = "last_updated"
        case quote
    }
}

// MARK: - Quote
struct Quote: Codable {
    let usd: Usd?

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

// MARK: - Usd
struct Usd: Codable {
    let price, volume24H, volumeChange24H, percentChange1H: Double?
    let percentChange24H, percentChange7D, percentChange30D, percentChange60D: Double?
    let percentChange90D, marketCap, marketCapDominance, fullyDilutedMarketCap: Double?
    let tvl: Double?
    let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case price
        case volume24H = "volume_24h"
        case volumeChange24H = "volume_change_24h"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
        case percentChange30D = "percent_change_30d"
        case percentChange60D = "percent_change_60d"
        case percentChange90D = "percent_change_90d"
        case marketCap = "market_cap"
        case marketCapDominance = "market_cap_dominance"
        case fullyDilutedMarketCap = "fully_diluted_market_cap"
        case tvl
        case lastUpdated = "last_updated"
    }
}

enum SelfReportedMarketCap: Codable {
    case double(Double)
    case integer(Int)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let xyz = try? container.decode(Int.self) {
            self = .integer(xyz)
            return
        }
        if let xyz = try? container.decode(Double.self) {
            self = .double(xyz)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(SelfReportedMarketCap.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for SelfReportedMarketCap"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let xyz):
            try container.encode(xyz)
        case .integer(let xyz):
            try container.encode(xyz)
        case .null:
            try container.encodeNil()
        }
    }
}

// MARK: - Tag
struct Tag: Codable {
    let slug, name: String?
    let category: Category?
}

enum Category: String, Codable {
    case algorithm = "ALGORITHM"
    case category = "CATEGORY"
    case industry = "INDUSTRY"
    case others = "OTHERS"
    case platform = "PLATFORM"
}

// MARK: - Status
struct Status: Codable {
    let timestamp: String?
    let errorCode: Int?
    let errorMessage: String?
    let elapsed, creditCount: Int?
    let notice: String?

    enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case elapsed
        case creditCount = "credit_count"
        case notice
    }
}

import Foundation

extension PublicClient {
    
    internal struct APIResult<T: Decodable>: Decodable {
        let error: [String]
        let result: T
    }
    
    enum Request {
        struct AssetPairs {
            enum Info: String {
                case info
                case leverage
                case fees
                case margin
            }
        }
    }
    
    enum Result {
        
        typealias PairName = String

        struct Time: Decodable {
            let unixtime: Int
            let rfc1123: String
        }
        
        struct Asset: Decodable {
            let aclass: String
            let altname: String
            let decimals: Int
            let displayDecimals: Int
        }
        
        struct AssetPairs: Decodable {
            let altname: String
            let wsname: String
            let aclassBase: String
            let base: String
            let aclassQuote: String
            let quote: String
            let lot: String
            let pairDecimals: String
            let lotDecimals: Int
            let lotMultiplier: Int
            let leverageBuy: [Int]
            let leverageSell: [Int]
            let fees: [[Int]]
            let feesMaker: [[Int]]
            let feeVolumeCurrency: String
            let marginCall: Int
            let marginStop: Int
        }
                
        struct PairTickerInfo: Decodable {
            let ask: [String]
            let bid: [String]
            let lastTradeClosed: [String]
            let volume: [String]
            let volumeWeightedAvgPrice: [String]
            let numberOfTrades: [Int]
            let low: [String]
            let high: [String]
            let opening: String
            
            enum CodingKeys: String, CodingKey {
                case ask = "a"
                case bid = "b"
                case lastTradeClosed = "c"
                case volume = "v"
                case volumeWeightedAvgPrice = "p"
                case numberOfTrades = "t"
                case low = "l"
                case high = "h"
                case opening = "o"
            }
        }
        
        
        struct OrderEntry {
            
        }
        
    }
}

enum ClientError: Error {
    case InvalidURL
    case NotAuthenticated
    
    enum Handler: Error {
        case NoData
        case NoResponse
    }
}

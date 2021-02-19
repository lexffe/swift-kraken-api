import Foundation

public struct PrivateClient {
    let Key: String? // Public endpoints do not need a key.
    let Endpoint: URL
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let session = URLSession(configuration: .default)

    init() {
        self.Key = nil
        self.Endpoint = URL(string: "https://api.kraken.com/0/")!
    }
    
    init(key: String) {
        self.Key = key
        self.Endpoint = URL(string: "https://api.kraken.com/0/")!
    }
    
    init(key: String, endpoint: String) throws {
        self.Key = key
        
        guard let url = URL(string: endpoint) else {
            throw ClientError.InvalidURL
        }
        
        self.Endpoint = url
    }
    
    
    // Private routes
    
    func getAccountBalance() {}
    
    func getTradeBalance() {}
    
    func getOpenOrders() {}
    
    func getClosedOrders() {}
}

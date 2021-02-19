import Foundation
import Promises

// Note: User-Agent is needed for all endpoints.

/**
 Client for interacting with the public REST API endpoints.
 */
public struct PublicClient {
    let Endpoint: URL
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let session = URLSession(configuration: .default)

    init() {
        self.Endpoint = URL(string: "https://api.kraken.com/0/public")!
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    /**
     Create a new client with a custom endpoint.
     
     This is usually not needed as the library tracks the endpoint address.
     
     - Parameters:
        - endpoint: The public endpoint URL.
     */
    init(endpoint: String) throws {
        guard let url = URL(string: endpoint) else {
            throw ClientError.InvalidURL
        }
        
        self.Endpoint = url
    }
    
    // append user agent
    private func getRequest(endpoint: URL) -> URLRequest {
        var req = URLRequest(url: endpoint)
        req.addValue("Swift/5.2", forHTTPHeaderField: "User-Agent")
        return req
    }
    
    /**
     Get the server time.
     
     Note from API Document: "This is to aid in approximating the skew time between the server and client."
     
     - Parameters:
        - handler:
     */
    func getServerTime(handler: @escaping (_ time: Result.Time?, _ error: Error?) -> Void){

        let req = getRequest(endpoint: self.Endpoint.appendingPathComponent("Time"))
        
        session.dataTask(with: req) { data, res, error in
            
            if let error = error {
                handler(nil, error)
                return
            }
            
            guard let data = data else {
                handler(nil, ClientError.Handler.NoData)
                return
            }
            
            do {
                let d = try self.decoder.decode(APIResult<Result.Time>.self, from: data)
                handler(d.result, nil)
            } catch {
                handler(nil, error)
            }
            
            return
            
        }.resume()
        
    }
    
    func getServerTime() -> Promise<Result.Time> {

        let req = getRequest(endpoint: self.Endpoint.appendingPathComponent("Time"))
        
        return Promise { resolve, reject in

            self.session.dataTask(with: req) { data, _, error in

//                let d = try? self.decoder.decode(APIResult<Result.Time>.self, from: data!)
//                resolve(d.result)
                
                if let error = error {
                    reject(error)
                    return
                }
                
                do {
                    let d = try self.decoder.decode(APIResult<Result.Time>.self, from: data!)
                    resolve(d.result)
                } catch {
                    reject(error)
                }

            }.resume()

        }

    }
    
    func getAssetInfo(assets: [String]?, handler: @escaping (_ assets: [String: Result.Asset]?, _ error: Error?) -> Void) {
        
        var comp = URLComponents(url: self.Endpoint.appendingPathComponent("Assets"), resolvingAgainstBaseURL: true)!
        
        if let assets = assets {
            comp.queryItems = [
                URLQueryItem(name: "asset", value: assets.joined(separator: ","))
            ]
        }

        let req = getRequest(endpoint: comp.url!)
        
        session.dataTask(with: req) { data, _, error in
            
            if let error = error {
                handler(nil, error)
                return
            }
            
            guard let data = data else {
                handler(nil, ClientError.Handler.NoData)
                return
            }
            
            do {
                let d = try self.decoder.decode(APIResult<[String:Result.Asset]>.self, from: data)
                handler(d.result, nil)
            } catch {
                handler(nil, error)
            }
            
            return
        }.resume()

    }
    
    func getAssetInfo(assets: [String]?) -> Promise<[String: Result.Asset]> {
        var comp = URLComponents(url: self.Endpoint.appendingPathComponent("Assets"), resolvingAgainstBaseURL: true)!
        
        if let assets = assets {
            comp.queryItems = [
                URLQueryItem(name: "asset", value: assets.joined(separator: ","))
            ]
        }

        let req = getRequest(endpoint: comp.url!)
        
        return Promise { resolve, reject in
            self.session.dataTask(with: req) { data, _, error in
                
                if let error = error {
                    reject(error)
                    return
                }
                
                do {
                    let d = try self.decoder.decode(APIResult<[String:Result.Asset]>.self, from: data!)
                    resolve(d.result)
                } catch {
                    reject(error)
                }

            }.resume()
        }
    }
    
    func getTradableAssetPairs(info: Request.AssetPairs.Info = .info, pairs: [String]?, handler: @escaping (_ pairs: [String: Result.AssetPairs]?, _ error: Error?) -> Void) {
        
        var comp = URLComponents(url: self.Endpoint.appendingPathComponent("AssetPairs"), resolvingAgainstBaseURL: true)!
        
        comp.queryItems = [
            URLQueryItem(name: "info", value: info.rawValue)
        ]
        
        if let pairs = pairs {
            comp.queryItems!.append(URLQueryItem(name: "pair", value: pairs.joined(separator: ",")))
        }
        
        let req = getRequest(endpoint: comp.url!)
        
        session.dataTask(with: req) { data, res, error in
            if let error = error {
                handler(nil, error)
                return
            }
            
            guard let data = data else {
                handler(nil, ClientError.Handler.NoData)
                return
            }
            
            do {
                let d = try self.decoder.decode(APIResult<[String:Result.AssetPairs]>.self, from: data)
                handler(d.result, nil)
            } catch {
                handler(nil, error)
            }
            
        }.resume()
    }
    
    func getTradableAssetPairs(info: Request.AssetPairs.Info = .info, pairs: [String]?) -> Promise<[String: Result.AssetPairs]> {
        
        var comp = URLComponents(url: self.Endpoint.appendingPathComponent("AssetPairs"), resolvingAgainstBaseURL: true)!
        
        comp.queryItems = [
            URLQueryItem(name: "info", value: info.rawValue)
        ]
        
        if let pairs = pairs {
            comp.queryItems!.append(URLQueryItem(name: "pair", value: pairs.joined(separator: ",")))
        }
        
        let req = getRequest(endpoint: comp.url!)
        
        return Promise { resolve, reject in
        
            self.session.dataTask(with: req) { data, _, error in
                if let error = error {
                    reject(error)
                    return
                }
                
                do {
                    let d = try self.decoder.decode(APIResult<[String:Result.AssetPairs]>.self, from: data!)
                    resolve(d.result)
                } catch {
                    reject(error)
                }
                
            }.resume()
            
        }
            
    }
    
    func getTickerInfo(pairs: [String], handler: @escaping (_ pairs: [String: Result.PairTickerInfo]?, _ error: Error?) -> Void) {
        
        var comp = URLComponents(url: self.Endpoint.appendingPathComponent("AssetPairs"), resolvingAgainstBaseURL: true)!
        
        comp.queryItems = [
            URLQueryItem(name: "pair", value: pairs.joined(separator: ","))
        ]
        
        let req = getRequest(endpoint: comp.url!)
        
        session.dataTask(with: req) { data, res, error in
            
            if let error = error {
                handler(nil, error)
                return
            }
            
            guard let data = data else {
                handler(nil, ClientError.Handler.NoData)
                return
            }
            
            do {
                let d = try self.decoder.decode(APIResult<[String:Result.PairTickerInfo]>.self, from: data)
                handler(d.result, nil)
            } catch {
                handler(nil, error)
            }
            
        }.resume()
        
    }
    
    func getOHLCData(pairs: [String], interval: Int?, since: Int?, handler: @escaping (_ pairs: [String:Any]?, _ last: Int, _ error: Error?) -> Void) {
//        let X:[String:[Any]] = []
        
        var comp = URLComponents(url: self.Endpoint.appendingPathComponent("OHLC"), resolvingAgainstBaseURL: true)!
        
        comp.queryItems = [
            URLQueryItem(name: "pair", value: pairs.joined(separator: ","))
        ]
        
        if let interval = interval {
            comp.queryItems!.append(URLQueryItem(name: "interval", value: String(interval)))
        }
        
        if let since = since {
            comp.queryItems!.append(URLQueryItem(name: "since", value: String(since)))
        }
        
        let req = getRequest(endpoint: comp.url!)
        
        session.dataTask(with: req) { data, res, error in
//            if let error = error {
//                handler(nil, error)
//                return
//            }
//
//            guard let data = data else {
//                handler(nil, ClientError.Handler.NoData)
//                return
//            }
            
//            do {
//                let d = try self.decoder.decode(APIResult<OHLC>.self, from: data)
//
//
//                handler(d.result, nil)
//            } catch {
//               handler(nil, error)
//            }
            
        }.resume()
            
    }
    
    func getOrderBook(pair: String, count: Int?, handler: @escaping () -> Void) {
        
    }
    
    func getRecentTrades() {}
    
    func getRecentSpreadData() {}
    
}


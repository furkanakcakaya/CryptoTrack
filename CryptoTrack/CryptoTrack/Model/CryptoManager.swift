//
//  CryptoManager.swift
//  CryptoTrack
//
//  Created by Furkan Akçakaya on 24.09.2022.
//

import Foundation

protocol CryptoManagerDelegate{
    func didUpdateRate(_ rate: String, _ currency: String)
    func didFailWithError(_ error: Error)
}

struct CryptoManager{
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "DE7E4887-1957-4987-B15A-BD6664B19673"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var delegate: CryptoManagerDelegate?

    func getCoinPrice(for currency: String){
            let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let safeData = data{
                        if let bitcoinPrice = self.parseJSON(safeData) {
                            let rateString = String(format: "%.2f", bitcoinPrice)
                            self.delegate?.didUpdateRate(rateString, currency)
                        }
                    }
                }
                task.resume()
            }
        }
    
    func parseJSON(_ data: Data) -> Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch{
            delegate?.didFailWithError(error)
            return nil
        }
    }
}

//
//  Webservices.swift
//  ExchangeRates
//
//  Created by Aim on 19/01/21.
//

import Foundation
let HOST_URL = "http://apilayer.net/api/live?access_key=8221b8b92cf3d6627230d5bb36958a13&currencies=&source=USD&format=1"

class Webservices{
    func getExchangeRates(completion: @escaping (ExchangeRates?, Error?) -> ())
    {
        let url = URL(string: HOST_URL)!
        let task = URLSession.shared.exchangeRatesTask(with: url) { exchangeRates, response, error in
            DispatchQueue.main.async {
                if let exchangeRates = exchangeRates {
                    completion(exchangeRates,error)
                }
                else{
                    if let httpResponse = response as? HTTPURLResponse {
                        print(httpResponse.statusCode)
                        completion(exchangeRates,error)
                    }
                }
            }
        }
        task.resume()
        
    }
    
}

//
//  WebService.swift
//  CryptoSwiftUI
//
//  Created by Ramazan Burak Ekinci on 6.12.2023.
//

import Foundation

enum DownloaderError : Error{
    case badUrl
    case notdata
    case dataParseError
}

class WebService {
    
    //escaping url handle function webservice method1
    func downloadCurrencies(url : URL, completion: @escaping (Result<[CryptoCurrency]?, DownloaderError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, responce, error in
            if let error = error {
                //get error
                print(error.localizedDescription)
                completion(.failure(.badUrl))
            }
            
            guard let data = data, error == nil else {
                return completion(.failure(.notdata))
            }
            
            guard let currencies = try? JSONDecoder().decode([CryptoCurrency].self, from: data) else {
                return completion(.failure(.dataParseError))
            }
            //is okey
            completion(.success(currencies))
        }.resume()
    }
    
    //async operation webservice method2
    func downloadCurrenciesAsync(url: URL) async throws -> [CryptoCurrency] {
        let (data, responce) = try await URLSession.shared.data(from: url)
        print(responce)
        let currencies = try? JSONDecoder().decode([CryptoCurrency].self,from: data)
        
        return currencies ?? []
    }
    
    //async operation with Continuation webservice method3
    func downloadCurrenciesAsyncContinuation(url: URL) async throws -> [CryptoCurrency] {
        try await withCheckedThrowingContinuation { continuation in
            downloadCurrencies(url: url) { result in
                switch result {
                case .success(let cryptos):
                    continuation.resume(returning: cryptos ?? [])
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

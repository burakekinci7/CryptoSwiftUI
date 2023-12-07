//
//  CryptoViewModel.swift
//  CryptoSwiftUI
//
//  Created by Ramazan Burak Ekinci on 6.12.2023.
//

import Foundation

@MainActor
class CryptoListViewModel: ObservableObject {
    //Observable - pusblis. listen to view screen cryptoList
    @Published var cryptoList = [CryptoViewModel]()
    
    let webService = WebService()
    
    //not used DispatchQueue.main.async. Add to @MainActor
    //method3 VM
    func downloadCryprosAsyncContinuationNotQueue (url: URL ) async{
        do{
            let cryptos = try await webService.downloadCurrenciesAsyncContinuation(url: url)
                self.cryptoList = cryptos.map(CryptoViewModel.init)
        }catch{
            print(error)
        }
    }
    
    //method3 VM
    func downloadCryprosAsyncContinuation (url: URL ) async{
        do{
            let cryptos = try await webService.downloadCurrenciesAsyncContinuation(url: url)
            DispatchQueue.main.async {
                self.cryptoList = cryptos.map(CryptoViewModel.init)
            }
        }catch{
            print(error)
        }
    }
    
    
    
    
    //method2 VM
    func downloadCryprosAsync (url: URL ) async{
        do{
            let cryptos = try await webService.downloadCurrenciesAsync(url: url)
            DispatchQueue.main.async {
                self.cryptoList = cryptos.map(CryptoViewModel.init)
            }
        }catch{
            print(error)
        }
    }
    
    
    //method1 VM
    func downloadCrypros (url: URL){
        webService.downloadCurrencies(url: url) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let cryptos):
                if let cryptos = cryptos {
                    DispatchQueue.main.async {
                        self.cryptoList = cryptos.map(CryptoViewModel.init)
                    }
                }
            }
        }
    }
}

struct CryptoViewModel {
    let crypto : CryptoCurrency
    
    var id : UUID? {
        crypto.id
    }
    
    var curreny : String {
        crypto.currency
    }
    
    var price : String {
        crypto.price
    }
}

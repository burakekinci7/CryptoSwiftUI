//
//  CryptoCurrency.swift
//  CryptoSwiftUI
//
//  Created by Ramazan Burak Ekinci on 6.12.2023.
//

import Foundation

struct CryptoCurrency : Identifiable, Decodable, Hashable {
    //Identifiable -> unique id
    //Decodable -> Decode parse json file
    //Hashable -> CodingKey Helper
    
    //Model
    let id = UUID()
    let currency : String
    let price : String
    
    private enum CodingKeys : String, CodingKey{
        case currency = "currency"
        case price = "price"
    }
}

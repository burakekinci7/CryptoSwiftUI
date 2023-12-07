//
//  ContentView.swift
//  CryptoSwiftUI
//
//  Created by Ramazan Burak Ekinci on 6.12.2023.
//

import SwiftUI

struct ContentView: View {
    //Observed - listening to ViewModel
    @ObservedObject  var cryptoListModel :CryptoListViewModel
    
    init() {
        //initialize
        self.cryptoListModel = CryptoListViewModel()
    }
    var body: some View {
        //api url
        let url : String = "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json"
        NavigationStack {
            List(cryptoListModel.cryptoList, id: \.id){crypto in
                VStack{
                    Text(crypto.curreny)
                        .font(.title3)
                        .foregroundStyle(.blue)
                        .frame(maxWidth:.infinity, alignment: .leading)
                        
                    Text(crypto.price)
                        .frame(maxWidth:.infinity, alignment: .leading)
                }
            }
            .toolbar(content: {
                Button {
                    Task.init{
                        await cryptoListModel.downloadCryprosAsyncContinuationNotQueue(url: URL(string: url)!)
                    }
                } label: {
                    Text("Refresh")
                }
            })
            .navigationTitle("Crypto")
        }.task {
            //serice 3
            await cryptoListModel.downloadCryprosAsyncContinuation(url: URL(string: url)! )
            
            //service 2
            //await cryptoListModel.downloadCryprosAsync(url: URL(string: url)!)
        }
        /* Service1
        .onAppear{
            cryptoListModel.downloadCrypros(url: URL(string: url)!)
        }
        */
    }
}

#Preview {
    ContentView()
}

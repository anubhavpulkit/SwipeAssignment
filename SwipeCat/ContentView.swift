//
//  ContentView.swift
//  SwipeCat
//
//  Created by Anubhav Singh on 10/03/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var messages = [Model]()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.category, id: \.self) { item in
                    HStack{
                        Text(item.product_name)
                        AsyncImage(url: URL(string: "\(item.image ?? "")")) { phase in
                            if let image = phase.image {
                                // Display the loaded image
                                image
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .aspectRatio(contentMode: .fit)
                            } else if phase.error != nil {
                                // Display a placeholder when loading failed
                                Image(systemName: "questionmark.diamond")
                                    .imageScale(.large)
                            } else {
                                // Display a placeholder while loading
                                Image(systemName: "photo.circle.fill")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Contacts")
        }
        .task {
            await viewModel.fetchData()
        }
    }
}


#Preview {
    ContentView()
}

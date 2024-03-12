//
//  ContentView.swift
//  SwipeCat
//
//  Created by Anubhav Singh on 10/03/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack{
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.catalog, id: \.self) { item in
                            cellForCatalog(with: item).listRowSeparator(.hidden)
                        }
                    }.searchable(text: $searchText, prompt: "Search product")
                        .onChange(of: searchText) { query in
                            viewModel.searchProduct(query: query)
                        }
                        .listStyle(GroupedListStyle())
                        .navigationTitle("Swipe Catalog")
                        .overlay(alignment: .bottomTrailing, content: {
                            NavigationLink {
                                AddNewCatalog()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .systemImageModify()
                                    .padding(.trailing)
                            }
                        })
                }
            }.onAppear {
                viewModel.fetchData()
            }
        }
    }
}

private func cellForCatalog(with item: CatalogModel) -> some View {
    HStack{
        AsyncImage(url: URL(string: "\(item.image ?? "")")) { phase in
            if let image = phase.image {
                // Display the loaded image
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5)
                    .frame(width: 50, height: 50)
            } else if phase.error != nil {
                // Display a placeholder when loading failed
                Image(systemName: "questionmark.diamond")
                    .imageScale(.large)
            } else {
                // Display a placeholder while loading
                Image(systemName: "photo.circle.fill")
                    .systemImageModify()
            }
        }
        VStack(alignment: .leading){
            Text(item.product_name).foregroundStyle(Color.black)
            Text(item.product_type).foregroundStyle(Color.gray).font(.subheadline)
        }.padding(.horizontal)
        Spacer()
        VStack(alignment: .leading){
            Text("$\(item.price, specifier: "%.1f")")
            Text("Tax: ").font(.subheadline) + Text("$\(item.tax, specifier: "%.1f")").foregroundStyle(Color.orange).font(.subheadline)
        }.foregroundStyle(Color.black)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.white)
            .shadow(color: .gray, radius: 1, x: 0, y: 2))
}

#Preview {
    ContentView()
}

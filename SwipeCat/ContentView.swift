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
                    cellForCatalog(with: item).listRowSeparator(.hidden)
                }
            }
            .listStyle(GroupedListStyle())
                .navigationTitle("Swipe Catalog")
                .overlay(alignment: .bottomTrailing, content: {
                    NavigationLink {
                        AddNewCatalog()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.white, Color.orange)
                            .padding(.trailing)
                    }
                })
        }
        .task {
            await viewModel.fetchData()
        }
    }
}
    
    private func cellForCatalog(with item: Model) -> some View {
        HStack{
            AsyncImage(url: URL(string: "\(item.image ?? "")")) { phase in
                if let image = phase.image {
                    // Display the loaded image
                    image
                        .resizable()
                        .cornerRadius(5)
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                } else if phase.error != nil {
                    // Display a placeholder when loading failed
                    Image(systemName: "questionmark.diamond")
                        .imageScale(.large)
                } else {
                    // Display a placeholder while loading
                    Image(systemName: "photo.circle.fill")
                        .resizable()
                        .foregroundStyle(Color.white, Color.orange)
                        .frame(width: 50, height: 50)
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

//
//  AddNewCatalog.swift
//  SwipeCat
//
//  Created by Anubhav Singh on 11/03/24.
//

import SwiftUI
import PhotosUI

struct AddNewCatalog: View {
    @State var productName : String = "test 123"
    @State var productType : String = "test 123"
    @State var price : String = "112233"
    @State var tax : String = "1122"
    @State private var selectedImageData: Data? = nil
    @StateObject var viewModel = ViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State var disble = true
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                Image(systemName: "plus.rectangle.on.rectangle")
                    .padding()
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
        
        if let selectedImageData,
           let uiImage = UIImage(data: selectedImageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .onAppear {
                    disble = false
                }
        }

        Button(action: {
            viewModel.addNewProduct(productName: productName, productType: productType, price: price, tax: tax, imageData: selectedImageData!)
        }){
            Text("Add Product")
        }
        .disabled(disble)
    }
}

#Preview {
    AddNewCatalog()
}

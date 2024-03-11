//
//  AddNewCatalog.swift
//  SwipeCat
//
//  Created by Anubhav Singh on 11/03/24.
//

import SwiftUI
import PhotosUI

struct AddNewCatalog: View {
    @State var productName : String = ""
    @State var productType : String = ""
    @State var price : String = ""
    @State var tax : String = ""
    @State private var selectedImageData: Data? = nil
    @StateObject var viewModel = ViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State var disble = true
    
    var body: some View {
        VStack{
            
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .frame(width: 250, height: 250)
                    .onAppear {
                        disble = false
                    }
            }
            
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Image(systemName: disble ? "plus.rectangle.on.rectangle" : "gobackward")
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        // Retrieve selected asset in the form of Data
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            
            CustomTextField(text: $productName, placeholder: "Product Name")
            CustomTextField(text: $productType, placeholder: "Product Type")
            
            HStack{
                CustomTextField(text: $price, placeholder: "Price")
                CustomTextField(text: $tax, placeholder: "Tax amount")
            }
                
            Button(action: {
                viewModel.addNewProduct(productName: productName, productType: productType, price: price, tax: tax, imageData: selectedImageData!)
            }){
                Text("Add Product")
                    .foregroundStyle(disble ? Color.gray : Color.orange)
                    .frame(width: AppConstant.screenWidth * 0.9, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .shadow(color: disble ? .gray : .orange, radius: 1, x: 0, y: 2))
            }
            .disabled(disble)
            .padding(.top, 20)
            
        }.padding()
    }
}

#Preview {
    AddNewCatalog()
}

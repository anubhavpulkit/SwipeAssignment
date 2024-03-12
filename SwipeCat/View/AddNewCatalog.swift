//
//  AddNewCatalog.swift
//  SwipeCat
//
//  Created by Anubhav Singh on 11/03/24.
//

import SwiftUI
import PhotosUI

struct AddNewCatalog: View {
    @State private var productName : String = ""
    @State private var productType : String = ""
    @State private var price : String = ""
    @State private var tax : String = ""
    @State private var imageData: Data? = nil
    
    @StateObject private var viewModel = ViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var imageSelected = false
    @Environment(\.presentationMode) var present
    
    var body: some View {
        let dataCollected: Bool = !productName.isEmpty && !productType.isEmpty && !price.isEmpty && !tax.isEmpty && imageSelected
        VStack{
            photoPick()
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            imageData = data
                        }
                    }
                }
            
            CustomTextField(text: $productName, placeholder: "Product Name", numPad: false)
            CustomTextField(text: $productType, placeholder: "Product Type", numPad: false)
            
            HStack{
                CustomTextField(text: $price, placeholder: "Price", numPad: true)
                CustomTextField(text: $tax, placeholder: "Tax amount", numPad: true)
            }
            
            Button(action: {
                viewModel.addNewProduct(productName: productName, productType: productType, price: price, tax: tax, imageData: imageData!)
            }){
                Text("Add Product")
                    .foregroundStyle(dataCollected ? Color.orange : Color.gray)
                    .frame(width: AppConstant.screenWidth * 0.9, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .shadow(color: dataCollected ? .orange : .white, radius: 1, x: 1, y: 2))
            }
            .disabled(!dataCollected)
            .padding(.top, 20)
            .alert(isPresented: $viewModel.showAlert, content: {
                let firstButton = Alert.Button.default(Text("Cancel")) {
                    productName = ""
                    productType = ""
                    tax = ""
                    price = ""
                    imageData = nil
                    selectedItem = nil
                }
                let secondButton = Alert.Button.destructive(Text("Home")) {
                    present.wrappedValue.dismiss()
                }
                return Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), primaryButton: firstButton, secondaryButton: secondButton)
            })
            .toolbar{
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("Done"){
                        UIApplication.shared.dismissKeyboard()
                    }
                }
            }
        }.padding()
    }
    
    private func photoPick() -> some View {
        VStack{
            if let imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .frame(width: 250, height: 250)
                    .onAppear {
                        imageSelected = true
                    }
            }
            
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    if !imageSelected {
                        Image(systemName: "plus.viewfinder")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.orange, Color.gray)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .shadow(color: .orange, radius: 2, x: 1, y: 1))
                    } else {
                        Image(systemName: "gobackward")
                            .foregroundColor(.orange)
                    }
                }
        }
    }
}

#Preview {
    AddNewCatalog()
}

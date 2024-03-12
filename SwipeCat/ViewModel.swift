//
//  ViewModel.swift
//  SwipeCat
//
//  Created by Anubhav Singh on 10/03/24.
//

import Foundation
import SwiftUI


import Foundation

class ViewModel: ObservableObject {
    @Published var category: [CatalogModel] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var catalog: [CatalogModel] = []
    
    private let operationQueue = OperationQueue()
    
    func fetchData() {
        isLoading = true
        Task {
            do {
                let fetchedData = try await fetchDataFromAPI()
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.category = fetchedData
                    self.updateCatalog()
                }
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }
    
    private func fetchDataFromAPI() async throws -> [CatalogModel] {
        let endpoint = "https://app.getswipe.in/api/public/get"
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode([CatalogModel].self, from: data)
    }
    
    func searchProduct(query: String) {
        updateCatalog(with: query)
    }
    
    private func updateCatalog(with query: String? = nil) {
        if let query = query, !query.isEmpty {
            catalog = category.filter { $0.product_name.localizedCaseInsensitiveContains(query) }
        } else {
            catalog = category
        }
    }
    
    func addNewProduct(productName: String, productType: String, price: String, tax: String, imageData: Data) {
        let endpointAddNew = "https://app.getswipe.in/api/public/add"
        isLoading = true
        let parameters = [
            "product_name" : productName,
            "product_type" : productType,
            "price" : price,
            "tax" : tax
        ] as [String : Any]
        uploadImageToServer(imageData: imageData, parameters: parameters, serverURL: URL(string: endpointAddNew)!)
    }
    
    func uploadImageToServer(imageData: Data, parameters: [String: Any], serverURL: URL) {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        
        // Append JSON parameters to the body
        for (key, value) in parameters {
            body.append(contentsOf: "--\(boundary)\r\n".utf8)
            body.append(contentsOf: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8)
            body.append(contentsOf: "\(value)\r\n".utf8)
        }
        
        // Append image data to the body
        body.append(contentsOf: "--\(boundary)\r\n".utf8)
        body.append(contentsOf: "Content-Disposition: form-data; name=\"files[]\"; filename=\"image.jpg\"\r\n".utf8)
        body.append(contentsOf: "Content-Type: image/jpeg\r\n\r\n".utf8)
        body.append(imageData)
        body.append(contentsOf: "\r\n".utf8)
        
        // Close the body with the boundary
        body.append(contentsOf: "--\(boundary)--\r\n".utf8)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    print("Error: \(error)")
                    self.showAlert = true
                    self.alertTitle = "Failed"
                    self.alertMessage = "Error: \(error.localizedDescription)"
                    self.isLoading = false
                }
                return
            }
            
            if let data = data {
                DispatchQueue.main.async { [self] in
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response: \(responseString ?? "")")
                    self.showAlert = true
                    self.alertTitle = "Congratulations 🙌🏼"
                    self.alertMessage = "Your new product is added successfully!"
                    self.isLoading = false
                }
            }
        }
        task.resume()
    }
}

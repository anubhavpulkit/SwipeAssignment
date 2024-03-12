//
//  Utils.swift
//  SwipeCat
//
//  Created by Anubhav Singh on 11/03/24.
//

import Foundation
import SwiftUI

extension Image {
    func systemImageModify() -> some View {
        self
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundStyle(Color.white, Color.orange)
    }
}

class AppConstant {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeigh = UIScreen.main.bounds.height
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    @FocusState var focused: Bool
    
    var body: some View {
        let isActive = focused || text.count > 0
        ZStack(alignment: isActive ? .topLeading : .center) {
            TextField("", text: $text)
                .frame(height: 24)
                .font(.system(size: 14, weight: .regular))
                .opacity(isActive ? 1 : 0)
                .offset(y: 7)
                .focused($focused)
                .foregroundColor(Color.orange)
            
            HStack {
                Text(placeholder)
                    .foregroundColor(.black.opacity(0.3))
                    .frame(height: 16)
                    .font(.system(size: isActive ? 10 : 14, weight: .regular))
                    .offset(y: isActive ? -7 : 0)
                Spacer()
            }
        }
        .onTapGesture {
            focused = true
        }
        .animation(.linear(duration: 0.2), value: focused)
        .frame(height: 44)
        .padding(.horizontal, 16)
        .background(.white)
        .cornerRadius(12)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .shadow(color: isActive ? .orange : .gray, radius: 1, x: 0, y: 2))
    }
}

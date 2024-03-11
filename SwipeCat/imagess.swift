//
//  imagess.swift
//  SwipeCat
//
//  Created by Anubhav Singh on 10/03/24.
//

import Foundation
import UIKit

func generateTestImage() -> UIImage? {
    let size = CGSize(width: 100, height: 100) // Adjust the size as needed
    let renderer = UIGraphicsImageRenderer(size: size)
    let image = renderer.image { (context) in
        UIColor.blue.setFill()
        context.fill(CGRect(origin: .zero, size: size))
    }
    return image
}

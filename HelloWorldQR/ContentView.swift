//
//  ContentView.swift
//  HelloWorldQR
//
//  Created by Cheong Yu on 3/14/25.
//  Copyright © 2025 CYANware Software Solutions. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    func generateQRCode(from text: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(text.utf8)
        
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        Image(uiImage: generateQRCode(from: "Hello, world!"))
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
    }
}

#Preview {
    ContentView()
}

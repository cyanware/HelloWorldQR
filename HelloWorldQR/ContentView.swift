//
//  ContentView.swift
//  HelloWorldQR
//
//  Created by Cheong Yu on 3/14/25.
//  Copyright © 2025 CYANware Software Solutions. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

/// A view that displays a QR code generated from a text string
struct ContentView: View {
    /// Generates a QR code image from the provided text
    /// - Parameter text: The string to encode in the QR code
    /// - Returns: A UIImage containing the generated QR code, or a fallback error image if generation fails
    func generateQRCode(from text: String) -> UIImage {
        // Create a Core Image context for image processing
        let context = CIContext()
        // Initialize the QR code generator filter
        let filter = CIFilter.qrCodeGenerator()
        
        // Convert the input text to Data and set it as the filter's message
        filter.message = Data(text.utf8)
        
        // Try to generate the QR code image
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        // Return an error icon if QR code generation fails
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        // Display the generated QR code
        Image(uiImage: generateQRCode(from: "Hello, world!"))
            // Disable image interpolation for sharper QR code
            .interpolation(.none)
            // Make the image resizable
            .resizable()
            // Maintain aspect ratio
            .scaledToFit()
            // Set fixed dimensions for the QR code
            .frame(width: 200, height: 200)
    }
}

/// Preview provider for ContentView
#Preview {
    ContentView()
}

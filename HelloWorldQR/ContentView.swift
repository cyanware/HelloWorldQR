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
    @State private var text = ""
    @State private var foregroundColor = Color.black
    @State private var backgroundColor = Color.white
    @State private var correctionLevel = "M"
    
    // QR code correction levels
    let correctionLevels = ["L", "M", "Q", "H"]
    
    func generateQRCode(from text: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        // Configure QR code parameters
        filter.message = Data(text.utf8)
        filter.correctionLevel = correctionLevel
        
        guard let outputImage = filter.outputImage else {
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }
        
        // Scale the QR code for better resolution
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        
        // Apply custom colors
        let colorFilter = CIFilter.falseColor()
        colorFilter.inputImage = scaledImage
        colorFilter.color0 = CIColor(color: UIColor(backgroundColor))
        colorFilter.color1 = CIColor(color: UIColor(foregroundColor))
        
        guard let coloredImage = colorFilter.outputImage,
              let cgImage = context.createCGImage(coloredImage, from: coloredImage.extent) else {
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(uiImage: generateQRCode(from: text))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            TextField("Enter text", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            // Color pickers
            ColorPicker("Foreground Color", selection: $foregroundColor)
                .padding(.horizontal)
            
            ColorPicker("Background Color", selection: $backgroundColor)
                .padding(.horizontal)
            
            // Correction level picker
            Picker("Correction Level", selection: $correctionLevel) {
                ForEach(correctionLevels, id: \.self) { level in
                    Text(level).tag(level)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            ShareLink(item: Image(uiImage: generateQRCode(from: text)), 
                     preview: SharePreview("QR Code", image: Image(uiImage: generateQRCode(from: text))))
                .buttonStyle(.bordered)
        }
        .padding()
    }
}

/// Preview provider for ContentView
#Preview {
    ContentView()
}

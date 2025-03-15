//
//  ContentView.swift
//  HelloWorldQR
//
//  Created by Cheong Yu on 3/14/25.
//  Copyright © 2025 CYANware Software Solutions. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

/// A view that generates and displays a customizable QR code with a centered logo
struct ContentView: View {
    // MARK: - Properties
    
    /// Text to be encoded in the QR code
    @State private var text = ""
    /// Color for QR code foreground elements
    @State private var foregroundColor = Color.black
    /// Color for QR code background
    @State private var backgroundColor = Color.white
    /// QR code error correction level (L: 7%, M: 15%, Q: 25%, H: 30%)
    @State private var correctionLevel = "H"

    /// Available QR code error correction levels
    let correctionLevels = ["L", "M", "Q", "H"]

    // MARK: - Methods

    /// Generates a QR code image with custom colors and a centered logo
    /// - Parameter text: The string to encode in the QR code
    /// - Returns: A UIImage containing the generated QR code with logo overlay
    func generateQRCode(from text: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        // Configure QR code generation
        filter.message = Data(text.utf8)
        filter.correctionLevel = correctionLevel

        // Handle potential QR code generation failure
        guard let outputImage = filter.outputImage else {
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }

        // Scale up the QR code for better quality
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))

        // Apply custom colors to the QR code
        let colorFilter = CIFilter.falseColor()
        colorFilter.inputImage = scaledImage
        colorFilter.color0 = CIColor(color: UIColor(backgroundColor))
        colorFilter.color1 = CIColor(color: UIColor(foregroundColor))

        guard let coloredImage = colorFilter.outputImage,
              let cgImage = context.createCGImage(coloredImage, from: coloredImage.extent) else {
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }

        let qrCodeImage = UIImage(cgImage: cgImage)

        // Create system logo with proper styling
        let logo = UIImage(systemName: "apple.logo")?.withTintColor(.black, renderingMode: .alwaysTemplate)
        ?? UIImage()
        
        // Calculate logo size (25% of QR code size)
        let logoSize = qrCodeImage.size.width / 4

        // Start drawing context for combining QR code and logo
        UIGraphicsBeginImageContextWithOptions(qrCodeImage.size, false, 0)
        qrCodeImage.draw(in: CGRect(origin: .zero, size: qrCodeImage.size))

        // Calculate center position for logo
        let logoOrigin = CGPoint(
            x: (qrCodeImage.size.width - logoSize) / 2,
            y: (qrCodeImage.size.height - logoSize) / 2
        )

        // Draw white circular background for logo
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: logoOrigin.x + logoSize/2, y: logoOrigin.y + logoSize/2),
            radius: logoSize/2 * 1.25, // Circle is 25% larger than logo
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )
        UIColor.white.setFill()
        circlePath.fill()

        // Draw the logo on top of white background
        logo.draw(in: CGRect(origin: logoOrigin, size: CGSize(width: logoSize, height: logoSize)))

        // Get final image and clean up
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return result ?? qrCodeImage
    }

    // MARK: - View Body

    var body: some View {
        VStack(spacing: 20) {
            // QR code display
            Image(uiImage: generateQRCode(from: text))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)

            // User input controls
            TextField("Enter text", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            ColorPicker("Foreground Color", selection: $foregroundColor)
                .padding(.horizontal)

            ColorPicker("Background Color", selection: $backgroundColor)
                .padding(.horizontal)

            // Error correction level selector
            Picker("Correction Level", selection: $correctionLevel) {
                ForEach(correctionLevels, id: \.self) { level in
                    Text(level).tag(level)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            // Share button
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

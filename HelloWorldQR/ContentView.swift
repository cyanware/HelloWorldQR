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
    @State private var correctionLevel = "H"

    let correctionLevels = ["L", "M", "Q", "H"]

    func generateQRCode(from text: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        filter.message = Data(text.utf8)
        filter.correctionLevel = correctionLevel

        guard let outputImage = filter.outputImage else {
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }

        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))

        let colorFilter = CIFilter.falseColor()
        colorFilter.inputImage = scaledImage
        colorFilter.color0 = CIColor(color: UIColor(backgroundColor))
        colorFilter.color1 = CIColor(color: UIColor(foregroundColor))

        guard let coloredImage = colorFilter.outputImage,
              let cgImage = context.createCGImage(coloredImage, from: coloredImage.extent) else {
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }

        let qrCodeImage = UIImage(cgImage: cgImage)

        // Use system image as logo
        let logo = UIImage(systemName: "apple.logo")?.withTintColor(.black, renderingMode: .alwaysTemplate)
        ?? UIImage()
        
        let logoSize = qrCodeImage.size.width / 4

        UIGraphicsBeginImageContextWithOptions(qrCodeImage.size, false, 0)
        qrCodeImage.draw(in: CGRect(origin: .zero, size: qrCodeImage.size))

        let logoOrigin = CGPoint(
            x: (qrCodeImage.size.width - logoSize) / 2,
            y: (qrCodeImage.size.height - logoSize) / 2
        )

        // Draw white background circle
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: logoOrigin.x + logoSize/2, y: logoOrigin.y + logoSize/2),
            radius: logoSize/2 * 1.25,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )
        UIColor.white.setFill()
        circlePath.fill()

        // Draw logo
        logo.draw(in: CGRect(origin: logoOrigin, size: CGSize(width: logoSize, height: logoSize)))

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return result ?? qrCodeImage
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

            ColorPicker("Foreground Color", selection: $foregroundColor)
                .padding(.horizontal)

            ColorPicker("Background Color", selection: $backgroundColor)
                .padding(.horizontal)

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

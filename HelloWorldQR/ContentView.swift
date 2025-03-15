//
//  ContentView.swift
//  HelloWorldQR
//
//  Created by Cheong Yu on 3/14/25.
//  Copyright © 2025 CYANware Software Solutions. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Display a QR code with the text "Hello, World!"
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

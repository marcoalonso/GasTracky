//
//  GasTrackyApp.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI

@main
struct GasTrackyApp: App {
    @StateObject private var viewModel = GastoViewModel()
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(viewModel)
        }
    }
}

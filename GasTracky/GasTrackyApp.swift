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
    @StateObject private var authManager = BiometricAuthManager()
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("useFaceID") private var useFaceID: Bool = true

    var body: some Scene {
        WindowGroup {
            
            if !useFaceID {
                MainTabView()
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .environmentObject(viewModel)
            } else if authManager.isAuthenticated {
                MainTabView()
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .environmentObject(viewModel)
            } else {
                BiometricsView()
                    .environmentObject(viewModel)
                    .onAppear {
                        authManager.authenticateUser { success in
                            if success {
                                authManager.isAuthenticated = true
                            }
                        }
                    }
            }
        }
    }
}

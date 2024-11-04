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
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(viewModel)
        }
    }
}

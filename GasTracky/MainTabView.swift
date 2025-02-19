//
//  MainTabView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = GastoViewModel()

    var body: some View {
        TabView {
            GastosView()
                .tabItem {
                    Label("Gastos", systemImage: "dollarsign.circle")
                }

            EstadisticasView()
                .tabItem {
                    Label("Estadísticas", systemImage: "chart.bar")
                }

           
            ConfiguracionView()
                .tabItem {
                    Label("Configuración", systemImage: "gearshape")
                }
            
        }
        .environmentObject(viewModel) // Pasar el ViewModel a las vistas hijas
    }
}

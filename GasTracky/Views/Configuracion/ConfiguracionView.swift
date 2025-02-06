//
//  ConfiguracionView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import Foundation
import SwiftUI

struct ConfiguracionView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferencias")) {
                    Toggle("Modo oscuro", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { _, _ in
                            updateAppearance()
                        }
                    Text("Exportar datos")
                }
                Section(header: Text("Cuenta")) {
                    Text("Configuración de cuenta")
                }
                Section(header: Text("Seguridad")) {
                    Text("Habilitar autenticación biométrica")
                }
            }
            .navigationTitle("Configuración")
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    private func updateAppearance() {
        // Forcing the appearance update if needed.
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
}



#Preview {
    ConfiguracionView()
}
    

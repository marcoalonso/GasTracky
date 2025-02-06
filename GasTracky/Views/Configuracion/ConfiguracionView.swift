//
//  ConfiguracionView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI
import LocalAuthentication

struct ConfiguracionView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("useFaceID") private var useFaceID: Bool = false
    @StateObject private var authManager = BiometricAuthManager()
    
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
                    Toggle("Solicitar FaceID al iniciar", isOn: $useFaceID)
                        .onChange(of: useFaceID) { newValue, _ in
                            if newValue {
                                authManager.authenticateUser { success in
                                    if !success {
                                        // Si la autenticación falla, desactiva el toggle
                                        useFaceID = false
                                    }
                                }
                            }
                        }
                }
            }
            .navigationTitle("Configuración")
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    private func updateAppearance() {
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
}


#Preview {
    ConfiguracionView()
}
    

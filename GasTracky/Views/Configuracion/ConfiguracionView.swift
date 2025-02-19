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
    @State private var deleteAllData: Bool = false
    
    var formattedLastAccess: String {
        let defaults = UserDefaults.standard
        if let storedDate = defaults.object(forKey: "lastAccess") as? Date {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: storedDate)
        }
        return "Sin registro"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Total Gastado")) {
                        Text("$ 12345.67 pesos.")
                            .font(.title3)
                        
                    }
                    
                    Section(header: Text("Preferencias")) {
                        Toggle("Modo oscuro", isOn: $isDarkMode)
                            .onChange(of: isDarkMode) { _, _ in
                                updateAppearance()
                            }
                        
                        
                    }
                    
                    Section(header: Text("Proximamente")) {
                        Text("Exportar datos")
                        Text("Recordatorios")
                        Text("Gastos recurrentes")
                        Text("Compartir con otros usuarios")
                        Text("Califica la app")
                        Text("Contacto con equipo de soporte")
                        Toggle("Eliminar todos los datos", isOn: $deleteAllData)
                        Toggle("Solicitar FaceID al iniciar", isOn: $useFaceID)
                            .onChange(of: useFaceID) { newValue, _ in
                                if newValue {
                                    authManager.authenticateUser { success in
                                        if !success {
                                            // Si la autenticación falla, desactiva el toggle
                                            //  useFaceID = false
                                        }
                                    }
                                }
                            }
                        
                    }
                    
                    Section(header: Text("Version")) {
                        Text(" 1.0.0")
                        
                    }
                    
                }
                Text("Último acceso: \(formattedLastAccess)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }// Vstack
            
            .navigationTitle("Configuración").navigationBarTitleDisplayMode(.inline)
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
    

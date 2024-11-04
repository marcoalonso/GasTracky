//
//  ConfiguracionView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import Foundation
import SwiftUI

struct ConfiguracionView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferencias")) {
                    Text("Modo oscuro")
                    Text("Exportar datos")
                }
                Section(header: Text("Cuenta")) {
                    Text("Configuración de cuenta")
                }
            }
            .navigationTitle("Configuración")
        }
    }
}

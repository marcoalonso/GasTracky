//
//  ProfileView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                Form {
                    Section(header: Text("Foto de Perfil")) {
                        Text("Opción 1")
                        Text("Opción 2")
                        
                    }
                    Section(header: Text("Cuenta")) {
                        Text("Configuración de cuenta")
                    }
                }
            }
            
            .navigationTitle("Perfil")
        }
    }
}

#Preview {
    ProfileView()
}

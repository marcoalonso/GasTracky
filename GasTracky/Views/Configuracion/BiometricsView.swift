//
//  BiometricsView.swift
//  GasTracky
//
//  Created by Marco Alonso Rodriguez on 06/02/25.
//
import SwiftUI

struct BiometricsView: View {
    @StateObject private var authManager = BiometricAuthManager()
    @EnvironmentObject var viewModel: GastoViewModel // Pasamos el ViewModel global
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        if authManager.isAuthenticated {
            MainTabView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(viewModel)
        } else {
            VStack(spacing: 20) {
                Image(systemName: "lock.shield")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)

                Text("No tienes permiso para ver esta app")
                    .font(.title)
                    .padding(.horizontal)

                Text("Por favor autentícate para continuar.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                Button(action: {
                    authManager.authenticateUser { success in
                        if success {
                            authManager.isAuthenticated = true
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "faceid")
                            .font(.title2)
                        Text("Solicitar FaceID")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
                .padding(.horizontal, 40)

                if let errorMessage = authManager.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
            .padding()
        }
    }
}

#Preview {
    BiometricsView()
}

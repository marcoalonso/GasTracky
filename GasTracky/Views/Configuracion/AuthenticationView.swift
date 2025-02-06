//
//  AuthenticationView.swift
//  GasTracky
//
//  Created by Marco Alonso Rodriguez on 06/02/25.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject private var authManager = BiometricAuthManager()
    @State private var errorMessage: String?

    var onAuthenticated: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.shield")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.red)

            Text("Autenticación requerida")
                .font(.title)
                .padding(.horizontal)

            Text("Por favor autentícate para continuar.")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.horizontal)

            Button(action: {
                authManager.authenticateUser { success in
                    if success {
                        onAuthenticated()
                    } else {
                        errorMessage = "Autenticación fallida. Inténtalo de nuevo."
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

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
        }
        .padding()
    }
}

#Preview {
    AuthenticationView {
        print("Autenticación exitosa en el preview")
    }
}

//
//  BiometricAuthManager.swift
//  GasTracky
//
//  Created by Marco Alonso Rodriguez on 06/02/25.
//

import LocalAuthentication

final class BiometricAuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?

    func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Necesitamos autenticarte para acceder a la aplicación."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                        completion(true)
                    } else {
                        self.isAuthenticated = false
                        self.errorMessage = authenticationError?.localizedDescription ?? "Autenticación fallida."
                        completion(false)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.errorMessage = "La autenticación biométrica no está disponible en este dispositivo."
                completion(false)
            }
        }
    }
}


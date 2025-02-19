//
//  AgregarCategoriaView.swift
//  GasTracky
//
//  Created by Marco Alonso Rodriguez on 06/02/25.
//

import SwiftUI

struct AgregarCategoriaView: View {
    @ObservedObject var viewModel: GastoViewModel
    @Binding var showModal: Bool
    @State private var nombreCategoria = ""

    var body: some View {
        VStack(spacing: 8) {
            Text("Nueva Categoría")
                .font(.headline)
                .bold()

            TextField("Nombre", text: $nombreCategoria)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: agregarCategoria) {
                Text("Guardar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 8)
            }
            .disabled(nombreCategoria.isEmpty)
            .padding(.horizontal)
        }
        .padding()
    }

    private func agregarCategoria() {
        viewModel.addCategoria(nombre: nombreCategoria)
        showModal = false
    }
}

#Preview {
    AgregarCategoriaView(viewModel: GastoViewModel(), showModal: .constant(true))
        .presentationDetents([.fraction(0.25), .medium])
}

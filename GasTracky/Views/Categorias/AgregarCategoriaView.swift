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
        VStack(spacing: 20) {
            Text("Nueva Categoría")
                .font(.title)
                .bold()

            TextField("Nombre de la categoría", text: $nombreCategoria)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: agregarCategoria) {
                Text("Guardar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
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
}

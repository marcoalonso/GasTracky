//
//  EditarCategoriaView.swift
//  GasTracky
//
//  Created by Marco Alonso Rodriguez on 06/02/25.
//

import SwiftUI

struct EditarCategoriaView: View {
    var categoria: Categoria
    @ObservedObject var viewModel: GastoViewModel
    @Binding var showModal: Bool
    @State private var nuevoNombre = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Editar Categoría")
                .font(.title)
                .bold()

            TextField("Nombre de la categoría", text: $nuevoNombre)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onAppear {
                    nuevoNombre = categoria.nombre
                }

            HStack(spacing: 20) {
                Button(action: eliminarCategoria) {
                    Label("Eliminar", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: renombrarCategoria) {
                    Label("Renombrar", systemImage: "checkmark")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }

    private func renombrarCategoria() {
        viewModel.updateCategoria(categoria: categoria, nuevoNombre: nuevoNombre)
        showModal = false
    }

    private func eliminarCategoria() {
        viewModel.deleteCategoria(categoria: categoria)
        showModal = false
    }
}

#Preview {
    let viewModel = GastoViewModel()
    let sampleCategoria = Categoria(id: UUID(), nombre: "Alimentación")
    viewModel.addCategoria(nombre: "Transporte")
    
    return EditarCategoriaView(categoria: sampleCategoria, viewModel: viewModel, showModal: .constant(true))
}

//
//  EditarCategoriaView.swift
//  GasTracky
//
//  Created by Marco Alonso Rodriguez on 06/02/25.
//

import SwiftUI

struct EditarCategoriaView: View {
    @Binding var categoria: Categoria
    @ObservedObject var viewModel: GastoViewModel
    @Binding var showModal: Bool
    @State private var nuevoNombre = ""
    
    var body: some View {
        VStack(spacing: 16) {
            // Título centrado
            HStack {
                Spacer()
                Text("Editar Categoría")
                    .font(.headline)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
        
            
            // Campo de texto para editar el nombre de la categoría
            TextField("Nombre de la categoría", text: $nuevoNombre)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onAppear {
                    nuevoNombre = categoria.nombre
                }
            
            // Botones de acción
            HStack(spacing: 16) {
                Button(action: eliminarCategoria) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Eliminar")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: renombrarCategoria) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Renombrar")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
    
    private func renombrarCategoria() {
        categoria.nombre = nuevoNombre
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
    
    return EditarCategoriaView(categoria: .constant(sampleCategoria), viewModel: viewModel, showModal: .constant(true))
        .presentationDetents([.fraction(0.25), .medium])
}

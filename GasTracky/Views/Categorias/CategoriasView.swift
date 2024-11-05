//
//  CategoriasView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI

struct CategoriasView: View {
    @EnvironmentObject var viewModel: GastoViewModel
    @State private var nuevaCategoria = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.categorias, id: \.id) { categoria in
                        Text(categoria.nombre)
                    }
                    .onDelete(perform: deleteCategoria)
                }.formStyle(.grouped)
                
                HStack {
                    TextField("Nueva categoría", text: $nuevaCategoria)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Agregar") {
                        agregarCategoria()
                    }
                    .disabled(nuevaCategoria.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Categorías")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .toolbar {
                EditButton()
            }
        }
    }
    
    private func agregarCategoria() {
        viewModel.addCategoria(nombre: nuevaCategoria)
        nuevaCategoria = ""
    }
    
    private func deleteCategoria(at offsets: IndexSet) {
        offsets.forEach { index in
            let categoria = viewModel.categorias[index]
            viewModel.deleteCategoria(categoria: categoria)
        }
    }
}




#Preview {
    CategoriasView()
}

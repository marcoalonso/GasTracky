//
//  CategoriasView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI

struct CategoriasView: View {
    @ObservedObject var viewModel: GastoViewModel
    @State private var nuevaCategoria = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.categorias, id: \.id) { categoria in
                        Text(categoria.nombre)
                    }
                    .onDelete(perform: deleteCategoria)
                }
                
                HStack {
                    TextField("Nueva categoría", text: $nuevaCategoria)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Agregar") {
                        agregarCategoria()
                    }
                    .disabled(nuevaCategoria.isEmpty) // Deshabilita el botón si el campo está vacío
                }
                .padding()
            }
            .navigationTitle("Categorías")
            .toolbar {
                EditButton() // Permite editar la lista para eliminar categorías
            }
        }
    }
    
    private func agregarCategoria() {
        viewModel.addCategoria(nombre: nuevaCategoria)
        nuevaCategoria = "" // Limpia el campo de texto después de agregar la categoría
    }
    
    private func deleteCategoria(at offsets: IndexSet) {
        offsets.forEach { index in
            let categoria = viewModel.categorias[index]
            viewModel.deleteCategoria(categoria: categoria)
        }
    }
}


#Preview {
    CategoriasView(viewModel: GastoViewModel(dataSource: SwiftDataService.shared))
}

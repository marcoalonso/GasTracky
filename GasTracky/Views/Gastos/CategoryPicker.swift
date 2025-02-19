//
//  CategoryPicker.swift
//  GasTracky
//
//  Created by Marco Alonso Rodriguez on 18/02/25.
//

import SwiftUI

struct CategoryPicker: View {
    @ObservedObject var viewModel: GastoViewModel
    @Binding var categoriaSeleccionada: String
    @Binding var mostrarCategorias: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Categoría").font(.headline)
            HStack {
                Button(action: { mostrarCategorias = true }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem(.fixed(50))], spacing: 20) {
                        ForEach(viewModel.categorias, id: \.id) { categoria in
                            HStack(spacing: 2) {
                                Image(systemName: "tag")
                                    .font(.title3)
                                    .foregroundColor(categoriaSeleccionada == categoria.nombre ? .blue : .gray)
                                Text(categoria.nombre)
                                    .font(.caption)
                            }
                            .padding(.horizontal, 6)
                            .frame(height: 40)
                            .background(categoriaSeleccionada == categoria.nombre ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .onTapGesture {
                                categoriaSeleccionada = categoria.nombre
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CategoryPicker_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPicker(viewModel: GastoViewModel(), categoriaSeleccionada: .constant("Alimentación"), mostrarCategorias: .constant(false))
    }
}

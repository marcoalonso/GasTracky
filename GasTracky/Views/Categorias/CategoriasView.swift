//
//  CategoriasView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI

struct CategoriasView: View {
    @EnvironmentObject var viewModel: GastoViewModel
    @State private var mostrarNuevaCategoria = false

    // Define columnas responsivas
    private let columnas = [
        GridItem(.adaptive(minimum: 100))
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columnas, spacing: 20) {
                    ForEach(viewModel.categorias, id: \.id) { categoria in
                        VStack {
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "star.fill") // Cambia a la imagen de la categoría cuando esté disponible
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.blue)
                                )
                            Text(categoria.nombre)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Categorías")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        mostrarNuevaCategoria = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $mostrarNuevaCategoria) {
                NuevaCategoriaView(viewModel: viewModel)
            }
        }
        
    }
}




#Preview {
    CategoriasView()
}

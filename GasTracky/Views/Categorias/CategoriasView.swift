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
    @State private var showAddModal = false
    @State private var showEditModal = false
    @State private var selectedCategoria: Categoria?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                    ForEach(viewModel.categorias, id: \.id) { categoria in
                        Button(action: {
                            selectedCategoria = categoria
                            showEditModal = true
                        }) {
                            Text(categoria.nombre)
                                .frame(maxWidth: .infinity, minHeight: 80)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(4)
                        }
                    }

                    Button(action: {
                        showAddModal = true
                    }) {
                        VStack {
                            Image(systemName: "plus.circle")
                                .font(.largeTitle)
                            Text("Agregar categoría")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                        .padding(4)
                    }
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
        }
        .sheet(isPresented: $showAddModal) {
            AgregarCategoriaView(viewModel: viewModel, showModal: $showAddModal)
        }
        .sheet(isPresented: $showEditModal) {
            EditarCategoriaView(categoria: Binding(get: { selectedCategoria ?? Categoria(id: UUID(), nombre: "") }, set: { selectedCategoria = $0 }), viewModel: viewModel, showModal: $showEditModal)
        }
    }
}




#Preview {
    CategoriasView()
        .environmentObject(GastoViewModel())
}

//
//  NuevaCategoriaView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI

struct NuevaCategoriaView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GastoViewModel
    @State private var nombreCategoria = ""
    @State private var iconoSeleccionado: String?
    
    // Lista de iconos para seleccionar
    private let iconos = [
        "star.fill", "cart.fill", "house.fill", "car.fill", "heart.fill",
        "gift.circle", "figure.walk", "fork.knife", "building"
    ]

    var body: some View {
        VStack(spacing: 20) {
            // Campo de texto para el nombre de la categoría
            TextField("Nombre de la categoría", text: $nombreCategoria)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Colección horizontal de iconos
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(iconos, id: \.self) { icono in
                        Image(systemName: icono)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding()
                            .background(iconoSeleccionado == icono ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .onTapGesture {
                                iconoSeleccionado = icono
                            }
                    }
                }
                .padding(.horizontal)
            }
            
            // Botón de agregar
            Button(action: agregarCategoria) {
                Text("Agregar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(nombreCategoria.isEmpty || iconoSeleccionado == nil)
            .padding(.top, 20)
        }
        .navigationTitle("Nueva Categoría")
    }
    
    private func agregarCategoria() {
        let nuevaCategoria = Categoria(nombre: nombreCategoria)
        viewModel.addCategoria(nombre: nuevaCategoria.nombre)
        dismiss()
    }
}


#Preview {
    NuevaCategoriaView( viewModel: GastoViewModel())
}

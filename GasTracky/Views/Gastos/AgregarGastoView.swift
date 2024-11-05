//
//  AgregarGastoView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI

struct AgregarGastoView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GastoViewModel
    
    @State private var cantidad: String = ""
    @State private var fecha = Date()
    @State private var categoriaSeleccionada: String = ""
    @State private var descripcion: String = "" // Nueva propiedad para la descripción
    @State private var mostrarCategorias = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("¿Cuánto gastaste?")) {
                    TextField("$100", text: $cantidad)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("¿Cuándo?")) {
                    DatePicker("Fecha", selection: $fecha, displayedComponents: .date)
                }
                
                Section(header: Text("Categoría")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.fixed(50))], spacing: 20) {
                            ForEach(viewModel.categorias, id: \.id) { categoria in
                                VStack {
                                    Image(systemName: "tag")
                                        .font(.largeTitle)
                                        .foregroundColor(categoriaSeleccionada == categoria.nombre ? .blue : .gray)
                                    Text(categoria.nombre)
                                        .font(.caption)
                                }
                                .frame(width: 80, height: 80)
                                .background(categoriaSeleccionada == categoria.nombre ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .onTapGesture {
                                    categoriaSeleccionada = categoria.nombre
                                }
                            }
                        }
                        .frame(height: 100)
                    }
                    .frame(height: 100)
                    
                    // Botón para mostrar la vista de categorías en un sheet
                    Button(action: {
                        mostrarCategorias = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Administrar Categorías")
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                
                
                Section(header: Text("Descripción")) { // Nueva sección para la descripción
                    TextField("Descripción del gasto", text: $descripcion)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .navigationTitle("Nuevo gasto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        guardarGasto()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $mostrarCategorias) {
                CategoriasView()
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            viewModel.getCategorias() // Carga las categorías cuando la vista aparece
            if let primeraCategoria = viewModel.categorias.first {
                categoriaSeleccionada = primeraCategoria.nombre // Selecciona una categoría predeterminada
            }
        }
    }
    
    private func guardarGasto() {
        if let cantidadDouble = Double(cantidad), !categoriaSeleccionada.isEmpty {
            viewModel.addGasto(cantidad: cantidadDouble, fecha: fecha, categoria: categoriaSeleccionada, descripcion: descripcion)
            dismiss()
        } else {
            // Aquí puedes agregar una alerta para notificar al usuario que complete todos los campos
        }
    }
}





#Preview {
    AgregarGastoView(viewModel: GastoViewModel())
}

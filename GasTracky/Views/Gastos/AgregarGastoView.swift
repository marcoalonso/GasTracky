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
                Section(header: Text("Cantidad")) {
                    TextField("Cantidad", text: $cantidad)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Fecha")) {
                    DatePicker("Fecha", selection: $fecha, displayedComponents: .date)
                }
                
                Section(header: Text("Categoría")) {
                    Picker("Selecciona una categoría", selection: $categoriaSeleccionada) {
                        ForEach(viewModel.categorias, id: \.id) { categoria in
                            Text(categoria.nombre).tag(categoria.nombre)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Button("Ver todas las categorías") {
                        mostrarCategorias = true
                    }
                    .sheet(isPresented: $mostrarCategorias) {
                        CategoriasView()
                    }
                }
                
                Section(header: Text("Descripción")) { // Nueva sección para la descripción
                    TextField("Descripción del gasto", text: $descripcion)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .navigationTitle("Nuevo Gasto")
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

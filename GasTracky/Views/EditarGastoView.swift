//
//  EditarGastoView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import Foundation
import SwiftUI

struct EditarGastoView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GastoViewModel
    var gasto: Gasto
    
    @State private var cantidad: String
    @State private var fecha: Date
    @State private var categoriaSeleccionada: String
    @State private var descripcion: String
    
    init(viewModel: GastoViewModel, gasto: Gasto) {
        self.viewModel = viewModel
        self.gasto = gasto
        _cantidad = State(initialValue: "\(gasto.cantidad)")
        _fecha = State(initialValue: gasto.fecha)
        _categoriaSeleccionada = State(initialValue: gasto.categoria)
        _descripcion = State(initialValue: gasto.descripcion)
    }
    
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
                }
                
                Section(header: Text("Descripción")) {
                    TextField("Descripción del gasto", text: $descripcion)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .navigationTitle("Editar Gasto")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        guardarCambios()
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
            viewModel.getCategorias() // Asegura que las categorías estén cargadas
        }
    }
    
    private func guardarCambios() {
        if let cantidadDouble = Double(cantidad) {
            viewModel.updateGasto(gasto: gasto, newCantidad: cantidadDouble, newFecha: fecha, newCategoria: categoriaSeleccionada, newDescripcion: descripcion)
            dismiss()
        } else {
            // Aquí puedes agregar una alerta para notificar al usuario que complete correctamente el campo de cantidad
        }
    }
}


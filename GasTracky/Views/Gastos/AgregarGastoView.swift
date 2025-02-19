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
    @State private var descripcion: String = ""
    @State private var mostrarCategorias = false
    @State private var showDatePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: fecha)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    InputField(title: "¿Cuánto gastaste?", text: $cantidad, placeholder: "$100", keyboardType: .decimalPad)
                    DatePickerField(formattedDate: formattedDate, showDatePicker: $showDatePicker, fecha: $fecha)
                    CategoryPicker(viewModel: viewModel, categoriaSeleccionada: $categoriaSeleccionada, mostrarCategorias: $mostrarCategorias)
                    InputField(title: "Descripción", text: $descripcion, placeholder: "Descripción")
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Nuevo gasto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    
                    Button(action: { guardarGasto() }) {
                        Text("Guardar")
                            .font(.title3)
                            .foregroundStyle(.green)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle").foregroundStyle(.red)
                    }
                }
            }
            .sheet(isPresented: $mostrarCategorias) {
                CategoriasView().environmentObject(viewModel)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("¡Atención!"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            viewModel.getCategorias()
            categoriaSeleccionada = viewModel.categorias.first?.nombre ?? ""
        }
    }
    
    private func guardarGasto() {
        if cantidad.trimmingCharacters(in: .whitespaces).isEmpty {
            showAlert(message: "Por favor ingresa una cantidad.")
            return
        }
        guard let cantidadDouble = Double(cantidad) else {
            showAlert(message: "La cantidad debe ser un número válido.")
            return
        }
        if categoriaSeleccionada.isEmpty {
            showAlert(message: "Por favor selecciona una categoría.")
            return
        }
        
        //if descripcion.isEmpty {
          //  showAlert(message: "Por favor agrega una breve descripción del gasto.")
            //return
        //}
        viewModel.addGasto(cantidad: cantidadDouble, fecha: fecha, categoria: categoriaSeleccionada, descripcion: descripcion)
        dismiss()
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

// MARK: - InputField Component
struct InputField: View {
    let title: String
    @Binding var text: String
    var placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.headline)
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
}


#Preview {
    AgregarGastoView(viewModel: GastoViewModel())
}

//
//  EditarGastoView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//
import SwiftUI

struct EditarGastoView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GastoViewModel
    var gasto: Gasto
    
    @State private var cantidad: String
    @State private var fecha: Date
    @State private var categoriaSeleccionada: String
    @State private var mostrarCategorias = false
    @State private var descripcion: String
    @State private var showDatePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    InputField(title: "¿Cuánto gastaste?", text: $cantidad, placeholder: "$100", keyboardType: .decimalPad)
                    DatePickerField(formattedDate: formattedDate, showDatePicker: $showDatePicker, fecha: $fecha)
                    CategoryPicker(viewModel: viewModel, categoriaSeleccionada: $categoriaSeleccionada, mostrarCategorias: $mostrarCategorias)
                    InputField(title: "Descripción", text: $descripcion, placeholder: "Descripción del gasto")
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Editar Gasto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        guardarCambios()
                    }) {
                        Text("Guardar")
                            .font(.title3)
                            .foregroundStyle(.green)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancelar")
                            .font(.title3)
                            .foregroundStyle(.red)
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
        .onAppear { viewModel.getCategorias() }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: fecha)
    }
    
    private func guardarCambios() {
        if cantidad.trimmingCharacters(in: .whitespaces).isEmpty {
            alertMessage = "Por favor ingresa una cantidad."
            showAlert = true
            return
        }
        if let cantidadDouble = Double(cantidad) {
            viewModel.updateGasto(gasto: gasto, newCantidad: cantidadDouble, newFecha: fecha, newCategoria: categoriaSeleccionada, newDescripcion: descripcion)
            dismiss()
        } else {
            // Puedes agregar una alerta aquí si es necesario
        }
    }
}

// MARK: - Preview
struct EditarGastoView_Previews: PreviewProvider {
    static var previews: some View {
        EditarGastoView(viewModel: GastoViewModel(), gasto: Gasto(id: UUID(), cantidad: 100.0, fecha: Date(), categoria: "Alimentación", descripcion: "Cena en restaurante"))
    }
}

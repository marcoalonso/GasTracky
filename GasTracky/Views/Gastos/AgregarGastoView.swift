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
                    Button("Guardar") { guardarGasto() }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
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
        if descripcion.isEmpty {
            showAlert(message: "Por favor agrega una breve descripción del gasto.")
            return
        }
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

// MARK: - DatePickerField Component
struct DatePickerField: View {
    let formattedDate: String
    @Binding var showDatePicker: Bool
    @Binding var fecha: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("¿Cuándo?").font(.headline)
            if showDatePicker {
                DatePicker("Fecha", selection: $fecha, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .onChange(of: fecha) { _, _ in withAnimation { showDatePicker = false } }
            } else {
                Button(action: { withAnimation { showDatePicker = true } }) {
                    HStack {
                        Text("Fecha: \(formattedDate)").foregroundColor(.black)
                        Spacer()
                        Image(systemName: "calendar")
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }
    }
}

// MARK: - CategoryPicker Component
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
                        .foregroundColor(.blue)
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








#Preview {
    AgregarGastoView(viewModel: GastoViewModel())
}

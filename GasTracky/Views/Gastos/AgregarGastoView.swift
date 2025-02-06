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
    @State private var showDatePicker = false   // Controla la visualización del DatePicker
    @State private var showAlert = false        // Controla la visualización de la alerta
    @State private var alertMessage = ""

    /// Formatea la fecha en un estilo legible
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: fecha)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Campo para ingresar la cantidad
                    VStack(alignment: .leading, spacing: 5) {
                        Text("¿Cuánto gastaste?")
                            .font(.headline)
                        TextField("$100", text: $cantidad)
                            .keyboardType(.decimalPad)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    // Campo para seleccionar la fecha (con opción de mostrar/ocultar el DatePicker)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("¿Cuándo?")
                            .font(.headline)
                        if showDatePicker {
                            DatePicker("Fecha", selection: $fecha, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .onChange(of: fecha) { _, _ in
                                    // Oculta el DatePicker cuando se selecciona una fecha
                                    withAnimation {
                                        showDatePicker = false
                                    }
                                }
                        } else {
                            Button(action: {
                                withAnimation {
                                    showDatePicker = true
                                }
                            }) {
                                HStack {
                                    Text("Fecha: \(formattedDate)")
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "calendar")
                                }
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    // Campo para seleccionar la categoría
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Categoría")
                            .font(.headline)
                        HStack {
                            // Botón para mostrar la vista de categorías en un sheet
                            Button(action: {
                                mostrarCategorias = true
                            }) {
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
                    
                    // Campo para la descripción (sin borde)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Descripción")
                            .font(.headline)
                        TextField("Descripción", text: $descripcion)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                } // Fin del VStack principal
                .padding()
            } // Fin del ScrollView
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("¡Atención!"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            viewModel.getCategorias() // Carga las categorías cuando la vista aparece
            if let primeraCategoria = viewModel.categorias.first {
                categoriaSeleccionada = primeraCategoria.nombre // Selecciona una categoría predeterminada
            }
        }
    }

    /// Valida los campos obligatorios y guarda el gasto. Muestra una alerta si algún campo falta.
    private func guardarGasto() {
        if cantidad.trimmingCharacters(in: .whitespaces).isEmpty {
            alertMessage = "Por favor ingresa una cantidad."
            showAlert = true
            return
        }
        guard let cantidadDouble = Double(cantidad) else {
            alertMessage = "La cantidad debe ser un número válido."
            showAlert = true
            return
        }
        if categoriaSeleccionada.isEmpty {
            alertMessage = "Por favor selecciona una categoría."
            showAlert = true
            return
        }
        if descripcion.isEmpty {
            alertMessage = "Por favor agrega una breve descripción del gasto."
            showAlert = true
            return
        }
        viewModel.addGasto(cantidad: cantidadDouble,
                           fecha: fecha,
                           categoria: categoriaSeleccionada,
                           descripcion: descripcion)
        dismiss()
    }
}







#Preview {
    AgregarGastoView(viewModel: GastoViewModel())
}

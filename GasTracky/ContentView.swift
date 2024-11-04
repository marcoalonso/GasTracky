//
//  ContentView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GastoViewModel()
    @State private var mostrarModal = false
    @State private var mostrarEstadisticas = false
    @State private var gastoSeleccionado: Gasto?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.gastos) { gasto in
                    VStack(alignment: .leading) {
                        Text(gasto.categoria).font(.headline)
                        Text("$\(gasto.cantidad, specifier: "%.2f")")
                        Text(gasto.fecha, style: .date).font(.subheadline)
                        Text(gasto.descripcion).font(.subheadline)
                    }
                    .contentShape(Rectangle()) // Permite que toda la celda sea seleccionable
                    .onTapGesture {
                        gastoSeleccionado = gasto
                    }
                }
                .onDelete(perform: deleteGasto)
            }
            .navigationTitle("Gastos")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Estadísticas") {
                        mostrarEstadisticas = true
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { mostrarModal = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $mostrarModal) {
                AgregarGastoView(viewModel: viewModel)
            }
            .sheet(item: $gastoSeleccionado) { gasto in
                EditarGastoView(viewModel: viewModel, gasto: gasto)
            }
            .sheet(isPresented: $mostrarEstadisticas) {
                EstadisticasView(viewModel: viewModel)
            }
        }
    }
    
    private func deleteGasto(at offsets: IndexSet) {
        offsets.forEach { index in
            let gasto = viewModel.gastos[index]
            viewModel.deleteGasto(gasto: gasto)
        }
    }
}



#Preview {
    ContentView()
}

//
//  ContentView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI

enum FiltroTiempo: String, CaseIterable {
    case dia
    case semana
    case mes
    case anio
    
    var titulo: String {
        switch self {
        case .dia: return "Día"
        case .semana: return "Semana"
        case .mes: return "Mes"
        case .anio: return "Año"
        }
    }
}

struct GastosView: View {
    @EnvironmentObject var viewModel: GastoViewModel
    @State private var mostrarModal = false
    @State private var gastoSeleccionado: Gasto?
    
    // Estado para el filtro de tiempo
    @State private var filtroSeleccionado: FiltroTiempo = .dia

    var body: some View {
        NavigationView {
            VStack {
                // Picker para seleccionar el filtro de tiempo
                Picker("Filtrar por", selection: $filtroSeleccionado) {
                    ForEach(FiltroTiempo.allCases, id: \.self) { filtro in
                        Text(filtro.titulo).tag(filtro)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Lista de gastos filtrados
                List {
                    ForEach(gastosFiltrados) { gasto in
                        VStack(alignment: .leading) {
                            Text(gasto.categoria).font(.headline)
                            Text("$ \(gasto.cantidad, specifier: "%.2f")")
                            Text(gasto.fecha, style: .date).font(.subheadline)
                            Text(gasto.descripcion).font(.subheadline)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            gastoSeleccionado = gasto
                        }
                    }
                    .onDelete(perform: deleteGasto)
                }
            }
            .navigationTitle("Gastos")
            .toolbar {
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
        }
    }
    
    // Computed property para obtener los gastos filtrados
    private var gastosFiltrados: [Gasto] {
        switch filtroSeleccionado {
        case .dia:
            return viewModel.gastos.filter { Calendar.current.isDateInToday($0.fecha) }
        case .semana:
            return viewModel.gastos.filter { Calendar.current.isDate($0.fecha, equalTo: Date(), toGranularity: .weekOfYear) }
        case .mes:
            return viewModel.gastos.filter { Calendar.current.isDate($0.fecha, equalTo: Date(), toGranularity: .month) }
        case .anio:
            return viewModel.gastos.filter { Calendar.current.isDate($0.fecha, equalTo: Date(), toGranularity: .year) }
        }
    }
    
    private func deleteGasto(at offsets: IndexSet) {
        offsets.forEach { index in
            let gasto = gastosFiltrados[index]
            viewModel.deleteGasto(gasto)
        }
    }
}





#Preview {
    GastosView()
}

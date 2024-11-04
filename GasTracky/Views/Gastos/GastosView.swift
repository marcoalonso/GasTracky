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

    // Estado para el filtro de tiempo y la fecha de referencia
    @State private var filtroSeleccionado: FiltroTiempo = .dia
    @State private var fechaReferencia: Date = Date()

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

                // Botones para navegar entre periodos de tiempo y el label de fecha actual
                HStack {
                    Button(action: mostrarPeriodoAnterior) {
                        Label("", systemImage: "chevron.left")
                    }
                    
                    Spacer()
                    
                    // Label para mostrar la descripción del periodo seleccionado
                    Text(descripcionPeriodo)
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // Ocultar el botón "Siguiente" si el periodo es actual o en el futuro
                    if !esPeriodoActual {
                        Button(action: mostrarPeriodoPosterior) {
                            Label("", systemImage: "chevron.right")
                        }
                    }
                }
                .padding(.horizontal)

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

    // Computed property para obtener los gastos filtrados según el filtro de tiempo y la fecha de referencia
    private var gastosFiltrados: [Gasto] {
        let calendar = Calendar.current
        return viewModel.gastos.filter { gasto in
            switch filtroSeleccionado {
            case .dia:
                return calendar.isDate(gasto.fecha, inSameDayAs: fechaReferencia)
            case .semana:
                return calendar.isDate(gasto.fecha, equalTo: fechaReferencia, toGranularity: .weekOfYear)
            case .mes:
                return calendar.isDate(gasto.fecha, equalTo: fechaReferencia, toGranularity: .month)
            case .anio:
                return calendar.isDate(gasto.fecha, equalTo: fechaReferencia, toGranularity: .year)
            }
        }
    }

    // Propiedad computada para la descripción del periodo actual
    private var descripcionPeriodo: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        
        switch filtroSeleccionado {
        case .dia:
            formatter.dateFormat = "d 'de' MMMM"
            return formatter.string(from: fechaReferencia)
            
        case .semana:
            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: fechaReferencia))!
            let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
            
            formatter.dateFormat = "d MMM"
            let start = formatter.string(from: startOfWeek)
            let end = formatter.string(from: endOfWeek)
            return "\(start) - \(end)"
            
        case .mes:
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: fechaReferencia)
            
        case .anio:
            formatter.dateFormat = "yyyy"
            return formatter.string(from: fechaReferencia)
        }
    }

    // Computed property para verificar si el periodo seleccionado es el actual o en el futuro
    private var esPeriodoActual: Bool {
        let calendar = Calendar.current
        switch filtroSeleccionado {
        case .dia:
            return calendar.isDateInToday(fechaReferencia)
        case .semana:
            return calendar.isDate(fechaReferencia, equalTo: Date(), toGranularity: .weekOfYear)
        case .mes:
            return calendar.isDate(fechaReferencia, equalTo: Date(), toGranularity: .month)
        case .anio:
            return calendar.isDate(fechaReferencia, equalTo: Date(), toGranularity: .year)
        }
    }

    // Función para retroceder al periodo anterior
    private func mostrarPeriodoAnterior() {
        let calendar = Calendar.current
        switch filtroSeleccionado {
        case .dia:
            fechaReferencia = calendar.date(byAdding: .day, value: -1, to: fechaReferencia) ?? fechaReferencia
        case .semana:
            fechaReferencia = calendar.date(byAdding: .weekOfYear, value: -1, to: fechaReferencia) ?? fechaReferencia
        case .mes:
            fechaReferencia = calendar.date(byAdding: .month, value: -1, to: fechaReferencia) ?? fechaReferencia
        case .anio:
            fechaReferencia = calendar.date(byAdding: .year, value: -1, to: fechaReferencia) ?? fechaReferencia
        }
    }

    // Función para avanzar al periodo siguiente
    private func mostrarPeriodoPosterior() {
        let calendar = Calendar.current
        switch filtroSeleccionado {
        case .dia:
            fechaReferencia = calendar.date(byAdding: .day, value: 1, to: fechaReferencia) ?? fechaReferencia
        case .semana:
            fechaReferencia = calendar.date(byAdding: .weekOfYear, value: 1, to: fechaReferencia) ?? fechaReferencia
        case .mes:
            fechaReferencia = calendar.date(byAdding: .month, value: 1, to: fechaReferencia) ?? fechaReferencia
        case .anio:
            fechaReferencia = calendar.date(byAdding: .year, value: 1, to: fechaReferencia) ?? fechaReferencia
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

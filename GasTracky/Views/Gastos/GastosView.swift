//
//  ContentView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI

struct GastosView: View {
    @EnvironmentObject var viewModel: GastoViewModel
    @State private var mostrarModal = false
    @State private var gastoSeleccionado: Gasto?
    @State private var filtroSeleccionado: FiltroTiempo = .dia
    @State private var fechaReferencia: Date = Date()
    
    // Estado para controlar la expansión de categorías
    @State private var categoriasExpandida: [String: Bool] = [:]
    
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
                    
                    Text(descripcionPeriodo)
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    if !esPeriodoActual {
                        Button(action: mostrarPeriodoPosterior) {
                            Label("", systemImage: "chevron.right")
                        }
                    }
                }
                .padding(.horizontal)

                // Lista de gastos agrupados por categoría
                List {
                    ForEach(gastosAgrupados.keys.sorted(), id: \.self) { categoria in
                        Section {
                            // Encabezado de cada categoría con el total y el botón desplegable
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                    .frame(width: 32, height: 32)
                                
                                Text(categoria)
                                    .font(.headline)
                                Spacer()
                                Text("$ \(gastosAgrupados[categoria]?.total ?? 0.0, specifier: "%.2f")")
                                    .font(.subheadline)
                                // Mostrar el icono de despliegue solo si hay dos o más gastos en la categoría
                                if let detalles = gastosAgrupados[categoria]?.detalles, detalles.count > 1 {
                                    Image(systemName: "chevron.down.circle")
                                        .rotationEffect(categoriasExpandida[categoria] == true ? .degrees(180) : .degrees(0))
                                        .onTapGesture {
                                            toggleExpandirCategoria(categoria)
                                        }
                                }
                            }
                            
                            
                            // Desglose de los gastos en la categoría si está expandida
                            if categoriasExpandida[categoria] == true {
                                ForEach(gastosAgrupados[categoria]?.detalles ?? [], id: \.id) { gasto in
                                    HStack {
                                        Text(gasto.descripcion)
                                            .font(.subheadline)
                                        Spacer()
                                        Text("$ \(gasto.cantidad, specifier: "%.2f")")
                                            .font(.footnote)
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        gastoSeleccionado = gasto
                                    }
                                }
                            }
                        }
                        
                    }
                    .onDelete(perform: deleteGasto)
                }
                .listStyle(InsetGroupedListStyle())
                
                Button(action: { mostrarModal = true }) {
                    Image("plus")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .bottom)
                }
                
            }
            .navigationTitle("Gastos")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $mostrarModal) {
                AgregarGastoView(viewModel: viewModel)
            }
            .sheet(item: $gastoSeleccionado) { gasto in
                EditarGastoView(viewModel: viewModel, gasto: gasto)
            }
        }
    }

    // Computed property para agrupar los gastos y calcular el total por categoría
    private var gastosAgrupados: [String: (total: Double, detalles: [Gasto])] {
        var agrupados: [String: (total: Double, detalles: [Gasto])] = [:]
        
        for gasto in gastosFiltrados {
            if agrupados[gasto.categoria] != nil {
                agrupados[gasto.categoria]?.total += gasto.cantidad
                agrupados[gasto.categoria]?.detalles.append(gasto)
            } else {
                agrupados[gasto.categoria] = (total: gasto.cantidad, detalles: [gasto])
            }
        }
        
        return agrupados
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
    
    // Función para alternar el estado de expansión de una categoría
    private func toggleExpandirCategoria(_ categoria: String) {
        categoriasExpandida[categoria]?.toggle() ?? (categoriasExpandida[categoria] = true)
    }
}






#Preview {
    GastosView()
        .environmentObject(GastoViewModel())
}

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
    @State private var lastAccess: Date = Date()
    
    // Estado para controlar la expansión de categorías
    @State private var categoriasExpandida: [String: Bool] = [:]
    
    private var dateSelector: some View {
        VStack {
            Picker("Filtrar por", selection: $filtroSeleccionado) {
                ForEach(FiltroTiempo.allCases, id: \.self) { filtro in
                    Text(filtro.titulo).tag(filtro)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            HStack {
                Button(action: mostrarPeriodoAnterior) {
                    Label("", systemImage: "chevron.left")
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                Text(descripcionPeriodo)
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if !esPeriodoActual {
                    Button(action: mostrarPeriodoPosterior) {
                        Label("", systemImage: "chevron.right")
                            .foregroundStyle(.black)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding() // Padding interno para separar el contenido del borde
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6)) // Color gris claro
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Sombra
        )
        .padding(.horizontal, 10) // Padding externo para separar el rectángulo de otros elementos en la pantalla
    }
    
    private var dynamicHeight: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight * 0.25
    }
    
    // Filtrar y agrupar los gastos según el filtro de tiempo seleccionado
    private var gastosFiltradosYAgrupados: [CategoriaGasto] {
        let calendar = Calendar.current
        let gastosFiltrados = viewModel.gastos.filter { gasto in
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
        
        // Agrupar y sumar los gastos por categoría
        let gastosAgrupados = Dictionary(grouping: gastosFiltrados, by: { $0.categoria })
            .map { (categoria, gastos) -> CategoriaGasto in
                let total = gastos.reduce(0) { $0 + $1.cantidad }
                return CategoriaGasto(categoria: categoria, total: total)
            }
        
        return gastosAgrupados
    }
    
    // Calcular el total gastado en el período seleccionado
    private var totalGastado: Double {
        gastosFiltradosYAgrupados.reduce(0) { $0 + $1.total }
    }
    
    private var totalGastadoView: some View {
        Text("Total gastado: $\(totalGastado, specifier: "%.2f")")
            .font(.title3)
            .padding(10)                         // padding interno
            .frame(maxWidth: .infinity)        // se expande en ancho
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal, 10)          // mismo padding horizontal que el picker
    }
    
    private var graficoGastos: some View {
        ZStack {
            GraficoDona(gastos: gastosFiltradosYAgrupados, height: dynamicHeight, periodoNombre: filtroSeleccionado.titulo)
                
            VStack {
                HStack {
                    Spacer()
                    Button(action: { mostrarModal = true }) {
                        Image("plus2")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .bottom)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                }
                Spacer()
            }
        }
        .padding() // Padding interno para separar el contenido del borde
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6)) // Color gris claro
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Sombra
            )
            .padding(.horizontal, 10) // Padding externo para separar el rectángulo de otros elementos en la pantalla

    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                totalGastadoView
                dateSelector
                graficoGastos

                List {
                    ForEach(gastosAgrupados.keys.sorted(), id: \.self) { categoria in
                        Section {
                            NavigationLink(destination: GastosPorCategoriaView(
                                categoria: categoria,
                                gastos: gastosAgrupados[categoria]?.detalles ?? []
                            )) {
                                HStack {
                                    // Mostrar el icono de despliegue solo si hay dos o más gastos en la categoría
                                    if let detalles = gastosAgrupados[categoria]?.detalles, detalles.count > 1 {
                                        Image(systemName: "chevron.down.circle")
                                            .rotationEffect(categoriasExpandida[categoria] == true ? .degrees(180) : .degrees(0))
                                            .onTapGesture {
                                                toggleExpandirCategoria(categoria)
                                            }
                                    }
                                    
                                    Text(categoria)
                                        .font(.headline)
                                    Spacer()
                                    Text("$\(gastosAgrupados[categoria]?.total ?? 0.0, specifier: "%.1f")")
                                        .font(.subheadline)
                                        .bold()
                                }
                            }
                            
                            // Mostrar gastos de la categoría solo si está expandida
                            if categoriasExpandida[categoria] == true {
                                ForEach(gastosAgrupados[categoria]?.detalles ?? [], id: \.id) { gasto in
                                    HStack {
                                        Text("  ")
                                        Text(gasto.descripcion)
                                            .font(.subheadline)
                                        Spacer()
                                        Text("$ \(gasto.cantidad, specifier: "%.1f")")
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
                .listStyle(InsetListStyle())
                
                
            }
            .onAppear {
                saveLastAccess()
            }
            .sheet(isPresented: $mostrarModal, content: {
                AgregarGastoView(viewModel: viewModel)
                    .presentationDetents([.fraction(0.8), .large])
                    .presentationDragIndicator(.visible)
            })
            .sheet(item: $gastoSeleccionado) { gasto in
                EditarGastoView(viewModel: viewModel, gasto: gasto)
            }
        }
    }
    
    private func saveLastAccess() {
        let defaults = UserDefaults.standard
        
        if let storedDate = defaults.object(forKey: "lastAccess") as? Date {
            lastAccess = storedDate
        }
        
        defaults.set(Date(), forKey: "lastAccess")
    }

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
    
    private func toggleExpandirCategoria(_ categoria: String) {
        categoriasExpandida[categoria]?.toggle() ?? (categoriasExpandida[categoria] = true)
    }
}






#Preview {
    GastosView()
        .environmentObject(GastoViewModel())
}

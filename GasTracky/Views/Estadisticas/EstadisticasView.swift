//
//  EstadisticasView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI
import Charts

struct EstadisticasView: View {
    @EnvironmentObject var viewModel: GastoViewModel
    @State private var tipoGrafico: TipoGrafico = .dona
    @State private var filtroSeleccionado: FiltroTiempo = .dia
    @State private var fechaReferencia: Date = Date()
    
    private var dynamicHeight: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight * 0.6
    }
    
    private var dateSelector: some View {
        VStack {
            Picker("Filtrar por", selection: $filtroSeleccionado) {
                ForEach(FiltroTiempo.allCases, id: \.self) { filtro in
                    Text(filtro.titulo).tag(filtro)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

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
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                // Mostrar el total gastado
                VStack {
                    Text("Total gastado: $\(totalGastado, specifier: "%.2f")")
                        .font(.title2)
                        .padding() // Padding interno para separar el contenido del borde
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6)) // Color gris claro
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Sombra
                        )
                }
                
                dateSelector
                    .padding() // Padding interno para separar el contenido del borde
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6)) // Color gris claro
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Sombra
                    )
                    .padding() // Padding externo para separar el rectángulo de otros elementos en la pantalla
                
                
                VStack {
                    Picker("Tipo de gráfico", selection: $tipoGrafico) {
                        ForEach(TipoGrafico.allCases, id: \.self) { tipo in
                            Text(tipo.titulo).tag(tipo)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6)) // Color gris claro
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Sombra
                    )
                }
                
                switch tipoGrafico {
                case .dona:
                    GraficoDona(gastos: gastosFiltradosYAgrupados, height: dynamicHeight)
                case .barras:
                    GraficoBarras(gastos: gastosFiltradosYAgrupados, height: dynamicHeight)
                case .puntos:
                    GraficoPuntos(gastos: gastosFiltradosYAgrupados, height: dynamicHeight)
                case .lineas:
                    GraficoLinea(gastos: gastosFiltradosYAgrupados, height: dynamicHeight)
                }
                
                Spacer()
            }
            .padding(.horizontal, 12)
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
            return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
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
}


enum TipoGrafico: String, CaseIterable {
    case dona
    case barras
    case puntos
    case lineas
    
    var titulo: String {
        switch self {
        case .dona: return "Dona"
        case .barras: return "Barras"
        case .puntos: return "Puntos"
        case .lineas: return "Líneas"
        }
    }
}


#Preview {
    EstadisticasView()
        .environmentObject(GastoViewModel())
}

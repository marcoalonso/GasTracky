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

    // Filtrar los gastos según el filtro de tiempo seleccionado
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
    
    var body: some View {
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
                
                if !esPeriodoActual {
                    Button(action: mostrarPeriodoPosterior) {
                        Label("", systemImage: "chevron.right")
                    }
                }
            }
            .padding(.horizontal)
            
            // Picker para seleccionar el tipo de gráfico
            Picker("Tipo de gráfico", selection: $tipoGrafico) {
                ForEach(TipoGrafico.allCases, id: \.self) { tipo in
                    Text(tipo.titulo).tag(tipo)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Muestra el gráfico según el tipo seleccionado y los datos filtrados
            switch tipoGrafico {
            case .dona:
                GraficoDona(gastos: gastosFiltrados, height: dynamicHeight)
            case .barras:
                GraficoBarras(gastos: gastosFiltrados, height: dynamicHeight)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Estadísticas")
    }
    
    // Computed property para la descripción del periodo actual
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
}

// MARK: - Tipo de Gráfico Enum

enum TipoGrafico: String, CaseIterable {
    case dona
    case barras
    
    var titulo: String {
        switch self {
        case .dona: return "Dona"
        case .barras: return "Barras"
        }
    }
}

#Preview {
    EstadisticasView()
        .environmentObject(GastoViewModel())
}

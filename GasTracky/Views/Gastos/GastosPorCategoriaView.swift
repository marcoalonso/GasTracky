//
//  GastosPorCategoriaView.swift
//  GasTracky
//
//  Created by Marco Alonso Rodriguez on 26/11/24.
//

import SwiftUI


struct GastosPorCategoriaView: View {
    @EnvironmentObject var viewModel: GastoViewModel
    var categoria: String
    var gastos: [Gasto]
    
    @State private var gastoSeleccionado: Gasto?
    
    // Obtener la fecha formateada (asumiendo que todos los gastos tienen la misma fecha)
    private var fechaFormateada: String {
        guard let fecha = gastos.first?.fecha else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "d 'de' MMMM 'de' yyyy"
        return formatter.string(from: fecha)
    }

    var body: some View {
        VStack {
            Text(fechaFormateada)
                .font(.title3)
                .bold()
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
            
            List {
                ForEach(gastos, id: \.id) { gasto in
                    HStack {
                        Text(gasto.descripcion)
                            .font(.subheadline)
                        Spacer()
                        Text("$ \(gasto.cantidad, specifier: "%.2f")")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        gastoSeleccionado = gasto
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(categoria)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $gastoSeleccionado) { gasto in
                EditarGastoView(viewModel: viewModel, gasto: gasto)
            }
        }
    }
}

#Preview {
    // Datos simulados para la previsualización
    let mockGastos = [
        Gasto(cantidad: 20.0, fecha: Date(), categoria: "Alimentación", descripcion: "Compra de frutas"),
        Gasto(cantidad: 15.0, fecha: Date(), categoria: "Alimentación", descripcion: "Panadería"),
        Gasto(cantidad: 50.0, fecha: Date(), categoria: "Alimentación", descripcion: "Supermercado")
    ]

    return GastosPorCategoriaView(categoria: "Alimentación", gastos: mockGastos)
        .environmentObject(GastoViewModel())
}

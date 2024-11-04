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
    
    var body: some View {
        VStack {
            Text("Estadísticas de Gastos")
                .font(.title)
            
            Chart {
                ForEach(viewModel.gastos, id: \.id) { gasto in
                    BarMark(
                        x: .value("Categoría", gasto.categoria),
                        y: .value("Cantidad", gasto.cantidad)
                    )
                }
            }
            .frame(height: 300)
        }
        .padding()
        .navigationTitle("Estadísticas")
    }
}



#Preview {
    EstadisticasView()
}

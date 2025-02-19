//
//  GraficoBarras.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI
import Charts

struct GraficoBarras: View {
    var gastos: [CategoriaGasto]
    var height: CGFloat

    var body: some View {
        Chart(gastos) { gasto in
            BarMark(
                x: .value("Categoría", gasto.categoria),
                y: .value("Cantidad", gasto.total)
            )
            .foregroundStyle(by: .value("Categoría", gasto.categoria))
            
            // Etiqueta que muestra el total de cada categoría sobre cada barra
            .annotation(position: .top) {
                Text("$\(gasto.total, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.black)
                    .padding(2)
            }
        }
        .frame(height: height)
    }
}

#Preview {
    GraficoBarras(gastos: MockData.shared.gastosAgrupados, height: 300)
}



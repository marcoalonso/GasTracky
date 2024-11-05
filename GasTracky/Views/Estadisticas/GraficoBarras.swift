//
//  GraficoBarras.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI
import Charts

struct GraficoBarras: View {
    var gastos: [Gasto]
    var height: CGFloat

    var body: some View {
        Chart(gastos) { gasto in
            BarMark(
                x: .value("Categoría", gasto.categoria),
                y: .value("Cantidad", gasto.cantidad)
            )
            .foregroundStyle(by: .value("Categoría", gasto.categoria))
        }
        .frame(height: height)
    }
}

#Preview {
    GraficoBarras(gastos: MockData.shared.gastos, height: 300)
}


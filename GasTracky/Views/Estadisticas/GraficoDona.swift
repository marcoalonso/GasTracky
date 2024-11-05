//
//  GraficoDona.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI
import Charts

struct GraficoDona: View {
    var gastos: [Gasto]
    var height: CGFloat

    var body: some View {
        Chart(gastos) { gasto in
            SectorMark(
                angle: .value("Cantidad", gasto.cantidad),
                innerRadius: .ratio(0.5),
                angularInset: 2
            )
            .foregroundStyle(by: .value("Categoría", gasto.categoria))
        }
        .frame(height: height)
    }
}

#Preview {
    GraficoDona(gastos: MockData.shared.gastos, height: 300)
}

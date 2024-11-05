//
//  GraficoDona.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI
import Charts

struct GraficoDona: View {
    var gastos: [CategoriaGasto]
    var height: CGFloat

    var body: some View {
        Chart(gastos) { gasto in
            SectorMark(
                angle: .value("Cantidad", gasto.total),
                innerRadius: .ratio(0.5),
                angularInset: 2
            )
            .foregroundStyle(by: .value("Categoría", gasto.categoria))
            
            // Etiqueta que muestra el total de cada categoría en el gráfico de dona
            .annotation(position: .overlay, alignment: .center) {
                Text("$\(gasto.total, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color.black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
        .frame(height: height)
    }
}

#Preview {
    GraficoDona(gastos: MockData.shared.gastosAgrupados, height: 300)
}

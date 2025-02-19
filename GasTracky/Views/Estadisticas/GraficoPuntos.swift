//
//  GraficoPuntos.swift
//  GasTracky
//
//  Created by Marco Alonso Rodriguez on 18/02/25.
//

import SwiftUI
import Charts

struct GraficoPuntos: View {
    var gastos: [CategoriaGasto]
    var height: CGFloat
    var body: some View {
        Chart(gastos) { item in
            PointMark(x: .value("Tiempo", item.categoria), y: .value("Valor", item.total))
                .foregroundStyle(.black)
                .annotation {
                    Text("$\(item.total, specifier: "%.1f")")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(2)
                }
        }
        .frame(height: height)
    }
}

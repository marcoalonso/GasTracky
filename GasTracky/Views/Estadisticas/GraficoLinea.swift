//
//  GraficoLinea.swift
//  GasTracky
//
//  Created by Marco Alonso Rodriguez on 18/02/25.
//

import SwiftUI
import Charts

struct GraficoLinea: View {
    var gastos: [CategoriaGasto]
    var height: CGFloat

    var body: some View {
        Chart(gastos) { item in
            // Línea que conecta cada punto
            LineMark(
                x: .value("Categoría", item.categoria),
                y: .value("Total", item.total)
            )
            .foregroundStyle(.blue)
            
            // Marcador en cada punto con su anotación
            PointMark(
                x: .value("Categoría", item.categoria),
                y: .value("Total", item.total)
            )
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


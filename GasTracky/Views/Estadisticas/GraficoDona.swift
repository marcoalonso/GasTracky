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
    var periodoNombre: String   // p.ej. "día", "semana", "mes" o "año"
    
    private var articulo: String {
        periodoNombre == "semana" ? "esta" : "este"
    }

    var body: some View {
        Group {
            if gastos.isEmpty {
                // Mensaje centrado en un frame de altura fija
                Text("No hubo gastos registrados en \(articulo) \(periodoNombre)")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
            } else {
                // Tu gráfica de dona original
                Chart(gastos) { gasto in
                    SectorMark(
                        angle: .value("Cantidad", gasto.total),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(by: .value("Categoría", gasto.categoria))
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
        .padding(.horizontal, 10)
    }
}

#Preview {
    let sinGastos: [CategoriaGasto] = []
    GraficoDona(gastos: MockData.shared.gastosAgrupados, height: 300, periodoNombre: "dia")
    GraficoDona(gastos: sinGastos, height: 300, periodoNombre: "dia")
        .padding() // Padding interno para separar el contenido del borde
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6)) // Color gris claro
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Sombra
        )
        .padding(.horizontal, 10) // Padding externo para separar el rectángulo de otros elementos en la pantalla
}


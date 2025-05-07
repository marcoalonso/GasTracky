//
//  Gasto.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import Foundation
import SwiftData

@Model
class Gasto {
    @Attribute(.unique) var id: UUID
    var cantidad: Double
    var fecha: Date
    var categoria: String
    var descripcion: String  
    
    init(id: UUID = UUID(), cantidad: Double, fecha: Date, categoria: String, descripcion: String) {
        self.id = id
        self.cantidad = cantidad
        self.fecha = fecha
        self.categoria = categoria
        self.descripcion = descripcion
    }
}

// Estructura para representar el total por categoría
struct CategoriaGasto: Identifiable {
    let id = UUID()
    let categoria: String
    let total: Double
}

class MockData {
    static let shared = MockData()
    
    // Datos de prueba
    let gastosAgrupados: [CategoriaGasto]
    
    private init() {
        let gastos = [
            Gasto(cantidad: 20.0, fecha: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, categoria: "Alimentación", descripcion: "Compra de frutas"),
            Gasto(cantidad: 50.0, fecha: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, categoria: "Auto", descripcion: "Gasolina"),
            Gasto(cantidad: 100.0, fecha: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, categoria: "Hogar", descripcion: "Mantenimiento de la casa"),
            Gasto(cantidad: 30.0, fecha: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, categoria: "Entretenimiento", descripcion: "Cine y snacks"),
            Gasto(cantidad: 80.0, fecha: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, categoria: "Alimentación", descripcion: "Cena en restaurante"),
            Gasto(cantidad: 45.0, fecha: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, categoria: "Salud", descripcion: "Medicinas"),
            Gasto(cantidad: 200.0, fecha: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, categoria: "Alimentación", descripcion: "Supermercado"),
            Gasto(cantidad: 60.0, fecha: Calendar.current.date(byAdding: .day, value: -8, to: Date())!, categoria: "Auto", descripcion: "Reparación menor"),
            Gasto(cantidad: 25.0, fecha: Calendar.current.date(byAdding: .day, value: -9, to: Date())!, categoria: "Entretenimiento", descripcion: "Suscripción de streaming"),
            Gasto(cantidad: 150.0, fecha: Calendar.current.date(byAdding: .day, value: -10, to: Date())!, categoria: "Hogar", descripcion: "Compra de muebles")
        ]
        
        // Agrupar y sumar los gastos por categoría
        let gastosAgrupadosDict = Dictionary(grouping: gastos, by: { $0.categoria })
            .map { (categoria, gastos) -> CategoriaGasto in
                let total = gastos.reduce(0) { $0 + $1.cantidad }
                return CategoriaGasto(categoria: categoria, total: total)
            }
        
        self.gastosAgrupados = gastosAgrupadosDict
    }
}


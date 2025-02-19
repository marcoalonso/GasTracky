//
//  MockGastoVM.swift
//  GasTracky
//
//  Created by Marco Alonso Rodriguez on 26/11/24.
//

import Foundation
import SwiftUI

class MockGastoViewModel: GastoViewModel {
    init(mockData: Bool = true) {
        super.init()
        if mockData {
            self.gastos = [
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
            self.categorias = [
                Categoria(id: UUID(), nombre: "Alimentación"),
                Categoria(id: UUID(), nombre: "Auto"),
                Categoria(id: UUID(), nombre: "Hogar"),
                Categoria(id: UUID(), nombre: "Entretenimiento"),
                Categoria(id: UUID(), nombre: "Salud")
            ]
        }
    }
}



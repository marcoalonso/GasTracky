//
//  GastoViewModel.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class GastoViewModel: ObservableObject {
    
    @ObservationIgnored
    private let dataSource: SwiftDataService

    init(dataSource: SwiftDataService = SwiftDataService.shared) {
        self.dataSource = dataSource
        getGastos()
        getCategorias()
    }
    
    var gastos: [Gasto] = []
    var categorias: [Categoria] = []
    
    func addGasto(cantidad: Double, fecha: Date, categoria: String) {
        let newGasto = Gasto(id: UUID(), cantidad: cantidad, fecha: fecha, categoria: categoria)
        insertGasto(gasto: newGasto)
    }
    
    func deleteGasto(gasto: Gasto) {
        dataSource.remove(gasto)
        gastos = []
        getGastos()
    }
    
    func updateGasto(gasto: Gasto, newCantidad: Double, newFecha: Date, newCategoria: String) {
        gasto.cantidad = newCantidad
        gasto.fecha = newFecha
        gasto.categoria = newCategoria
        
        gastos = []
        getGastos()
    }
    
    func getGastos() {
        gastos = dataSource.fetch()
    }
    
    private func insertGasto(gasto: Gasto) {
        dataSource.append(gasto)
        gastos = []
        getGastos()
    }
    
    // Métodos para manejar las categorías
    func addCategoria(nombre: String) {
        let newCategoria = Categoria(id: UUID(), nombre: nombre)
        insertCategoria(categoria: newCategoria)
    }
    
    func deleteCategoria(categoria: Categoria) {
        dataSource.remove(categoria)
        categorias = []
        getCategorias()
    }
    
    func getCategorias() {
        categorias = dataSource.fetch()
    }
    
    private func insertCategoria(categoria: Categoria) {
        dataSource.append(categoria)
        categorias = []
        getCategorias()
    }
}


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
    
    func addGasto(cantidad: Double, fecha: Date, categoria: String, descripcion: String) {
        let newGasto = Gasto(id: UUID(), cantidad: cantidad, fecha: fecha, categoria: categoria, descripcion: descripcion)
        insertGasto(gasto: newGasto)
    }
    
    func deleteGasto(_ gasto: Gasto) {
        dataSource.remove(gasto)
        gastos = []
        getGastos()
    }
    
    func updateGasto(gasto: Gasto, newCantidad: Double, newFecha: Date, newCategoria: String, newDescripcion: String) {
        gasto.cantidad = newCantidad
        gasto.fecha = newFecha
        gasto.categoria = newCategoria
        gasto.descripcion = newDescripcion
        
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
        // Eliminar todos los gastos relacionados con esta categoría
        let gastosRelacionados = gastos.filter { $0.categoria == categoria.nombre }
        for gasto in gastosRelacionados {
            deleteGasto(gasto) // Elimina cada gasto relacionado
        }
        
        // Eliminar la categoría de la base de datos y recargar la lista de categorías
        dataSource.remove(categoria)
        getCategorias()
    }
    
    func getCategorias() {
        categorias = dataSource.fetch()
        
        // Si no hay categorías, agregamos las categorías por defecto
        if categorias.isEmpty {
            let categoriasPorDefecto = ["Alimentación", "Auto", "Hogar"]
            for nombre in categoriasPorDefecto {
                addCategoria(nombre: nombre)
            }
        }
    }
    
    private func insertCategoria(categoria: Categoria) {
        dataSource.append(categoria)
        categorias = []
        getCategorias()
    }
}

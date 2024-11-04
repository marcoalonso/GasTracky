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


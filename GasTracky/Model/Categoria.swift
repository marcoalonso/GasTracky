//
//  Categoria.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import Foundation
import SwiftData

@Model
class Categoria {
    @Attribute(.unique) var id: UUID
    var nombre: String
    
    init(id: UUID = UUID(), nombre: String) {
        self.id = id
        self.nombre = nombre
    }
}


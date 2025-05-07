//
//  filtroTiempo.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import Foundation

enum FiltroTiempo: String, CaseIterable {
    case dia
    case semana
    case mes
    case anio
    
    var titulo: String {
        switch self {
        case .dia: return "día"
        case .semana: return "semana"
        case .mes: return "mes"
        case .anio: return "año"
        }
    }
}

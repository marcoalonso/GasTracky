//
//  SwiftDataService.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import Foundation
import SwiftData

final class SwiftDataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = SwiftDataService()

    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: Gasto.self, Categoria.self)
        self.modelContext = modelContainer.mainContext
    }

    func append<T: PersistentModel>(_ data: T) {
        modelContext.insert(data)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetch<T: PersistentModel>() -> [T] {
        do {
            return try modelContext.fetch(FetchDescriptor<T>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func remove<T: PersistentModel>(_ data: T) {
        do {
            modelContext.delete(data)
            try modelContext.save()
        } catch {
            print("Error al eliminar el dato: \(error.localizedDescription)")
        }
    }
}


//
//  ContentView.swift
//  GasTracky
//
//  Created by Marco Alonso on 04/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GastoViewModel()
    @State private var mostrarModal = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.gastos) { gasto in
                    VStack(alignment: .leading) {
                        Text(gasto.categoria).font(.headline)
                        Text("\(gasto.cantidad, specifier: "%.2f") USD")
                        Text(gasto.fecha, style: .date).font(.subheadline)
                    }
                }
            }
            .navigationTitle("Gastos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { mostrarModal = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $mostrarModal) {
                AgregarGastoView(viewModel: viewModel)
            }
        }
    }
}


#Preview {
    ContentView()
}

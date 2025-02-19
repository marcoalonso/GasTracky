//
//  DatePickerField.swift
//  GasTracky
//
//  Created by Marco Alonso Rodriguez on 18/02/25.
//

import SwiftUI

struct DatePickerField: View {
    let formattedDate: String
    @Binding var showDatePicker: Bool
    @Binding var fecha: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("¿Cuándo?").font(.headline)
            if showDatePicker {
                DatePicker("Fecha", selection: $fecha, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .onChange(of: fecha) { _, _ in withAnimation { showDatePicker = false } }
            } else {
                Button(action: { withAnimation { showDatePicker = true } }) {
                    HStack {
                        Text("Fecha: \(formattedDate)").foregroundColor(.black)
                        Spacer()
                        Image(systemName: "calendar")
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct DatePickerField_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerField(formattedDate: "Feb 20, 2025", showDatePicker: .constant(false), fecha: .constant(Date()))
    }
}

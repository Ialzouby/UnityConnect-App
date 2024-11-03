//
//  AddEventView.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import SwiftUI

struct AddEventView: View {
    @Binding var isPresented: Bool // Binding to control sheet presentation
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    var onAdd: (Event) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Button("Add Event") {
                    let newEvent = Event(title: title, description: description, date: date)
                    onAdd(newEvent)
                    isPresented = false // Set binding to false to dismiss the sheet
                }
                .disabled(title.isEmpty || description.isEmpty)
            }
            .navigationTitle("Add Event")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false // Dismiss the sheet on cancel
                    }
                }
            }
        }
    }
}

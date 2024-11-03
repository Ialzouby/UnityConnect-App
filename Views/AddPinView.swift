import SwiftUI
import MapKit

class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    var onUpdate: ([MKLocalSearchCompletion]) -> Void

    init(onUpdate: @escaping ([MKLocalSearchCompletion]) -> Void) {
        self.onUpdate = onUpdate
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        onUpdate(completer.results)
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error retrieving address suggestions: \(error.localizedDescription)")
    }
}

import SwiftUI
import MapKit

// ViewModel to handle search completion logic
class AddPinViewModel: ObservableObject {
    @Published var name = ""
    @Published var description = ""
    @Published var address = ""
    @Published var suggestions: [MKLocalSearchCompletion] = []
    var selectedLocation: CLLocationCoordinate2D?

    private let searchCompleter = MKLocalSearchCompleter()
    private var completerDelegate: SearchCompleterDelegate?

    init() {
        setupSearchCompleter()
    }

    private func setupSearchCompleter() {
        // Initialize the delegate
        completerDelegate = SearchCompleterDelegate { [weak self] suggestions in
            self?.suggestions = suggestions
        }
        searchCompleter.delegate = completerDelegate
    }

    func updateSearchResults() {
        if address.isEmpty {
            suggestions = []
        } else {
            searchCompleter.queryFragment = address
        }
    }

    func selectSuggestion(_ suggestion: MKLocalSearchCompletion, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        address = suggestion.title
        fetchCoordinates(for: suggestion) { coordinate in
            self.selectedLocation = coordinate
            completion(coordinate)
        }
        suggestions = []
    }

    private func fetchCoordinates(for suggestion: MKLocalSearchCompletion, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: suggestion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                completion(nil)
                return
            }
            completion(coordinate)
        }
    }
}

struct AddPinView: View {
    @Binding var isPresented: Bool
    @ObservedObject private var viewModel = AddPinViewModel()
    var onAdd: (PlacePin) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location Details")) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                    TextField("Address", text: $viewModel.address)
                        .onChange(of: viewModel.address) { _ in
                            viewModel.updateSearchResults()
                        }
                    
                    if !viewModel.suggestions.isEmpty {
                        List(viewModel.suggestions, id: \.self) { suggestion in
                            Button(action: {
                                viewModel.selectSuggestion(suggestion) { coordinate in
                                    // Handle coordinate if needed
                                }
                            }) {
                                Text(suggestion.title)
                                    .foregroundColor(.primary)
                            }
                        }
                        .frame(maxHeight: 200)
                    }
                }
                
                Button("Add Pin") {
                    if let coordinate = viewModel.selectedLocation {
                        let newPin = PlacePin(
                            name: viewModel.name,
                            coordinate: coordinate,
                            description: viewModel.description
                        )
                        onAdd(newPin)
                        isPresented = false
                    }
                }
                .disabled(viewModel.name.isEmpty || viewModel.description.isEmpty || viewModel.selectedLocation == nil)
            }
            .navigationTitle("Add Pin")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

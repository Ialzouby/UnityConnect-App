import SwiftUI

struct EventsView: View {
    @State private var selectedDate = Date()
    @State private var events: [Event] = []
    @State private var showingAddEventSheet = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Custom Calendar View with Month Display and Dots
                CustomCalendarView(selectedDate: $selectedDate, events: events)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                // List of Events for Selected Date
                if eventsForSelectedDate.isEmpty {
                    Text("No events for this day.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(eventsForSelectedDate) { event in
                            Text(event.title)
                                .font(.headline)
                        }
                    }
                    .padding(.vertical)
                }
                
                // Upcoming Events Section
                upcomingEventsSection
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEventSheet.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEventSheet) {
                AddEventView(isPresented: $showingAddEventSheet) { newEvent in
                    events.append(newEvent)
                }
            }
        }
    }
    
    private var eventsForSelectedDate: [Event] {
        events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    private var upcomingEvents: [Event] {
        events.filter { $0.date > Date() }
            .sorted(by: { $0.date < $1.date })
    }
    
    private var upcomingEventsSection: some View {
        VStack(alignment: .leading) {
            Text("Upcoming Events")
                .font(.headline)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    ForEach(upcomingEvents.prefix(4)) { event in
                        UpcomingEventView(event: event)
                            .frame(width: 150)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func showingEventDetail(for event: Event) {
        // Implement your event detail view navigation here
    }
}

struct CustomCalendarView: View {
    @Binding var selectedDate: Date
    var events: [Event]
    
    private var daysInMonth: [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: selectedDate)!
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: selectedDate.startOfMonth())
        }
    }
    
    private var daysWithEvents: Set<Date> {
        Set(events.map { Calendar.current.startOfDay(for: $0.date) })
    }
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        VStack {
            // Month and Year Display
            Text("\(selectedDate.monthYearString)")
                .font(.title2)
                .bold()
                .padding(.bottom, 8)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(daysInMonth, id: \.self) { date in
                    VStack {
                        Text("\(Calendar.current.component(.day, from: date))")
                            .foregroundColor(isSameDay(date, as: selectedDate) ? .blue : .primary)
                            .onTapGesture {
                                selectedDate = date
                            }
                        
                        // Dot indicator if the day has an event
                        if daysWithEvents.contains(date) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 5, height: 5)
                                .padding(.top, 2)
                        }
                    }
                }
            }
        }
    }
    
    private func isSameDay(_ date1: Date, as date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

// Helper Extension for Month and Year String
extension Date {
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
}

struct UpcomingEventView: View {
    var event: Event

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.headline)
                .padding(.bottom, 2)
            Text(event.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("\(event.date, formatter: DateFormatter.eventDate)")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

extension DateFormatter {
    static let eventDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

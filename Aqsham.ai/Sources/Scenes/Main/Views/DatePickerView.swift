import SwiftUI

struct DatePickerView: View {
    
    @Binding var selectedDate: Date
    
    @State private var selectedDay: Int
    @State private var selectedMonth: Int
    @State private var selectedYear: Int

    private var months: [String] {
        var cal = Calendar.current
        cal.locale = Locale(identifier: LanguageManager.shared.language.rawValue)
        return cal.monthSymbols
    }
    
    private let years = Array(2000...Calendar.current.component(.year, from: Date()))
    
    private var daysInMonth: [Int] {
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        
        let calendar = Calendar.current
        if let date = calendar.date(from: components),
           let range = calendar.range(of: .day, in: .month, for: date) {
            return Array(range)
        } else {
            return Array(1...31)
        }
    }
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        let components = Calendar.current.dateComponents([.day, .month, .year], from: selectedDate.wrappedValue)
        _selectedDay = State(initialValue: components.day ?? 1)
        _selectedMonth = State(initialValue: components.month ?? 1)
        _selectedYear = State(initialValue: components.year ?? Calendar.current.component(.year, from: Date()))
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Picker("Month", selection: $selectedMonth) {
                ForEach(1...12, id: \.self) { index in
                    Text(months[index - 1])
                        .tag(index)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            .frame(maxWidth: .infinity)
            .pickerStyle(WheelPickerStyle())
            .onChange(of: selectedMonth) { _ in
                adjustDayIfNeeded()
                updateParentDate()
            }
            
            Picker("Day", selection: $selectedDay) {
                ForEach(daysInMonth, id: \.self) { day in
                    Text("\(day)")
                        .tag(day)
                }
            }
            .frame(maxWidth: .infinity)
            .pickerStyle(WheelPickerStyle())
            .onChange(of: selectedDay) { _ in updateParentDate() }
            
            Picker("Year", selection: $selectedYear) {
                ForEach(years, id: \.self) { year in
                    Text("\(year)")
                        .tag(year)
                }
            }
            .frame(maxWidth: .infinity)
            .pickerStyle(WheelPickerStyle())
            .onChange(of: selectedYear) { _ in
                adjustDayIfNeeded()
                updateParentDate()
            }
        }
    }
    
    private func adjustDayIfNeeded() {
        let maxDay = daysInMonth.last ?? 31
        if selectedDay > maxDay {
            selectedDay = maxDay
        }
    }
    
    private func updateParentDate() {
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        components.day = selectedDay
        if let newDate = Calendar.current.date(from: components) {
            selectedDate = newDate
        }
    }
}

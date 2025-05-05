import SwiftUI

struct ExpenseDetailsView: View {
    
    private enum Layout {
        static let secondaryColor: Color = .init(hex: "#3C3C43").opacity(0.6)
    }
    
    var item: ExpenseItem
    
    @State private var expenses: [Expense]
    
    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    init(item: ExpenseItem) {
        self.item = item
        _expenses = State(initialValue: item.expenses)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if expenses.isEmpty {
                    VStack {
                        Text("This category has no expenses")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(hex: "#939393"))
                            .kerning(-0.08)
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 10)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    VStack (spacing: 12) {
                        HStack {
                            VStack (alignment: .leading, spacing: 0) {
                                Text(AppLocalizedString("Total"))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text(totalAmount.formattedWithSpaces)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.black)
                            }
                            .padding(.leading, 30)
                            
                            Spacer()
                            
                            Text("\(Preferences.shared.selectedPeriod.startDate.formatted) - \(Date().formatted)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Layout.secondaryColor)
                                .padding(.trailing, 30)
                        }
                        
                        Spacer().frame(height: 4)
                        
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(expenses, id: \.self) { (expense: Expense) in
                                    SwipeToDeleteRow {
                                        VStack (alignment: .leading, spacing: 0) {
                                            Text(expense.date?.formatted ?? "")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.black)
                                                .padding(.horizontal, 14)
                                                .padding(.top, 10)
                                                .padding(.bottom, 8)
                                            
                                            Divider()
                                            
                                            HStack {
                                                VStack (alignment: .leading) {
                                                    Text("\(expense.amount.formattedWithSpaces) \(Preferences.shared.currency.rawValue)")
                                                        .font(.system(size: 16, weight: .regular))
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.leading)
                                                        .frame(width: 150, alignment: .leading)
                                                    
                                                    Spacer()
                                                }
                                                
                                                Spacer()
                                                    .frame(width: 8)
                                                
                                                if let comment = expense.comment {
                                                    VStack (alignment: .leading) {
                                                        Text(AppLocalizedString("Comment"))
                                                            .font(.system(size: 13, weight: .semibold))
                                                            .foregroundColor(Layout.secondaryColor)
                                                        
                                                        ZStack (alignment: .leading) {
                                                            Color(UIColor.systemGray5).cornerRadius(8)
                                                            
                                                            Text(comment)
                                                                .font(.system(size: 14, weight: .regular))
                                                                .foregroundColor(.black)
                                                                .padding(.vertical, 8)
                                                                .padding(.horizontal, 10)
                                                                .frame(alignment: .leading)
                                                                .multilineTextAlignment(.leading)
                                                        }
                                                    }
                                                } else {
                                                    Text(AppLocalizedString("No Comment"))
                                                        .font(.system(size: 18, weight: .semibold))
                                                        .foregroundColor(Layout.secondaryColor)
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 12)
                                        }
                                        .background(Color.white)
                                        .cornerRadius(12.0)
                                        .padding(.horizontal, 16)
                                    } onDelete: {
                                        withAnimation {
                                            expenses.removeAll { (storedExpense: Expense) in
                                                expense == storedExpense
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .navigationTitle(item.categoryName)
            .navigationBarTitleDisplayMode(.inline)
            .insertBackgroundColor()
        }
    }
}

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: LanguageManager.shared.language.rawValue)
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: self)
    }
}

private struct SwipeToDeleteRow<Content: View>: View {
    let content: Content
    let onDelete: () -> Void

    @State private var offsetX: CGFloat = 0
    private let deleteThreshold: CGFloat = -80

    init(@ViewBuilder content: () -> Content, onDelete: @escaping () -> Void) {
        self.content = content()
        self.onDelete = onDelete
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Color.red
            HStack {
                Spacer()
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
            }
            
            content
                .background(Color(.systemBackground))
                .offset(x: offsetX)
                .gesture(
                    DragGesture()
                        .onChanged { g in
                            // only allow left swipes
                            offsetX = min(0, g.translation.width)
                        }
                        .onEnded { g in
                            withAnimation(.easeOut) {
                                if g.translation.width < deleteThreshold {
                                    // swipe past threshold → delete
                                    offsetX = -UIScreen.main.bounds.width
                                    onDelete()
                                } else {
                                    // otherwise snap back
                                    offsetX = 0
                                }
                            }
                        }
                )
        }
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

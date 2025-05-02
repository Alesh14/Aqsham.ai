import SwiftUI

struct ExpenseDetailsView: View {
    
    private enum Layout {
        static let secondaryColor: Color = .init(hex: "#3C3C43").opacity(0.6)
    }
    
    let item: ExpenseItem
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (spacing: 12) {
                    ForEach(item.expenses, id: \.self) { (expense: Expense) in
                        VStack (alignment: .leading, spacing: 0) {
                            Text(expense.date?.formatted ?? "some day")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 14)
                                .padding(.top, 10)
                                .padding(.bottom, 8)
                            
                            Divider()
                            
                            HStack {
                                VStack (alignment: .leading) {
                                    Text(expense.amount.formattedWithSpaces)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.black)
                                        .padding(.leading, 14)
                                        .frame(width: 150, alignment: .leading)
                                    
                                    Spacer()
                                }
                                
                                Spacer()
                                    .frame(width: 8)
                                
                                if let comment = expense.comment {
                                    VStack (alignment: .leading) {
                                        Text("Comment")
                                            .font(.system(size: 18, weight: .semibold))
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
                                    Text("No comment")
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
                    }
                }
            }
            .insertBackgroundColor()
            .navigationTitle(item.categoryName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: self)
    }
}

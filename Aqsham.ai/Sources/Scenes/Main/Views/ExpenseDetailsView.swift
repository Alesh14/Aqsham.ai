import SwiftUI

struct ExpenseDetailsView: View {
    
    let item: ExpenseItem
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(item.expenses, id: \.self) { expense in
                        VStack (alignment: .leading, spacing: 0) {
                            Text(expense.date?.formatted ?? "some day")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 14)
                                .padding(.top, 10)
                                .padding(.bottom, 8)
                            
                            Divider()
                            
                            HStack {
                                Text(expense.amount.formattedWithSpaces)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.black)
                                    .padding(.leading, 14)

                                Spacer()

                                if let comment = expense.comment {
                                    VStack (alignment: .leading) {
                                        Text("Comment")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.secondaryColor)
                                    
                                        Text(comment)
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                } else {
                                    Text("No comment")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.secondaryColor)
                                }
                            }
                        }
                        .background(Color.white)
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
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}

import SwiftUI

struct AddExpenseView: View {
    
    private enum Layout {
        static let backgroundColor = Color.white
    }
    
    let viewModel: AddExpenseViewModel
    
    @State private var amount: String = ""
    @State private var comment: String = ""
    @State private var categoryModel: CategoryModel?
    @State private var selectedDate = Date()
    
    @State private var amountMessage = ""
    @State private var categoryMessage = ""
    
    var body: some View {
        VStack (spacing: 0) {
            DatePickerView(selectedDate: $selectedDate)
                .background(Color.white)
                .cornerRadius(13)
                .onChange(of: selectedDate) { _ in
                    hideKeyboardIfNeeded()
                }
            
            Spacer().frame(height: 16)
            
            VStack (spacing: 0) {
                HStack {
                    Text("Amount")
                        .font(.system(size: 17, weight: .regular))
                    
                    if !amountMessage.isEmpty {
                        Text(amountMessage)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color.red)
                            .frame(maxWidth: .infinity)
                            .lineLimit(1)
                    } else {
                        Spacer()
                    }
                    
                    TextField("0", text: $amount, onEditingChanged: { isEditing in
                        if isEditing {
                            amountMessage = ""
                        }
                    })
                    .font(.system(size: 17, weight: .regular))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .onChange(of: amount) { value in
                        let filtered = value.filter { "0123456789".contains($0) }
                        let limited = String(filtered.prefix(7))
                        if limited != value {
                            amount = limited
                        }
                    }
                }
                .padding(.vertical, 11)
                .padding(.horizontal, 16)
                
                Divider()
                    .padding(.leading, 16)
                
                Button {
                    didTapCategory()
                } label: {
                    HStack {
                        Text("Category")
                            .font(.system(size: 17, weight: .regular))
                        
                        Spacer()
                            .contentShape(Rectangle())
                        
                        if !categoryMessage.isEmpty {
                            Text(categoryMessage)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(Color.red)
                        } else {
                            if let categoryModel {
                                Text(categoryModel.name)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.black)
                            } else {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 17))
                                    .foregroundColor(Color(hex: "#3C3C43").opacity(0.3))
                            }
                        }
                    }
                    .padding(.vertical, 11)
                    .padding(.horizontal, 16)
                    .contentShape(Rectangle())
                    .background(Color.clear)
                }
                .buttonStyle(.plain)
                
                Divider()
                
                HStack {
                    Text("Comment")
                        .font(.system(size: 17, weight: .regular))
                    
                    TextField("Optional", text: $comment)
                        .font(.system(size: 17, weight: .regular))
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.default)
                }
                .padding(.vertical, 11)
                .padding(.horizontal, 16)
            }
            .background(Color.white)
            .cornerRadius(16)
            
            Spacer()
        }
        .padding(.horizontal, 22)
        .insertBackgroundColor()
        .navigationTitle("Add Expense")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    didTapAdd()
                } label: {
                    Text("Add")
                        .foregroundColor(.blue)
                        .font(.system(size: 17, weight: .semibold))
                }
                .disabled(selectedDate > Date() || amount.isEmpty || categoryModel == nil)
                .opacity(selectedDate > Date() || amount.isEmpty || categoryModel == nil ? 0.5 : 1)
            }
        }
    }
    
    private func didTapAdd() {
        hideKeyboardIfNeeded()

        guard let categoryModel else {
            categoryMessage = "Select category"
            return
        }
        
        guard let amoutValue = Double(amount), amoutValue > 0 else {
            amountMessage = "Enter valid amount"
            return
        }
        
        if comment.isEmpty {
            viewModel.addExpense(amount: amoutValue, date: selectedDate, categoryID: categoryModel.id, comment: nil)
        } else {
            viewModel.addExpense(amount: amoutValue, date: selectedDate, categoryID: categoryModel.id, comment: comment)
        }
        viewModel.navigate(to: .dismiss)
    }
    
    private func didTapCategory() {
        categoryMessage = ""
        viewModel.navigate(to: .pickCategory(categoryModel, { category in
            self.categoryModel = category
        }))
    }
    
    private func hideKeyboardIfNeeded() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

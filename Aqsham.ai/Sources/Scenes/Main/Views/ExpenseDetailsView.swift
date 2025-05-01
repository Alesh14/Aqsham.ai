import SwiftUI

struct ExpenseDetailsView: View {
    
    let item: ExpenseItem
    
    var body: some View {
        VStack {
            
        }
        .frame(height: 500)
        .navigationTitle(item.categoryName)
    }
}

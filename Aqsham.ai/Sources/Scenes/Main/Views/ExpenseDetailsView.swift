import SwiftUI

struct ExpenseDetailsView: View {
    
    let item: ExpenseItem
    
    var body: some View {
        VStack {
            
        }
        .insertBackgroundColor()
        .navigationTitle(item.categoryName)
    }
}

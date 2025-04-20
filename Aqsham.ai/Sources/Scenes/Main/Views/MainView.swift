import SwiftUI

struct MainView: View {
    
    private enum Layout {
        static let secondaryColor: Color = .init(hex: "#3C3C43").opacity(0.6)
    }
    
    var onTapAddExpense: (() -> Void)?
    var onTapTalkToAgent: (() -> Void)?
    var onTapHistory: (() -> Void)?
    
    @ObservedObject private var preferences = Preferences.shared
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            VStack (alignment: .leading, spacing: 0) {                
                VStack (spacing: 0) {
                    ExpenseView(
                        onTapAddExpense: onTapAddExpense,
                        onTapTalkToAgent: onTapTalkToAgent,
                        onTapHistory: onTapHistory
                    )
                }
                .padding(.bottom, 16)
                
                buildSectionTitle("Analytics".uppercased())
                    .padding(.leading, 16)
                    .padding(.bottom, 6)
                
                AnalyticsView(onTapAddExpense: onTapAddExpense)
                
                // TODO: VISUALIZATION
            }
        }
        .insertBackgroundColor()
        .cornerRadius(16)
    }
    
    private func buildSectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Layout.secondaryColor)
    }
}

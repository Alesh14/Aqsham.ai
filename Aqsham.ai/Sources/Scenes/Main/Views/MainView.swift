import SwiftUI
import Combine

struct MainView: View {
    
    private enum Layout {
        static let secondaryColor: Color = .init(hex: "#3C3C43").opacity(0.6)
    }
    
    var onTapAddExpense: (() -> Void)?
    var onTapTalkToAgent: (() -> Void)?
    var onTapHistory: (() -> Void)?
    
    var onTapOpenExpenseDetails: ((ExpenseItem) -> Void)?
    
    var onAppearPublisher: AnyPublisher<Void, Never>?
    
    @ObservedObject private var preferences = Preferences.shared
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            VStack (alignment: .leading, spacing: 0) {                
                VStack (spacing: 0) {
                    ExpenseView(
                        onTapAddExpense: onTapAddExpense,
                        onTapTalkToAgent: onTapTalkToAgent,
                        onTapHistory: onTapHistory,
                        onAppearPublisher: onAppearPublisher
                    )
                }
                .padding(.bottom, 16)
                
                buildSectionTitle(AppLocalizedString("Analytics").uppercased())
                    .padding(.leading, 16)
                    .padding(.bottom, 6)
                
                AnalyticsView(onTapAddExpense: onTapAddExpense, onAppearPublisher: onAppearPublisher, onTapOpenExpenseDetails: onTapOpenExpenseDetails)
                    .padding(.bottom, 16)
                
                buildSectionTitle(AppLocalizedString("Visualization").uppercased())
                    .padding(.leading, 16)
                    .padding(.bottom, 6)
                
                VisualizationView(onAppearPublisher: onAppearPublisher)
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

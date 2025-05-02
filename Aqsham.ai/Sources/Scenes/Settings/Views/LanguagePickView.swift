import SwiftUI

struct LanguagePickView: View {
    
    var body: some View {
        VStack (spacing: 0) {
            button(for: .kazakh)
            button(for: .russian)
            button(for: .english)
        }
    }
    
    private func button(for language: Lanugage) -> some View {
        VStack {}
    }
}

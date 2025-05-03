import SwiftUI

struct LanguagePickView: View {
    
    @State private var selectedLanguage: Lanugage {
        didSet {
            Preferences.shared.language = selectedLanguage
        }
    }
    
    init() {
        self.selectedLanguage = Preferences.shared.language
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(Lanugage.allCases, id: \.self) { lang in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(lang.title)
                                    .foregroundColor(.primary)
                                Text(lang.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if selectedLanguage == lang {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedLanguage = lang
                        }
                    }
                }
            }
            .padding(.top, -25)
            .listStyle(.insetGrouped)
            .navigationTitle("Language")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

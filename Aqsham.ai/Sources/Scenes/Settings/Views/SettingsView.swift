import SwiftUI

struct SettingsView: View {
    
    var onTap: ((SettingsSectionsView.Section) -> Void)
    
    var body: some View {
        ScrollView {
            VStack (spacing: 0) {
                ProfileView()
                
                Spacer().frame(height: 20)
                
                SettingsSectionsView(onTap: onTap)
            }
        }
    }
}

struct SettingsSectionsView: View {
    
    enum Section {
        case editCategories
        case notifications
        case currency
        case language
        case help
        
        var title: String {
            switch self {
            case .editCategories: return "Edit Categories"
            case .notifications: return "Notifications"
            case .currency: return "Currency"
            case .language: return "Language"
            case .help: return "Help"
            }
        }
        
        var iconName: String {
            switch self {
            case .editCategories: return "slider.horizontal.3"
            case .notifications: return "speaker.wave.2.fill"
            case .currency: return "bitcoinsign.circle"
            case .language: return "globe"
            case .help: return "questionmark.circle"
            }
        }
        
        var bgColor: Color {
            switch self {
            case .editCategories: return .blue
            case .notifications: return .red
            case .currency: return .gray
            case .language: return .purple
            case .help: return .orange
            }
        }
    }
    
    @ObservedObject private var preferences = Preferences.shared
    
    var onTap: ((Section) -> Void)
    
    var body: some View {
        VStack (spacing: 16) {
            button(for: .editCategories) {
                onTap(.editCategories)
            }
            .cornerRadius(16)
            
            VStack (spacing: 0) {
                button(for: .notifications) {
                    onTap(.notifications)
                }
                Divider()
                button(for: .currency) {
                    onTap(.currency)
                }
                Divider()
                button(for: .language) {
                    onTap(.language)
                }
            }
            .cornerRadius(16)
            
            button(for: .help) {
                onTap(.help)
            }
            .cornerRadius(16)
        }
        .padding(.horizontal, 16)
        
        Spacer().frame(height: 16)
    }
    
    private func button(for section: Section, onTap: @escaping () -> Void) -> some View {
        VStack (spacing: 0) {
            ScaleableButtonView {
                HStack (spacing: 16) {
                    Image(systemName: section.iconName)
                        .frame(width: 20, height: 16)
                        .foregroundColor(section.bgColor)
                    
                    Text(section.title)
                        .foregroundColor(section == .editCategories ? .blue : .black)
                    
                    Spacer()
                        .contentShape(Rectangle())
                    
                    if section == .currency {
                        Text(preferences.currency.rawValue)
                            .foregroundColor(Color(uiColor: .systemGray))
                    }
                    if section == .language {
                        Text(preferences.language.rawValue)
                            .foregroundColor(Color(uiColor: .systemGray))
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundColor(Color(hex: "#3C3C43").opacity(0.3))
                }
                .contentShape(Rectangle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            } onTapCompletion: {
                onTap()
            }
        }
        .background(Color.white)
    }
}

struct ProfileView: View {
    
    @ObservedObject private var preferences = Preferences.shared
    
    var ageText: String {
        if let age = preferences.age {
            return "\(age)"
        }
        return "Age didn't set"
    }
    
    var genderText: String {
        if let gender = preferences.gender {
            return gender.rawValue
        }
        return "Gender didn't set"
    }
    
    var body: some View {
        VStack (spacing: 4) {
            ZStack {
                Circle()
                    .frame(width: 85, height: 85)
                    .foregroundColor(.white)
                    .shadow(radius: 1)
                
                Text(preferences.userName.prefix(2).uppercased())
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color(uiColor: .systemGray))
            }
            
            Text(preferences.userName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            Text("\(ageText) ∙ \(genderText)")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.gray)
        }
    }
}

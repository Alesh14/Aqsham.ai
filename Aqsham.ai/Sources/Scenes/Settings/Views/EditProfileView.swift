import SwiftUI

struct EditProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedGender: Gender = Preferences.shared.gender ?? .male
    @State private var age: Int = Preferences.shared.age ?? 18
    
    private let genders: [Gender] = [.female, .male]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    HStack (spacing: 0) {
                        Spacer().frame(width: 16)
                        
                        TextField(Preferences.shared.userName ?? AppLocalizedString("Unnamed"), text: $name)
                            .padding(.vertical, 10)
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    HStack {
                        Text(AppLocalizedString("Gender"))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.black)
                            .padding(.leading, 16)
                            .padding(.vertical, 10)
                        
                        Spacer()
                        
                        Picker("", selection: $selectedGender) {
                            ForEach(genders, id: \.self) { gender in
                                Text(AppLocalizedString(gender.rawValue)).tag(gender)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    HStack {
                        Text(AppLocalizedString("Age"))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.black)
                            .padding(.leading, 16)
                            .padding(.vertical, 10)
                        
                        Spacer()
                        
                        Picker("", selection: $age) {
                            ForEach(10...80, id: \.self) { value in
                                Text("\(value)").tag(value)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
            }
            .insertBackgroundColor()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(AppLocalizedString("Save")) {
                        Preferences.shared.age = age
                        if !name.isEmpty {
                            Preferences.shared.userName = name
                        }
                        Preferences.shared.gender = selectedGender
                        dismiss()
                    }
                    .disabled(name.isEmpty && name == Preferences.shared.userName && selectedGender == Preferences.shared.gender && age == Preferences.shared.age)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(AppLocalizedString("Cancel")) {
                        dismiss()
                    }
                }
            }
        }
    }
}

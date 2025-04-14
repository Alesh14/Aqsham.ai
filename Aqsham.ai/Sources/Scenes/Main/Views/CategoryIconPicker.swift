import SwiftUI

struct CategoryIconPicker: View {
    
    let icons: [String]
    
    let onIconSelected: (String) -> Void
    
    @State private var selectedIcon: String? = nil
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(icons, id: \.self) { icon in
                        Button(action: {
                            selectedIcon = icon
                            onIconSelected(icon)
                        }) {
                            Image(systemName: icon)
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .frame(width: 35, height: 35)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.1))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Choose an icon")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

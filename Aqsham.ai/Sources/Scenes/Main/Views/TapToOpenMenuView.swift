import SwiftUI

struct TapToOpenMenuView: View {
    
    @Binding var selectedColor: UIColor
    
    let colors: [(UIColor, String)] = [
        (.systemRed, "Red"),
        (.systemGreen, "Green"),
        (.systemBlue, "Blue"),
        (.systemOrange, "Orange"),
        (.systemPurple, "Purple")
    ]
    
    var body: some View {
        ColorMenuButton(selectedColor: $selectedColor, colors: colors)
    }
}

struct ColorMenuButton: UIViewRepresentable {
    
    @Binding var selectedColor: UIColor
    let colors: [(UIColor, String)]
    
    func makeUIView(context: Context) -> UIButton {
        let button = FixedSizeButton(type: .system)
        button.clipsToBounds = true
        button.backgroundColor = selectedColor
        button.menu = createMenu(for: button)
        button.showsMenuAsPrimaryAction = true
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {}
    
    private func createMenu(for button: UIButton) -> UIMenu {
        let actions = colors.map { (color, name) in
            UIAction(
                title: name,
                image: UIImage(systemName: "circle.fill")?.withTintColor(color, renderingMode: .alwaysOriginal)
            ) { _ in
                selectedColor = color
                button.backgroundColor = color
            }
        }
        return UIMenu(title: "", options: .displayInline, children: actions)
    }
}

final class FixedSizeButton: UIButton {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 17.6, height: 17.6)
    }
}

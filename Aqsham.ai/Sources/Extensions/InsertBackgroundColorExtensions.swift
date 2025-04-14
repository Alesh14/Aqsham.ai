import UIKit
import SwiftUI

private let backgroundColor: UIColor = .init(hex: "#F2F2F7")

extension UIViewController {
    
    func insertBackgroundColor() {
        self.view.backgroundColor = backgroundColor
    }
}

extension View {
    
    func insertBackgroundColor() -> some View {
        background(Color(backgroundColor))
    }
}

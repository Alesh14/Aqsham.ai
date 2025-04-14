import UIKit

extension UIWindow {

    static var safeAreaInsets: UIEdgeInsets {
        guard let insets = UIApplication.shared.windows.first?.safeAreaInsets else {
            return .zero
        }
        return insets
    }

    static var safeTopInset: CGFloat {
        safeAreaInsets.top
    }

    static var safeBottomInset: CGFloat {
        safeAreaInsets.bottom
    }
}

import SwiftUI

public struct ScaleableButtonView<Content: View>: View {
    
    private let content: () -> Content
    private let scale: CGFloat
    private let brightness: Double
    private let threshold: CGFloat // TODO: Maybe we don't need it.
    private let onTapCompletion: (() -> Void)?

    @State private var isPressed: Bool = false

    public init(scale: CGFloat = 0.95,
                brightness: Double = 0.05,
                threshold: CGFloat = 10,
                @ViewBuilder content: @escaping () -> Content,
                onTapCompletion: (() -> Void)? = nil) {
        self.content = content
        self.scale = scale
        self.brightness = brightness
        self.threshold = threshold
        self.onTapCompletion = onTapCompletion
    }

    public var body: some View {
        content()
            .scaleEffect(isPressed ? scale : 1)
            .brightness(isPressed ? brightness : 0)
            .animation(.bouncy(duration: 0.4), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if abs(value.translation.width) < threshold && abs(value.translation.height) < threshold {
//                            if !isPressed {
//                                let generator = UISelectionFeedbackGenerator()
//                                generator.selectionChanged()
//                            }
                            isPressed = true
                        } else {
                            isPressed = false
                        }
                    }
                    .onEnded { value in
                        isPressed = false
                        if abs(value.translation.width) < threshold && abs(value.translation.height) < threshold {
                            onTapCompletion?()
                        }
                    }
            )
    }
}

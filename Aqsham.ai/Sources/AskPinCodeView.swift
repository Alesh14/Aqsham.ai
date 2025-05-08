import SwiftUI

struct AskPinCodeView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var preferences = Preferences.shared

    private let pinLength = 4
    @State private var currentPin: String = ""
    @State private var showErrorAlert = false
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()

                if let name = preferences.userName, !name.isEmpty {
                    Text("Hello, \(name)")
                        .font(.title2)
                        .bold()
                }

                Text("Enter PIN code")
                    .font(.headline)

                HStack(spacing: 16) {
                    ForEach(0..<pinLength, id: \.self) { idx in
                        Circle()
                            .strokeBorder(Color.primary, lineWidth: 1)
                            .background(
                                Circle()
                                    .fill(idx < currentPin.count ? Color.primary : Color.clear)
                            )
                            .frame(width: 20, height: 20)
                    }
                }

                SecureField("", text: $currentPin)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isTextFieldFocused)
                    .onChange(of: currentPin) { newValue in
                        let filtered = newValue.filter(\.isNumber)
                        currentPin = String(filtered.prefix(pinLength))

                        if currentPin.count == pinLength {
                            verifyPin()
                        }
                    }
                    .frame(width: 0, height: 0)
                    .opacity(0)

                Spacer()
            }
            .padding()
            .navigationTitle("Unlock")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Incorrect PIN", isPresented: $showErrorAlert) {
                Button("OK") {
                    resetEntry()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTextFieldFocused = true
                }
            }
            .preferredColorScheme(.light) 
        }
    }

    // MARK: - Verification Logic

    private func verifyPin() {
        guard let saved = preferences.pinCode else {
            presentationMode.wrappedValue.dismiss()
            return
        }

        if currentPin == saved {
            presentationMode.wrappedValue.dismiss()
        } else {
            showErrorAlert = true
        }
    }

    private func resetEntry() {
        currentPin = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isTextFieldFocused = true
        }
    }
}

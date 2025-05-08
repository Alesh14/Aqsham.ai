import SwiftUI

struct PincodeView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var preferences = Preferences.shared

    private let pinLength = 4

    enum Mode {
        case verify
        case setupFirst
        case setupRepeat
    }

    @State private var mode: Mode
    @State private var firstEntry: String = ""
    @State private var currentEntry: String = ""
    @State private var showMismatchAlert = false
    @FocusState private var isTextFieldFocused: Bool

    // MARK: - Init

    init() {
        if Preferences.shared.pinCode != nil {
            _mode = State(initialValue: .verify)
        } else {
            _mode = State(initialValue: .setupFirst)
        }
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()
                
                Text(promptText)
                    .font(.headline)
                
                HStack(spacing: 16) {
                    ForEach(0..<pinLength, id: \.self) { idx in
                        Circle()
                            .strokeBorder(Color.primary, lineWidth: 1)
                            .background(
                                Circle()
                                    .fill(idx < currentEntry.count ? Color.primary : Color.clear)
                            )
                            .frame(width: 20, height: 20)
                    }
                }

                SecureField("", text: $currentEntry)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isTextFieldFocused)
                    .onChange(of: currentEntry) { newValue in
                        let filtered = newValue.filter(\.isNumber)
                        currentEntry = String(filtered.prefix(pinLength))
                        if currentEntry.count == pinLength {
                            handleComplete(entry: currentEntry)
                        }
                    }
                    .frame(width: 0, height: 0)
                    .opacity(0)

                Spacer()
            }
            .padding()
            .navigationTitle(titleText)
            .navigationBarTitleDisplayMode(.inline)
            .alert("PINs do not match", isPresented: $showMismatchAlert) {
                Button("OK") {
                    resetAll()
                }
            }
            .toolbar(content: {
                ToolbarItem (placement: .topBarTrailing) {
                    Button("Remove PIN code") {
                        preferences.pinCode = nil
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(mode == .verify || preferences.pinCode == nil)
                }
            })
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }

    // MARK: - Computed

    private var titleText: LocalizedStringKey {
        switch mode {
        case .verify:      return "Enter PIN code"
        case .setupFirst:  return "Set PIN code"
        case .setupRepeat: return "Repeat PIN code"
        }
    }

    private var promptText: LocalizedStringKey {
        switch mode {
        case .verify:
            return "Enter current PIN code"
        case .setupFirst:
            return "Enter NEW PIN code"
        case .setupRepeat:
            return "Repeat PIN code"
        }
    }

    // MARK: - Handlers

    private func handleComplete(entry: String) {
        switch mode {
        case .verify:
            if entry == preferences.pinCode {
                mode = .setupFirst
                currentEntry = ""
            } else {
                showMismatchAlert = true
            }

        case .setupFirst:
            firstEntry = entry
            currentEntry = ""
            mode = .setupRepeat

        case .setupRepeat:
            if entry == firstEntry {
                preferences.pinCode = entry
                presentationMode.wrappedValue.dismiss()
            } else {
                showMismatchAlert = true
            }
        }
    }

    private func resetAll() {
        currentEntry = ""
        showMismatchAlert = false

        switch mode {
        case .verify:
            break
        case .setupFirst:
            break
        case .setupRepeat:
            firstEntry = ""
            mode = .setupFirst
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isTextFieldFocused = true
        }
    }
}

import SwiftUI

struct Message: Equatable, Identifiable {
    
    enum Role {
        case user
        case assistant
    }
    
    let id = UUID()
    let role: Role
    let text: String
}

struct ChatView: View {
    
    private enum Layout {
        static let textFieldCornerRadius: CGFloat = 16
    }
    
    private let viewModel = ChatViewModel()
    
    @State private var userInput: String = ""
    @State private var isKeyboardOpen: Bool = false
    @State private var messages: [Message] = []
    @State private var showPlaceholder: Bool = true
    @State private var isThinking: Bool = false
    
    private var shouldShowPlaceholder: Bool {
        !isKeyboardOpen && messages.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            if showPlaceholder {
                VStack {
                    Spacer()
                    
                    Image(.Chat.cosmicCat)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    Text(AppLocalizedString("Ask Me Something"))
                        .font(.system(size: 17, weight: .semibold))
                        .kerning(-0.43)
                    
                    Spacer()
                }
                .opacity(shouldShowPlaceholder ? 1 : 0)
                .animation(.easeInOut(duration: 0.25), value: shouldShowPlaceholder)
            } else {
                buildMessages()
            }
            
            buildTextField()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .insertBackgroundColor()
        .navigationTitle(AppLocalizedString("Chat with AI"))
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: shouldShowPlaceholder) { newValue in
            if newValue {
                showPlaceholder = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    showPlaceholder = false
                }
            }
        }
    }
    
    private func didTapSendButton() {
        hideKeyboard()
        
        let userMessage = Message(role: .user, text: userInput)
        messages.append(userMessage)
        
        userInput.erase()
        isThinking = true
        
        let thinkingMessage = Message(role: .assistant, text: "__typing__")
        messages.append(thinkingMessage)
        
        viewModel.sendChatMessage(message: userMessage.text) { result in
            isThinking = false
            
            // Remove the typing indicator
            if let index = messages.firstIndex(where: { $0.text == "__typing__" }) {
                messages.remove(at: index)
            }
            
            switch result {
            case .success(let data):
                if let choice = data.choices.first {
                    messages.append(Message(role: .assistant, text: choice.message.content))
                }
            case .failure(let error):
                print(error)
                messages.append(Message(role: .assistant, text: "Something went wrong. Please try again."))
            }
        }
    }
    
    private func buildMessages() -> some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 8) {
                    ForEach(messages) { message in
                        HStack {
                            if message.role == .assistant {
                                parseText(message.text)
                                    .padding(10)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                Spacer()
                            } else {
                                Spacer()
                                Text(message.text)
                                    .padding(10)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                        .id(message.id)
                    }
                }
                .frame(maxWidth: .infinity)
                .onAppear {
                    if let lastMessage = messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
                .onChange(of: messages) { _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
    
    private func parseText(_ input: String) -> some View {
        if input == "__typing__" {
            return AnyView(HStack(spacing: 4) {
                Text(AppLocalizedString("Assistant is typing"))
                    .font(.system(size: 15))
                    .italic()
                    .foregroundColor(.gray)
                TypingDotsView()
            })
        }
        
        var result = Text("")
        let regex = try! NSRegularExpression(pattern: "(\\*\\*\\*([^*]+)\\*\\*\\*)|(\\*\\*([^*]+)\\*\\*)", options: [])
        var lastIndex = input.startIndex
        
        for match in regex.matches(in: input, range: NSRange(input.startIndex..., in: input)) {
            let matchRange = Range(match.range, in: input)!
            let beforeText = String(input[lastIndex..<matchRange.lowerBound])
            result = result + Text(beforeText)
            
            if let tripleGroup = Range(match.range(at: 2), in: input) {
                let title = String(input[tripleGroup])
                result = result + Text(title)
                    .font(.system(size: 18, weight: .semibold))
            } else if let doubleGroup = Range(match.range(at: 4), in: input) {
                let heading = String(input[doubleGroup])
                result = result + Text(heading)
                    .font(.system(size: 15, weight: .semibold))
            }
            
            lastIndex = matchRange.upperBound
        }
        
        let trailing = String(input[lastIndex...])
        result = result + Text(trailing)
        
        return AnyView(result.font(.system(size: 15)))
    }
    
    @ViewBuilder
    private func buildTextField() -> some View {
        VStack(spacing: 0) {
            if messages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        suggestionButton(title: AppLocalizedString("Suggested-Question-1"))
                        suggestionButton(title: AppLocalizedString("Suggested-Question-2"))
                        suggestionButton(title: AppLocalizedString("Suggested-Question-3"))
                        Spacer()
                    }
                }
                .cornerRadius(16)
                .padding(.horizontal)
            }
            
            Spacer().frame(height: 8)
            
            ZStack {
                Color.white
                
                VStack(spacing: 6) {
                    HStack(spacing: 0) {
                        TextField(AppLocalizedString("Ask anything"), text: $userInput, onEditingChanged: { isEditing in
                            isKeyboardOpen = isEditing
                        })
                        .autocorrectionDisabled()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    .padding(.horizontal)
                    
                    HStack(spacing: 0) {
                        Spacer()
                        
                        Button {
                            didTapSendButton()
                        } label: {
                            ZStack {
                                (userInput.isEmpty ? Color(hex: "#787880").opacity(0.16) : Color.blue)
                                    .frame(width: 36, height: 35)
                                    .cornerRadius(18)
                                
                                Image(systemName: "arrow.up")
                                    .font(.system(size: 16, weight: .semibold))
                                    .scaledToFit()
                                    .foregroundColor(.white)
                            }
                        }
                        .disabled(userInput.isEmpty)
                    }
                    .padding(11)
                }
                .insertBackgroundColor()
                .cornerRadius(16)
                .padding(.bottom, UIWindow.safeBottomInset)
                .padding([.leading, .trailing, .top])
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    @ViewBuilder
    private func suggestionButton(title: String) -> some View {
        Button(action: {
            userInput = title
            didTapSendButton()
        }) {
            ZStack {
                Color.white
                Text(title)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .kerning(-0.23)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: 60)
            .cornerRadius(16)
        }
    }
}

private extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}

private extension String {
    mutating func erase() {
        self = ""
    }
}

struct TypingDotsView: View {
    @State private var dots = ""

    var body: some View {
        Text(dots)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                    if dots.count >= 3 {
                        dots = ""
                    } else {
                        dots += "."
                    }
                }
            }
            .font(.system(size: 15))
            .foregroundColor(.gray)
    }
}

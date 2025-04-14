struct ChatMessage: Codable {
    let role: String
    let content: String
}

struct ChatResponse: Codable {
    struct Choice: Codable {
        let message: ChatMessage
    }
    let choices: [Choice]
}

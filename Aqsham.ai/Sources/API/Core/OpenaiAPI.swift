import Moya
import Foundation

enum OpenaiAPI {
    case chat(messages: [ChatMessage])
}

extension OpenaiAPI: TargetType {
    
    var baseURL: URL {
        URL(string: "https://api.openai.com")!
    }
    
    var path: String {
        switch self {
        case .chat:
            return "/v1/chat/completions"
        }
    }
    
    var method: Moya.Method { .post }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .chat(let messages):
            let messagesPayload = messages.map { ["role": $0.role, "content": $0.content] }
            let parameters: [String: Any] = [
                "model": "ft:gpt-4o-2024-08-06:aqshamai::BKM5x9Mn",
                "messages": messagesPayload
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AppConstants.gptAPIKey!)"
        ]
    }
}

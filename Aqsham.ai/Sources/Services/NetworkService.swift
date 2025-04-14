import Moya
import Foundation

protocol Networkable {
    
    var provider: MoyaProvider<OpenaiAPI> { get }
    
    func sendChatRequest(messages: [ChatMessage], completion: @escaping (Result<ChatResponse, Error>) -> ())
}

protocol NetworkService: Networkable {}

final class NetworkServiceImpl: NetworkService {
    
    #if DEBUG
    var provider: Moya.MoyaProvider<OpenaiAPI> = MoyaProvider<OpenaiAPI>(plugins: [NetworkLoggerPlugin()])
    #else
    var provider: Moya.MoyaProvider<OpenaiAPI> = MoyaProvider<OpenaiAPI>()
    #endif
    
    func sendChatRequest(messages: [ChatMessage], completion: @escaping (Result<ChatResponse, Error>) -> ()) {
        request(target: .chat(messages: messages), completion: completion)
    }
}

private extension NetworkServiceImpl {
    
    private func request<T: Decodable>(target: OpenaiAPI, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let data = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

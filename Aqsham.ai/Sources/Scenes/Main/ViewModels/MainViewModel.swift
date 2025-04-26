import Combine

final class MainViewModel {
    
    unowned let router: MainScreenRoute
    
    var onAppearPublisher: AnyPublisher<Void, Never> {
        onAppearSubject.eraseToAnyPublisher()
    }
    
    var onAppearSubject: PassthroughSubject<Void, Never> = .init()
    
    init(router: MainScreenRoute) {
        self.router = router
    }
    
    func navigate(to screen: MainScreenSection) {
        router.trigger(screen)
    }
}

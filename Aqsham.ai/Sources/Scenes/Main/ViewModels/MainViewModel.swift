final class MainViewModel {
    
    unowned let router: MainScreenRoute
    
    init(router: MainScreenRoute) {
        self.router = router
    }
    
    func navigate(to screen: MainScreenSection) {
        router.trigger(screen)
    }
}

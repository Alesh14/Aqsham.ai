extension SharedContainer {
    
    static let networkService = Factory<NetworkService> {
        NetworkServiceImpl()
    }
}

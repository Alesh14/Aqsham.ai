extension SharedContainer {
    
    static let dataStackProvider = Factory<DataStackProvider> {
        DataStackProviderImpl()
    }
}

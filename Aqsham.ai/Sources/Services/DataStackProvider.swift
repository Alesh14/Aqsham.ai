import CoreStore

protocol DataStackProvider {
    var dataStack: DataStack { get }
}

final class DataStackProviderImpl: DataStackProvider {
    
    var dataStack = DataStack(xcodeModelName: "Test")
    
    init() {
        do {
            try dataStack.addStorageAndWait(
                SQLiteStore(fileName: "DataBase.sqlite")
            )
        } catch {
            print(error.localizedDescription)
        }
    }
}

import Foundation

public func AppLocalizedString(
    _ key: String,
    tableName: String? = nil,
    bundle: Bundle = Bundle.main,
    value: String = "",
    comment: String = ""
) -> String {
    return NSLocalizedString(key,
                             tableName: tableName,
                             bundle: bundle.localizedBundle(),
                             value: value,
                             comment: comment)
}

extension Bundle {
    func localizedBundle() -> Bundle {
        if let path = self.path(forResource: LanguageManager.shared.language.rawValue, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle
        } else if let path = self.path(forResource: LCLBaseBundle, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle
        }
        return .main
    }
}

/// bundle & tableName friendly extension
public extension String {

    /**
     Swift 2 friendly localization syntax, replaces NSLocalizedString.
     
     - parameter tableName: The receiver’s string table to search. If tableName is `nil`
     or is an empty string, the method attempts to use `Localizable.strings`.
     
     - parameter bundle: The receiver’s bundle to search. If bundle is `nil`,
     the method attempts to use main bundle.
     
     - returns: The localized string.
     */
    func localized(using tableName: String?, in bundle: Bundle?) -> String {
        let bundle: Bundle = bundle ?? .main
        if let path = bundle.path(forResource: LanguageManager.shared.language.rawValue, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        } else if let path = bundle.path(forResource: LCLBaseBundle, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        return self
    }

    /**
     Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString).
     
     - parameter arguments: arguments values for temlpate (substituted according to the user’s default locale).
     
     - parameter tableName: The receiver’s string table to search. If tableName is `nil`
     or is an empty string, the method attempts to use `Localizable.strings`.
     
     - parameter bundle: The receiver’s bundle to search. If bundle is `nil`,
     the method attempts to use main bundle.
     
     - returns: The formatted localized string with arguments.
     */
    func localizedFormat(arguments: CVarArg..., using tableName: String?, in bundle: Bundle?) -> String {
        return String(format: localized(using: tableName, in: bundle), arguments: arguments)
    }

    /**
     Swift 2 friendly plural localization syntax with a format argument.
     
     - parameter argument: Argument to determine pluralisation.
     
     - parameter tableName: The receiver’s string table to search. If tableName is `nil`
     or is an empty string, the method attempts to use `Localizable.strings`.
     
     - parameter bundle: The receiver’s bundle to search. If bundle is `nil`,
     the method attempts to use main bundle.
     
     - returns: Pluralized localized string.
     */
    func localizedPlural(argument: CVarArg, using tableName: String?, in bundle: Bundle?) -> String {
        return NSString.localizedStringWithFormat(localized(using: tableName, in: bundle) as NSString, argument) as String
    }
}

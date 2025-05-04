import SwiftUI

struct CurrencyPickView: View {
    
    @State private var selectedCurrency: Currency {
        didSet {
            Preferences.shared.currency = selectedCurrency
        }
    }
    
    init() {
        self.selectedCurrency = Preferences.shared.currency
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(Currency.allCases, id: \.self) { currency in
                        HStack {
                            currency.flagImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(currency.title)
                                    .font(.body)
                                Text(currency.code)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 10)
                            
                            Spacer()
                            
                            if selectedCurrency == currency {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCurrency = currency
                        }
                    }
                }
            }
            .padding(.top, -25)
            .listStyle(.insetGrouped)
            .navigationTitle(AppLocalizedString("Currency"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

import SwiftUI

final class EditCategoryViewModel: ObservableObject {
    
    @Injected(Container.categoryStorageService) private var storageService
    
    @Published var categories: [CategoryModel] = []
    
    init() {
        fetchCategories()
    }
    
    func didRemove(categoryID: UUID) {
        storageService.removeCategory(id: categoryID)
        fetchCategories()
    }
    
    private func fetchCategories() {
        let res = storageService.categories.compactMap { category in
            let id = category.id!
            let hex = category.hex!
            let name = category.name!
            let icon = category.icon!
            return CategoryModel(id: id, name: name, icon: icon, color: Color(hex: hex))
        }
        if res != self.categories {
            categories = res
        }
    }
}

struct EditCategoryView: View {
    
    @ObservedObject var viewModel: EditCategoryViewModel = EditCategoryViewModel()
    
    var onCategorySelected: ((CategoryModel) -> Void)?
    
    var body: some View {
        if viewModel.categories.isEmpty {
            NavigationView {
                VStack {
                    Text(AppLocalizedString("You have no any category!"))
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(hex: "#939393"))
                        .kerning(-0.08)
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 10)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .navigationTitle(AppLocalizedString("Edit Categories"))
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            NavigationView {
                ScrollView {
                    VStack (spacing: 0) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            SwipeToDeleteRow(cornerRadius: 0) {
                                VStack {
                                    HStack {
                                        Text(category.name)
                                            .font(.system(size: 17, weight: .regular))
                                        
                                        Spacer()
                                            .contentShape(Rectangle())
                                    }
                                    .contentShape(Rectangle())
                                    .padding(.vertical, 11)
                                    .padding(.horizontal, 16)
                                    
                                    if category != viewModel.categories.last! {
                                        Divider()
                                            .padding(.leading, 16)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                            } onDelete: {
                                viewModel.didRemove(categoryID: category.id)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding(.horizontal, 22)
                .navigationTitle(AppLocalizedString("Edit Categories"))
                .navigationBarTitleDisplayMode(.inline)
                .insertBackgroundColor()
            }
        }
    }
}

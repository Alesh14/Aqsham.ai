import SwiftUI

struct CategoryView: View {
    
    @ObservedObject var viewModel: CategoryViewModel
    
    var onCategorySelected: ((CategoryModel) -> Void)?
    
    var body: some View {
        ScrollView {
            VStack {
                VStack (spacing: 0) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        HStack {
                            Text(category.name)
                                .font(.system(size: 17, weight: .regular))
                            
                            Spacer()
                                .contentShape(Rectangle())
                            
                            if viewModel.selectedCategory == category {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .padding(.vertical, 11)
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            viewModel.selectedCategory = category
                        }
                        
                        Divider()
                            .padding(.leading, 16)
                    }
                    
                    Button {
                        didTapAddNewCategory()
                    } label: {
                        HStack {
                            Text("Add New Category")
                                .font(.system(size: 17, weight: .regular))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 17))
                                .foregroundColor(Color(hex: "#3C3C43").opacity(0.3))
                        }
                        .padding(.vertical, 11)
                        .padding(.horizontal, 16)
                    }
                }
                .background(Color.white)
                .cornerRadius(16)
                
                Spacer()
            }
            .padding(.horizontal, 22)
        }
        .insertBackgroundColor()
        .onAppear {
            viewModel.updateCategoriesIfNeeded()
        }
        .onChange(of: viewModel.selectedCategory) { newValue in
            guard let category = viewModel.selectedCategory else {
                return
            }
            onCategorySelected?(category)
        }
    }
    
    private func didTapAddNewCategory() {
        viewModel.navigate(to: .addCategory)
    }
}

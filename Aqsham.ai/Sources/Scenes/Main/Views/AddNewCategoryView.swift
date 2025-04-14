import SwiftUI

struct AddNewCategoryView: View {
    
    @State private var title: String = ""
    @State private var titleMessage: String = ""
    
    @State private var selectedColor: UIColor = .systemBlue
    
    @State private var iconText: String = "Choose"
    @State private var iconString: String?
    
    @State private var isPickerPresented: Bool = false
    
    let viewModel: AddNewCategoryViewModel
    
    var body: some View {
        VStack {
            VStack (spacing: 0) {
                HStack {
                    Text("Title")
                        .font(.system(size: 17, weight: .regular))
                    
                    textField()
                }
                .padding(.vertical, 11)
                .padding(.horizontal, 16)
                
                Divider()
                    .padding(.leading, 16)
                
                HStack {
                    Text("Color")
                        .font(.system(size: 17, weight: .regular))
                    
                    Spacer()
                    
                    circlePicker()
                }
                .padding(.vertical, 11)
                .padding(.horizontal, 16)
                
                Divider()
                    .padding(.leading, 16)
                
                HStack {
                    Text("Icon")
                        .font(.system(size: 17, weight: .regular))
                    
                    Spacer()
                    
                    HStack {
                        if let iconString {
                            Image(systemName: iconString)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 17.6)
                        }
                        Text(iconText)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.blue)
                            .onTapGesture {
                                isPickerPresented = true
                            }
                    }
                }
                .padding(.vertical, 11)
                .padding(.horizontal, 16)
            }
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal, 22)
            .sheet(isPresented: $isPickerPresented) {
                CategoryIconPicker(icons: viewModel.spendingCategoryIcons) { icon in
                    self.iconString = icon
                    self.isPickerPresented = false
                    self.iconText = "Edit"
                }
            }
            
            Spacer()
        }
        .insertBackgroundColor()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    didTapAddNewCategory()
                } label: {
                    Text("Add category")
                        .foregroundColor(.blue)
                        .font(.system(size: 17, weight: .medium))
                }
            }
        }
    }
    
    private func didTapAddNewCategory() {
        var shouldReturn: Bool = false
        if title.isEmpty {
            titleMessage = "Fill Title"
            shouldReturn = true
        }
        if iconString == nil {
            shouldReturn = true
        }
        if shouldReturn {
            return
        }
        if viewModel.checkCategoryExists(title: title) {
            titleMessage = "Category already exists"
            title = ""
            return
        }
        
        viewModel.addCategory(title: title, icon: iconString!, color: selectedColor)
        viewModel.navigateBack()
    }
    
    @ViewBuilder
    private func textField() -> some View {
        if !titleMessage.isEmpty {
            Text(titleMessage)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(Color.red)
                .frame(maxWidth: .infinity)
                .lineLimit(1)
        } else {
            Spacer()
        }
        
        TextField("Ex. Food", text: $title, onEditingChanged: { isEditing in
            if isEditing {
                titleMessage = ""
            }
        })
        .font(.system(size: 17, weight: .regular))
        .multilineTextAlignment(.trailing)
        .keyboardType(.default)
        .onChange(of: title) { value in
            
        }
    }
    
    @ViewBuilder
    private func circlePicker() -> some View {
        TapToOpenMenuView(selectedColor: $selectedColor)
            .frame(width: 17.6, height: 17.6)
            .cornerRadius(17.6 / 2)
    }
}

import UIKit
import SwiftUI

final class SettingsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    private func configUI() {
        let vc = UIHostingController(rootView: SettingsView())
        vc.insertBackgroundColor()
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        vc.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

struct SettingsView: View {
    
    var body: some View {
        ScrollView {
            VStack {
                ProfileView()
            }
        }
    }
}

struct ProfileView: View {
    
    @ObservedObject private var preferences = Preferences.shared
    
    var ageText: String {
        if let age = preferences.age {
            return "\(age)"
        }
        return "Age didn't set"
    }
    
    var genderText: String {
        if let gender = preferences.gender {
            return gender.rawValue
        }
        return "Gender didn't set"
    }
    
    var body: some View {
        VStack (spacing: 4) {
            ZStack {
                Circle()
                    .frame(width: 90, height: 90)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                Text(preferences.userName.prefix(2).uppercased())
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color(uiColor: .systemGray))
            }
            
            Text(preferences.userName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            Text("\(ageText) ∙ \(genderText)")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.gray)
        }
    }
}

import UIKit
import Foundation

final class AddNewCategoryViewModel {
    
    @Injected(Container.categoryStorageService) private var categoryService
    
    unowned let router: AddExpenseScreenRoute
    
    let spendingCategoryIcons = [
        "cart.fill",                        // Shopping/Groceries
        "creditcard.fill",                  // Payments
        "bag.fill",                         // Retail
        "dollarsign.circle.fill",           // Finance
        "house.fill",                       // Housing
        "car.fill",                         // Car/Transportation
        "bus.fill",                         // Public Transport
        "bicycle",                          // Bicycling
        "tram.fill",                        // Rail/Tram
        "airplane",                         // Travel/Airfare
        "bed.double.fill",                  // Accommodation
        "fork.knife",                       // Dining
        "takeoutbag.and.cup.and.straw.fill",  // Takeout/Delivery
        "cup.and.saucer.fill",              // Café/Restaurant
        "leaf.fill",                        // Organic/Groceries
        "gamecontroller.fill",              // Entertainment (Gaming)
        "film.fill",                        // Movies
        "ticket.fill",                      // Events/Entertainment
        "music.note",                       // Music
        "mic.fill",                         // Concerts/Performances
        "book.fill",                        // Education/Books
        "graduationcap.fill",               // Education
        "briefcase.fill",                   // Work/Business
        "hammer.fill",                      // Maintenance/Repairs
        "wrench.fill",                      // Repairs/Services
        "paintbrush.fill",                  // Art/Hobbies
        "scissors",                         // Personal Care/Services
        "heart.fill",                       // Healthcare
        "stethoscope",                      // Medical
        "bandage.fill",                     // Healthcare/Pharmacy
        "flame.fill",                       // Utilities/Heating
        "lightbulb.fill",                   // Utilities/Electricity
        "drop.fill",                        // Water/Utilities
        "antenna.radiowaves.left.and.right", // Communications
        "wifi",                             // Internet/Telecom
        "desktopcomputer",                  // Technology/Computers
        "keyboard",                         // Office/Tech
        "printer.fill",                     // Office Equipment
        "folder.fill",                      // Office Supplies
        "chart.bar.fill",                   // Investments/Finance
        "clock.fill",                       // Time/Subscriptions
        "calendar",                         // Scheduling/Events
        "globe",                            // Foreign/Travel
        "building.2.fill",                  // Rentals/Property
        "cloud.fill",                       // Cloud/Utilities
        "shippingbox.fill",                 // Delivery/Shipping
        "gift.fill",                        // Gifts
        "lock.fill",                        // Insurance/Security
        "paintpalette.fill",                // Creative Arts
        "cube.box.fill"                     // Packaging/Logistics
    ]
    
    init(router: AddExpenseScreenRoute) {
        self.router = router
    }
    
    func navigateBack() {
        router.trigger(.goBack)
    }
    
    func checkCategoryExists(title: String) -> Bool {
        for category in categoryService.categories {
            if category.name == title {
                return true
            }
        }
        return false
    }
    
    func addCategory(title: String, icon: String, color: UIColor) {
        categoryService.addCategory(name: title, icon: icon, hex: hexStringFromColor(color: color))
    }
    
    private func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        let hexString = String.init(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
        return hexString
     }
}

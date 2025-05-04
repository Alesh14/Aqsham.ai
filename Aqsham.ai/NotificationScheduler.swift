import SwiftUI
import UserNotifications

// MARK: – Notification Models

/// Encapsulates content for a single notification.
struct NotificationContent {
    let identifier: String
    let title: String
    let body: String
    let sound: UNNotificationSound
}

/// A simple time-of-day struct for calendar triggers.
struct DailyTime {
    let hour: Int
    let minute: Int
}

// MARK: – Scheduler Protocol

/// Defines the interface for any notification scheduler.
protocol NotificationScheduling {
    /// Ask the user for permission to show alerts, sounds, badges.
    func requestAuthorization(completion: ((Bool) -> Void)?)
    
    /// Schedule a notification at the given daily time, optionally repeating.
    func schedule(
        content: NotificationContent,
        at time: DailyTime,
        repeats: Bool
    )
    
    /// Cancel any pending notification with this identifier.
    func cancel(identifier: String)
}

// MARK: – Concrete Scheduler

/// A concrete scheduler backed by UNUserNotificationCenter.
final class NotificationScheduler: NSObject, NotificationScheduling {
    static let shared = NotificationScheduler()
    private let center = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        center.delegate = self
    }
    
    func requestAuthorization(completion: ((Bool) -> Void)? = nil) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion?(granted)
            }
        }
    }
    
    func scheduleReminder() {
        requestAuthorization { [weak self] granted in
            guard granted else {
                print("🚫 Notifications not allowed")
                return
            }
            
            let content = NotificationContent(
                identifier: AppConstants.notificationIdentifier,
                title: AppLocalizedString("Reminder"),
                body: AppLocalizedString("Do not forget to track your spendings today!"),
                sound: .default
            )
            
            self?.schedule(content: content, at: DailyTime(hour: 20, minute: 0))
        }
    }
    
    func schedule(
        content: NotificationContent,
        at time: DailyTime,
        repeats: Bool = true
    ) {
        cancel(identifier: content.identifier)
        
        let payload = UNMutableNotificationContent()
        payload.title = content.title
        payload.body  = content.body
        payload.sound = content.sound
        
        var components = DateComponents()
        components.hour   = time.hour
        components.minute = time.minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        
        let request = UNNotificationRequest(
            identifier: content.identifier,
            content: payload,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let err = error {
                print("⚠️ Notification scheduling failed:", err)
            }
        }
    }
    
    func cancel(identifier: String) {
        center.removePendingNotificationRequests(
            withIdentifiers: [identifier]
        )
    }
}

// MARK: – Foreground Banner Support

extension NotificationScheduler: UNUserNotificationCenterDelegate {
    /// Show banner+sound even when app is foregrounded.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler handler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        handler([.banner, .sound])
    }
}

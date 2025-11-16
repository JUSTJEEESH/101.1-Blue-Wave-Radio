//
//  NotificationManager.swift
//  Blue Wave Radio Roatan
//
//  Service for managing local notifications
//

import Foundation
import UserNotifications
import Observation

@Observable
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    var isAuthorized = false

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        checkAuthorizationStatus()
    }

    // MARK: - Authorization

    func requestAuthorization() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run {
                self.isAuthorized = granted
            }

            if granted {
                await scheduleShowNotifications()
            }
        } catch {
            print("Error requesting notification authorization: \(error)")
        }
    }

    private func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            Task { @MainActor in
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }

    // MARK: - Schedule Notifications

    func scheduleShowNotifications() async {
        guard isAuthorized else { return }

        // Remove all pending notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        // Schedule notifications for radio shows
        for show in RadioShow.schedule {
            await scheduleNotification(for: show)
        }
    }

    private func scheduleNotification(for show: RadioShow) async {
        let content = UNMutableNotificationContent()
        content.title = show.name
        content.body = "Starting now on 101.1 Blue Wave Radio!"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "RADIO_SHOW"

        // Parse the start time
        if let triggerDate = parseShowTime(show.startTime, dayOfWeek: show.dayOfWeek) {
            let components = Calendar.current.dateComponents([.weekday, .hour, .minute], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

            let request = UNNotificationRequest(
                identifier: show.id.uuidString,
                content: content,
                trigger: trigger
            )

            do {
                try await UNUserNotificationCenter.current().add(request)
            } catch {
                print("Error scheduling notification for \(show.name): \(error)")
            }
        }
    }

    func scheduleEventReminder(for event: MusicEvent, minutesBefore: Int = 60) async {
        guard isAuthorized else { return }

        let content = UNMutableNotificationContent()
        content.title = "Upcoming Event"
        content.body = "\(event.title) at \(event.venue) starts in \(minutesBefore) minutes!"
        content.sound = .default
        content.categoryIdentifier = "EVENT_REMINDER"

        let reminderDate = event.dateTime.addingTimeInterval(-Double(minutesBefore * 60))
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: "event-\(event.id.uuidString)",
            content: content,
            trigger: trigger
        )

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Error scheduling event reminder: \(error)")
        }
    }

    // MARK: - Helper Methods

    private func parseShowTime(_ timeString: String, dayOfWeek: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        guard let time = formatter.date(from: timeString) else { return nil }

        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute], from: time)

        // Map day of week to weekday number
        if dayOfWeek.contains("Monday") {
            components.weekday = 2
        } else if dayOfWeek.contains("Tuesday") {
            components.weekday = 3
        } else if dayOfWeek.contains("Wednesday") {
            components.weekday = 4
        } else if dayOfWeek.contains("Thursday") {
            components.weekday = 5
        } else if dayOfWeek.contains("Friday") {
            components.weekday = 6
        } else if dayOfWeek.contains("Saturday") {
            components.weekday = 7
        } else if dayOfWeek.contains("Sunday") {
            components.weekday = 1
        } else {
            // Daily - use Monday as default for repeating
            components.weekday = 2
        }

        return calendar.date(from: components)
    }

    // MARK: - UNUserNotificationCenterDelegate

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound, .badge]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        // Handle notification tap - could navigate to specific tab
        let categoryIdentifier = response.notification.request.content.categoryIdentifier

        if categoryIdentifier == "RADIO_SHOW" {
            // Navigate to streaming tab
            NotificationCenter.default.post(name: .init("NavigateToStreaming"), object: nil)
        } else if categoryIdentifier == "EVENT_REMINDER" {
            // Navigate to music scene tab
            NotificationCenter.default.post(name: .init("NavigateToMusicScene"), object: nil)
        }
    }
}

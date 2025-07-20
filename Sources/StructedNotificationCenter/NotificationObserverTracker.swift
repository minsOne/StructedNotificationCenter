//
//  NotificationObserverTracker.swift
//  StructedNotificationCenter
//
//  Created by 안정민 on 7/20/25.
//

import Foundation

/// Singleton class to track and manage notification subscribers
/// Ensures thread-safe operations and prevents memory leaks by tracking active subscriptions
public class NotificationObserverTracker {
    public static let shared = NotificationObserverTracker()

    /// Stores sets of subscriber UUIDs for each notification name
    private var dict: [Notification.Name: Set<UUID>] = [:]
    private let lock = NSLock()

    /// Removes a specific subscription for a given notification name
    /// - Parameters:
    ///   - uuid: Unique identifier of the subscriber to remove
    ///   - name: Notification name associated with the subscription
    func removeSubscription(id uuid: UUID, for name: Notification.Name) {
        lock.lock()
        defer { lock.unlock() }

        guard var set = dict[name] else { return }

        set.remove(uuid)
        // Remove the notification name if no subscribers remain
        if set.isEmpty {
            dict.removeValue(forKey: name)
        } else {
            dict[name] = set
        }
    }

    /// Adds a new subscription for a given notification name
    /// - Parameters:
    ///   - uuid: Unique identifier of the subscriber to add
    ///   - name: Notification name associated with the subscription
    func addSubscription(id uuid: UUID, for name: Notification.Name) {
        lock.lock()
        defer { lock.unlock() }

        if var set = dict[name] {
            set.insert(uuid)
            dict[name] = set
        } else {
            dict[name] = [uuid]
        }
    }

    /// Checks if there are active subscriptions for a specific notification name
    /// - Parameter name: Notification name to check
    /// - Returns: `true` if there are active subscriptions, otherwise `false`
    public func hasActiveSubscription(for name: Notification.Name) -> Bool {
        dict[name]?.isEmpty == false
    }
}

//
//  NotificationObserverTracker.swift
//  StructedNotificationCenter
//
//  Created by 안정민 on 7/20/25.
//

import Foundation

/// Singleton class to track and manage notification subscribers
/// Used to prevent memory leaks and check for active subscriptions
public class NotificationObserverTracker {
    public static let shared = NotificationObserverTracker()

    /// Dictionary storing sets of subscriber UUIDs for each notification name
    var dict: [Notification.Name: Set<UUID>] = [:]
    let lock = NSLock()

    /// Method to remove a specific subscription
    /// - Parameters:
    ///   - uuid: Unique identifier of the subscriber to remove
    ///   - name: Notification name
    func removeSubscription(id uuid: UUID, for name: Notification.Name) {
        lock.lock()
        defer { lock.unlock() }

        guard var set = dict[name] else { return }

        set.remove(uuid)
        // If all subscribers are removed, delete the key from the dictionary
        if set.isEmpty { dict.removeValue(forKey: name) }
        else { dict[name] = set }
    }

    /// Method to add a new subscription
    /// - Parameters:
    ///   - uuid: Unique identifier of the subscriber to add
    ///   - name: Notification name
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

    /// Check if there are active subscriptions for a specific notification
    /// - Parameter name: Notification name to check
    /// - Returns: Whether there are active subscriptions
    public func hasActiveSubscription(for name: Notification.Name) -> Bool {
        dict[name]?.isEmpty == false
    }
}

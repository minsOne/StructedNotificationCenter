import Foundation
import Testing

@testable import StructedNotificationCenter

@Suite(.serialized)
struct NotificationObserverTrackerTests {
    let tracker = NotificationObserverTracker()
    
    @Test
    func testAddSubscription() {
        let notificationName = Notification.Name("TestNotification")
        let uuid = UUID()

        tracker.addSubscription(id: uuid, for: notificationName)

        #expect(tracker.hasActiveSubscription(for: notificationName))
    }
    
    @Test
    func testRemoveSubscription() {
        let notificationName = Notification.Name("TestNotification")
        let uuid = UUID()

        tracker.addSubscription(id: uuid, for: notificationName)
        tracker.removeSubscription(id: uuid, for: notificationName)

        #expect(tracker.hasActiveSubscription(for: notificationName) == false)
    }
 
    @Test
    func testHasActiveSubscription() {
        let notificationName = Notification.Name("TestNotification")
        let uuid = UUID()

        #expect(tracker.hasActiveSubscription(for: notificationName) == false)

        tracker.addSubscription(id: uuid, for: notificationName)

        #expect(tracker.hasActiveSubscription(for: notificationName))
    }

    @Test
    func testMultipleSubscriptions() {
        let tracker = NotificationObserverTracker.shared
        let notificationName = Notification.Name("TestNotification")
        let uuid1 = UUID()
        let uuid2 = UUID()

        tracker.addSubscription(id: uuid1, for: notificationName)
        tracker.addSubscription(id: uuid2, for: notificationName)

        #expect(tracker.hasActiveSubscription(for: notificationName))

        tracker.removeSubscription(id: uuid1, for: notificationName)
        #expect(tracker.hasActiveSubscription(for: notificationName))

        tracker.removeSubscription(id: uuid2, for: notificationName)
        #expect(tracker.hasActiveSubscription(for: notificationName) == false)
    }

    @Test
    func testRemoveNonExistentSubscription() {
        let notificationName = Notification.Name("TestNotification")
        let uuid = UUID()

        tracker.removeSubscription(id: uuid, for: notificationName)

        #expect(tracker.hasActiveSubscription(for: notificationName) == false)
    }
}

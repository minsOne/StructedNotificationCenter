import XCTest

@testable import StructedNotificationCenter

class NotificationTests: XCTestCase {
    var notificationHandler: NotificationHandler!
    var observer: NotificationDataObserver<MyCustomNotificationData>?
    
    override func setUp() {
        super.setUp()
        notificationHandler = NotificationHandler()
    }
    
    override func tearDown() {
        notificationHandler = nil
        super.tearDown()
    }
    
    func testMyCustomNotification() {
        let expectation = self.expectation(description: "MyCustomNotification received")

        // Subscribe to Notification
        observer = NotificationDataObserver<MyCustomNotificationData>()
            .subscribe { [weak self] data in
                self?.notificationHandler.handleNotification(data: data)
                expectation.fulfill() // Fulfill the expectation when the notification is received.
            }
        
        XCTAssertTrue(hasActiveSubscription()) // Ensure subscription is active
        
        // Post Notification
        let myData = MyCustomNotificationData(property: "test")
        NotificationCenter.default.post(data: myData)
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(notificationHandler.receivedData?.property, "test") // Validate the received data
        
        observer = nil
        
        XCTAssertFalse(hasActiveSubscription()) // Ensure subscription is removed after deallocation
    }
    
    func hasActiveSubscription() -> Bool {
        NotificationObserverTracker.shared
            .hasActiveSubscription(for: MyCustomNotificationData.notificationName)
    }
}

// Class to handle Notification
class NotificationHandler {
    var receivedData: MyCustomNotificationData?
    
    func handleNotification(data: MyCustomNotificationData) {
        receivedData = data
    }
}

// Example of Custom Notification Data: MyCustomNotificationData
struct MyCustomNotificationData: NotificationData {
    static let notificationName = Notification.Name("MyCustomNotification")
    let property: String // Data required for Custom Notification
}

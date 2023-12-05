import XCTest
@testable import StructedNotificationCenter

final class NotificationDataObserverTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}

class NotificationTests: XCTestCase {
    var notificationHandler: NotificationHandler!
    
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
        let expectationqe = XCTDarwinNotificationExpectation(notificationName: MyCustomNotificationData.notificationName.rawValue)
        // Notification 구독
        NotificationCenter.default.addObserver(forType: MyCustomNotificationData.self, queue: nil) { [weak self] data in
            self?.notificationHandler.handleNotification(data: data)
            expectation.fulfill() // Notification을 수신하면 expectation을 충족시킨다.
        }
        
        // Notification 발송
        let myData = MyCustomNotificationData(property: "test")
        NotificationCenter.default.post(data: myData)
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(notificationHandler.receivedData?.property, "test") // 받은 데이터 검증
    }
}

// Notification을 처리하는 클래스
class NotificationHandler {
    var receivedData: MyCustomNotificationData?
    
    func handleNotification(data: MyCustomNotificationData) {
        receivedData = data
    }
}

// Custom Notification 데이터 예시: MyCustomNotificationData
struct MyCustomNotificationData: NotificationData {
    static let notificationName = Notification.Name("MyCustomNotification")
    var property: String // Custom Notification에 필요한 데이터
}

// 사용 예시
func exampleUsage() {
    // Notification 게시
    let myData = MyCustomNotificationData(property: "value")
    NotificationCenter.default.post(data: myData)
    
    // Notification 구독
    let observer = NotificationCenter.default.addObserver(forType: MyCustomNotificationData.self, queue: nil) { data in
        print(data.property) // Notification 처리
    }
    
    // 필요한 경우 observer 해제
    NotificationCenter.default.removeObserver(observer)
}

import Foundation

public protocol NotificationData {
    static var notificationName: Notification.Name { get }
}

public class NotificationDataObserver<T: NotificationData> {
    private var observer: AnyObject?
    private let notificationCenter: NotificationCenter
    private let uuid: UUID
    
    public convenience init(center: NotificationCenter = .default) {
        self.init(center: center, uuid: .init())
    }
    
    init(center: NotificationCenter = .default,
         uuid: UUID) {
        self.notificationCenter = center
        self.uuid = uuid
    }
    
    public func post(data: some NotificationData) {
        notificationCenter.post(name: T.notificationName, object: data)
    }
    
    @discardableResult
    public func subscribe(queue: OperationQueue? = nil,
                          using block: @escaping @Sendable (T) -> Void) -> Self
    {
        guard observer == nil else { return self }
        addSubscription()
        
        observer = notificationCenter
            .addObserver(forName: T.notificationName, object: nil, queue: queue) { notification in
                if let data = notification.object as? T {
                    block(data)
                }
            }
        
        return self
    }
    
    deinit {
        if let observer {
            removeSubscription()
            notificationCenter.removeObserver(observer)
            self.observer = nil
        }
    }
    
    private func addSubscription() {
        NotificationObserverTracker.shared
            .addSubscription(id: uuid, for: T.notificationName)
    }
    
    private func removeSubscription() {
        NotificationObserverTracker.shared
            .removeSubscription(id: uuid, for: T.notificationName)
    }
}


/// NotificationCenter 확장 - 타입 안전한 알림 발송 메서드 추가
public extension NotificationCenter {
    /// 타입 안전한 알림 발송 메서드
    /// - Parameter data: 발송할 알림 데이터 (NotificationData 프로토콜 준수)
    func post<T: NotificationData>(data: T) {
        post(name: T.notificationName, object: data)
    }
}

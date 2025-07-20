import Foundation

/// Protocol defining the structure for notification data
/// Types conforming to this protocol must provide a notification name
public protocol NotificationData {
    static var notificationName: Notification.Name { get }
}

/// Observer class for managing notifications with type-safe data
/// Allows posting and subscribing to notifications with specific data types
public class NotificationDataObserver<T: NotificationData> {
    private var observer: AnyObject?
    private let notificationCenter: NotificationCenter
    private let uuid: UUID

    /// Initializes the observer with a default or custom notification center
    /// - Parameter center: The notification center to use (default is `.default`)
    public convenience init(center: NotificationCenter = .default) {
        self.init(center: center, uuid: .init())
    }

    /// Internal initializer with a custom UUID
    /// - Parameters:
    ///   - center: The notification center to use
    ///   - uuid: Unique identifier for the observer
    init(center: NotificationCenter = .default, uuid: UUID) {
        self.notificationCenter = center
        self.uuid = uuid
    }

    /// Posts a notification with the provided data
    /// - Parameter data: The notification data to post
    public func post(data: some NotificationData) {
        notificationCenter.post(name: T.notificationName, object: data)
    }

    /// Subscribes to notifications of the specified type
    /// - Parameters:
    ///   - queue: The operation queue to use for the callback (default is `nil`)
    ///   - block: The callback to execute when a notification is received
    /// - Returns: The observer instance for chaining
    @discardableResult
    public func subscribe(queue: OperationQueue? = nil, using block: @escaping @Sendable (T) -> Void) -> Self {
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

    /// Tracks the addition of a subscription in the tracker
    private func addSubscription() {
        NotificationObserverTracker.shared
            .addSubscription(id: uuid, for: T.notificationName)
    }

    /// Tracks the removal of a subscription in the tracker
    private func removeSubscription() {
        NotificationObserverTracker.shared
            .removeSubscription(id: uuid, for: T.notificationName)
    }
}

/// Extension to add type-safe notification posting to NotificationCenter
public extension NotificationCenter {
    /// Posts a notification with the provided data
    /// - Parameter data: The notification data to post
    func post<T: NotificationData>(data: T) {
        post(name: T.notificationName, object: data)
    }
}

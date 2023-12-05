import Foundation

public protocol NotificationData {
    static var notificationName: Notification.Name { get }
}

public class NotificationDataObserver<T: NotificationData> {
    private var observer: AnyObject?

    public func post(data: some NotificationData) {
        NotificationCenter.default.post(name: T.notificationName, object: data)
    }

    public func subscribe(queue: OperationQueue? = nil,
                          using block: @escaping @Sendable (T) -> Void)
    {
        guard observer == nil else { return }

        observer = NotificationCenter.default
            .addObserver(forName: T.notificationName, object: nil, queue: queue) { notification in
                if let data = notification.object as? T {
                    block(data)
                }
            }
    }

    deinit {
        if let observer {
            NotificationCenter.default.removeObserver(observer)
            self.observer = nil
        }
    }
}

# StructedNotificationCenter

| [English Version](#structednotificationcenter) | [한국어 버전](#structednotificationcenter-한국어) |

## Overview
StructedNotificationCenter is a Swift library that provides a structured and type-safe way to manage notifications using `NotificationCenter`. It ensures better memory management and simplifies the process of posting and subscribing to notifications with specific data types.

---

## Features
- Type-safe notification data using the `NotificationData` protocol.
- Simplified posting and subscribing to notifications.
- Automatic tracking of active subscriptions to prevent memory leaks.

---

## Installation
Add the following dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/minsOne/StructedNotificationCenter.git", from: "1.0.0")
```

---

## Usage

### Define Notification Data
Define a type that conforms to the `NotificationData` protocol:

```swift
struct MyNotificationData: NotificationData {
    static var notificationName: Notification.Name {
        Notification.Name("MyNotification")
    }

    let message: String
}
```

### Post Notifications
Post notifications using the `NotificationCenter.default` instance or the `NotificationCenter` extension:

```swift
NotificationCenter.default.post(data: MyNotificationData(message: "Hello, World!"))
```

### Subscribe to Notifications
Subscribe to notifications with a type-safe callback:

```swift
let observer = NotificationDataObserver<MyNotificationData>()
observer.subscribe { data in
    print("Received message: \(data.message)")
}
```

---

## License
This project is licensed under the MIT License. See the LICENSE file for details.

---

# StructedNotificationCenter (한국어)

## 개요
StructedNotificationCenter는 `NotificationCenter`를 사용하여 알림을 구조적이고 타입 안전하게 관리할 수 있는 Swift 라이브러리입니다. 메모리 관리를 개선하고 특정 데이터 타입으로 알림을 게시하고 구독하는 과정을 단순화합니다.

---

## 주요 기능
- `NotificationData` 프로토콜을 사용한 타입 안전한 알림 데이터.
- 알림 게시 및 구독 간소화.
- 메모리 누수를 방지하기 위한 활성 구독 자동 추적.

---

## 설치
`Package.swift` 파일에 다음 의존성을 추가하세요:

```swift
.package(url: "https://github.com/minsOne/StructedNotificationCenter.git", from: "1.0.0")
```

---

## 사용법

### 알림 데이터 정의
`NotificationData` 프로토콜을 준수하는 타입을 정의합니다:

```swift
struct MyNotificationData: NotificationData {
    static var notificationName: Notification.Name {
        Notification.Name("MyNotification")
    }

    let message: String
}
```

### 알림 게시
`NotificationCenter.default` 인스턴스 또는 `NotificationCenter` 확장을 사용하여 알림을 게시합니다:

```swift
NotificationCenter.default.post(data: MyNotificationData(message: "Hello, World!"))
```

### 알림 구독
타입 안전한 콜백으로 알림을 구독합니다:

```swift
let observer = NotificationDataObserver<MyNotificationData>()
observer.subscribe { data in
    print("Received message: \(data.message)")
}
```

---

## 라이선스
이 프로젝트는 MIT 라이선스에 따라 라이선스가 부여됩니다. 자세한 내용은 LICENSE 파일을 참조하세요.
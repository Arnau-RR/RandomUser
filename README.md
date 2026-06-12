# 👤 RandomUser

A native iOS application developed as part of Adevinta's iOS Engineer Take-Home technical challenge. It showcases a modern SwiftUI architecture, clean MVVM state management, and a full user browsing experience powered by the [RandomUser API](https://randomuser.me/).

![Platform](https://img.shields.io/badge/Platform-iOS-blue)
![Language](https://img.shields.io/badge/Language-Swift-orange)
![UI Framework](https://img.shields.io/badge/UI-SwiftUI-green)
![Persistence](https://img.shields.io/badge/Persistence-SwiftData-purple)

---

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#️-tech-stack)
- [Installation](#-installation)
- [Project Structure](#-project-structure)
- [Architecture](#️-architecture)
- [Testing](#-testing)

---

## ✨ Features

- 👥 **User List** — Displays name, surname, email, phone and photo
- ➕ **Load More** — Infinite scroll mechanism to retrieve more users
- 🚫 **Delete Users** — Deleted users never reappear even after new API calls
- 🔍 **Search** — Filter users by name, surname or email in real time
- 📄 **Detail View** — Gender, full name, address, registered date, email and photo
- 🔄 **Deduplication** — Duplicate users from the API are automatically discarded
- 💾 **Persistence** — User list and order are preserved across app sessions

---

## 🛠️ Tech Stack

| Category | Technology |
| --- | --- |
| **Language** | Swift |
| **UI Framework** | SwiftUI |
| **Architecture** | MVVM |
| **Persistence** | SwiftData |
| **Networking** | URLSession + async/await |
| **Testing** | XCTest (Unit Tests) |

---

## 📦 Installation

1. Clone the repository:

```
git clone https://github.com/Arnau-RR/RandomUser.git
```

2. Open `RandomUser.xcodeproj` in Xcode.
3. Choose your simulator or device.
4. Build and run the project.

> No external dependencies. The project uses only Apple frameworks.

---

## 📁 Project Structure

```
RandomUser/
├── RandomUser/
│   ├── Components/         # Reusable UI components
│   ├── Config/             # App configuration
│   ├── Models/             # Data models (User, UserEntity...)
│   ├── Persistence/        # SwiftData setup
│   ├── Resources/          # Assets and localization
│   ├── Services/           # API layer and protocol
│   ├── ViewModels/         # MainViewModel, ProfileViewModel
│   └── Views/              # MainView, ProfileView, UserListCell
├── RandomUserTests/
│   ├── Factories/          # UserFactory, UserEntityFactory
│   ├── Mocks/              # MockRandomUsersService
│   └── Tests/              # DuplicatesTests, FetchTests, SearchTests, DeleteTests
├── RandomUserUITests/      # UI test placeholders
└── RandomUser.xcodeproj
```

---

## 🏗️ Architecture

The project follows **MVVM** with a clear separation of responsibilities:

- **Views** are declarative and stateless — they only render what the ViewModel exposes.
- **ViewModels** hold all business logic: fetching, deduplication, filtering and deletion.
- **Services** are protocol-based, making them fully mockable for testing.
- **SwiftData** handles persistence via `@Model` with a `@Attribute(.unique)` UUID to prevent duplicates at the database level.

### Deduplication

Users are identified by `login.uuid`. The deduplication logic compares incoming UUIDs against those already stored in the database:

```swift
let existingUUIDs = Set(usersSavedInDB.map(\.uuid))
var seenUUIDs = existingUUIDs
users = users.filter { seenUUIDs.insert($0.login.uuid).inserted }
```

### Deletion

Users are never physically deleted. They are marked with `isDeletedByUser = true` and permanently excluded from all queries and future API responses.

---

## 🧪 Testing

Unit tests are organised by responsibility in four separate files:

| File | What it covers |
| --- | --- |
| `DuplicatesTests` | Deduplication logic, UUID filtering |
| `FetchTests` | Happy path, error handling, `isLoading` state, service call count |
| `SearchTests` | Filter by name, email, empty query, case insensitivity |
| `DeleteTests` | Deleted users hidden from list and not re-added after fetch |

### Testing approach

- **No real network calls** — all tests use `MockRandomUsersService` which returns configurable data without hitting the internet.
- **Dependency Injection** — `MainViewModel` accepts a service via its initializer, making it fully testable.
- **In-memory state** — business logic is tested directly on ViewModel properties without depending on SwiftData.

Run all tests in Xcode via **Product → Test** or `⌘ U`.

---
<p align="center">
Made with ❤️ for Adevinta's iOS Engineer Take-Home Challenge
</p>

<p align="center">
  <a href="https://github.com/Arnau-RR/RandomUser/issues">Report Bug</a>
  ·
  <a href="https://github.com/Arnau-RR/RandomUser/issues">Request Feature</a>
</p>

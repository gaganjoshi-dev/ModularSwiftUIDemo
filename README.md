
📘 Project Name

ModularSwiftUIDemo – Legal & Privacy Dynamic Page

🧩 Project Description

A modular SwiftUI application demonstrating a dynamic, API-driven "Legal and Privacy" page using MVVM + Coordinator architecture, with support for offline fallback, Combine-based navigation, clean separation of concerns, and error handling. Designed for enterprise-scale scalability and testability.

🚀 Features

✅ MVVM + Coordinator: Clean separation of UI, business logic, and navigation
🌐 Remote + Local Fallback: Attempts API fetch; falls back to local JSON on specific network errors
📡 Network Layer:
Custom NetworkManager with error categorization
API configuration via APIConfigProtocol
Decoding service with detailed error diagnostics
📱 SwiftUI Views:
Dynamically rendered list of components: HEADER, IMAGE_CAROUSEL, ACTION_CELL
Responsive layouts with image carousels and action buttons
🧪 Testability First:
Abstracted services (DecoderService, URLSessionProtocol, ComponentRepository)
ViewModels and services ready for unit testing
🧭 Combine Navigation:
PassthroughSubject used for navigation event handling
Coordinator handles deep links and route transitions
🛠 Technologies Used

Layer    Tech Used
UI    SwiftUI
Architecture    MVVM + Coordinator
Networking    URLSession via URLSessionProtocol
JSON Decoding    JSONDecoderService + error diagnostics
Async    async/await
Navigation    NavigationStack, NavigationPath, Combine
Fallback Strategy    Remote → Local
📂 Folder Structure (High-Level)

├── Views/
│   ├── ComponentListView.swift
│   ├── CarouselCardView.swift
│   ├── HeaderCellView.swift
│   └── ActionCellView.swift
├── ViewModels/
│   └── LegalPrivacyViewModel.swift
├── Coordinator/
│   └── LegalPrivacyCoordinator.swift
├── Models/
│   └── LegalPrivacyData.swift
├── Repositories/
│   ├── ComponentRepository.swift
│   ├── LocalRepository.swift
│   └── RemoteRepository.swift
├── Services/
│   ├── ComponentService.swift
│   └── DecoderService.swift
├── Network/
│   ├── NetworkManager.swift
│   ├── APIConfig.swift
│   ├── NetworkError.swift
│   └── URLSessionProtocol.swift
├── Shared/
│   └── ComponentError.swift
🧪 Testing Ideas (Not yet included)

ViewModel logic using mock ComponentService
Repository fallbacks via injected fake RemoteRepository
Network layer tests using mock URLSessionProtocol

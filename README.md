
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

🔗 Author & Contact

Gagan Joshi
🔹 https://www.linkedin.com/in/gaganjoshi-dev/

⚠️ Disclaimer

Copyright (c) 2025 Gagan Joshi



📘 Project Name

ModularSwiftUIDemo – Legal & Privacy Dynamic Page

🧩 Project Description

A modular SwiftUI application demonstrating a dynamic, API-driven Legal and Privacy page using MVVM + Coordinator architecture. The app supports offline fallback, clean separation of concerns, Combine-based navigation, and robust error handling — all designed for enterprise-scale scalability, maintainability, and testability.

🚀 Features

✅ MVVM + Coordinator: Clear separation between views, business logic, and navigation flow
🌐 Remote + Local Fallback: Fetches content via API and falls back to local JSON for specific error scenarios
📡 Robust Networking:
Custom NetworkManager with error categorization
API configuration via APIConfigProtocol
Modular DecoderService with granular error diagnostics
📱 SwiftUI Dynamic Views:
Renders components dynamically: HEADER, IMAGE_CAROUSEL, ACTION_CELL
Responsive layouts with rich content like carousels and buttons
🧪 Testability First:
Dependency-injected services (DecoderService, URLSessionProtocol, ComponentRepository)
ViewModels built for unit testing
🧭 Combine-Driven Navigation:
Uses PassthroughSubject for emitting navigation events
Coordinator handles routing and deep linking logic
🔗 Author & Contact

Gagan Joshi
🔹 https://www.linkedin.com/in/gaganjoshi-dev/

⚠️ Disclaimer & License

© 2025 Gagan Joshi. All rights reserved.
This project is the intellectual property of Gagan Joshi.

📌 Unauthorized use, distribution, or reproduction of this repository, its code, or any of its components in any form, including creating derivative works or re-uploads, is strictly prohibited without prior written permission.


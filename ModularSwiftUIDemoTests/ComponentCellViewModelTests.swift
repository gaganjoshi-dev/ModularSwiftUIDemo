//
//  ComponentCellViewModelTests.swift
//  ModularSwiftUIDemoTests
//

import Foundation
import Testing
@testable import ModularSwiftUIDemo

struct ComponentCellViewModelTests {

    private func makeComponent(
        identifier: String = "action1",
        deeplink: String? = nil,
        weblink: String? = "https://example.com/privacy"
    ) -> Component {
        let json = """
        {
          "identifier": "\(identifier)",
          "type": "ACTION_CELL",
          "title": "Privacy Policy",
          "deeplink": \(deeplink.map { "\"\($0)\"" } ?? "null"),
          "weblink": \(weblink.map { "\"\($0)\"" } ?? "null")
        }
        """
        return try! JSONDecoder().decode(Component.self, from: Data(json.utf8))
    }

    @Test func linkDestination_prefersDeepLinkOverWebLink() throws {
        let viewModel = ComponentCellViewModel(
            component: makeComponent(deeplink: "myapp://privacy", weblink: "https://example.com")
        )

        guard case .deepLink(let url) = viewModel.linkDestination else {
            Issue.record("Expected deepLink destination")
            return
        }
        #expect(url.absoluteString == "myapp://privacy")
    }

    @Test func linkDestination_usesStableIdentifier() {
        let viewModel = ComponentCellViewModel(component: makeComponent(identifier: "privacyChoices"))
        #expect(viewModel.id == "privacyChoices")
    }
}

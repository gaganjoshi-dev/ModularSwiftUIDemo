//
//  LinkOpener.swift
//  ModularSwiftUIDemo
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

protocol LinkOpening {
    func open(_ url: URL)
}

struct SystemLinkOpener: LinkOpening {
    func open(_ url: URL) {
        #if canImport(UIKit)
        UIApplication.shared.open(url)
        #endif
    }
}

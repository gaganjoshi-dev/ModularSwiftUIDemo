//
//  CoordinatorProtocol.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-13.
//
import SwiftUI

protocol CoordinatorProtocol: ObservableObject {
    associatedtype ViewType: View
    func buildView() -> ViewType
}

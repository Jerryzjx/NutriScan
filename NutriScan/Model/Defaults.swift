//
//  Defaults.swift
//  NutriScan
//
//  Created by leonard on 2024-02-11.
//

import Foundation
import SwiftUI

public class Defaults: ObservableObject {
    @AppStorage("caloriesGoal") public var caloriesGoalText: String = "2250"
    @AppStorage("carbohydrateGoal") public var carbohydrateGoalText: String = "100"
    @AppStorage("proteinGoal") public var proteinGoalText: String = "100"
    @AppStorage("fatGoal") public var fatGoalText: String = "75"
    @AppStorage("currentTheme") public var currentTheme: String = "Emerald"
    @AppStorage("isHealthKitEnabled") public var isHealthKitEnabled: Bool = false
    public static let shared = Defaults()
}

@propertyWrapper
public struct Default<T>: DynamicProperty {
    @ObservedObject private var defaults: Defaults
    private let keyPath: ReferenceWritableKeyPath<Defaults, T>
    public init(_ keyPath: ReferenceWritableKeyPath<Defaults, T>, defaults: Defaults = .shared) {
        self.keyPath = keyPath
        self.defaults = defaults
    }

    public var wrappedValue: T {
        get { defaults[keyPath: keyPath] }
        nonmutating set { defaults[keyPath: keyPath] = newValue }
    }

    public var projectedValue: Binding<T> {
        Binding(
            get: { defaults[keyPath: keyPath] },
            set: { value in
                defaults[keyPath: keyPath] = value
            }
        )
    }
}

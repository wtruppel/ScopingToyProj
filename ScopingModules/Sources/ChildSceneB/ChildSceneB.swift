import ComposableArchitecture

public enum ChildSceneB {}

// MARK: - State

extension ChildSceneB {

    public struct State: Equatable {

        public var userIsLoggedIn: Bool

        public init(userIsLoggedIn: Bool = false) {
            self.userIsLoggedIn = userIsLoggedIn
        }

    }

}

// MARK: - Action

extension ChildSceneB {

    public enum Action: Equatable {

        case userIsLoggedInToggleTapped

    }

}

// MARK: - Environment

extension ChildSceneB {

    public typealias Environment = Void

}

// MARK: - Reducers

extension ChildSceneB {

    public static let reducer: Reducer<State, Action, Environment> = localReducer

    static let localReducer: Reducer<State, Action, Environment> =
    Reducer { state, action, environment in
        switch action {

            case .userIsLoggedInToggleTapped:
                state.userIsLoggedIn.toggle()
                return .none

        }
    }

}

import SwiftUI

// MARK: - View

extension ChildSceneB {

    public struct View: SwiftUI.View {

        private let store: Store<State, Action>
        @ObservedObject private var viewStore: ViewStore<State, Action>

        public init(store: Store<State, Action>) {
            self.store = store
            self.viewStore = ViewStore(store)
        }

        public var body: some SwiftUI.View {
            print("ChildSceneB.View rendered")
            return GroupBox(label: Text("ChildSceneB") ) {
                Toggle(
                    "User is logged in",
                    isOn: viewStore.binding(
                        get: \.userIsLoggedIn,
                        send: .userIsLoggedInToggleTapped
                    )
                )
            }
        }

    }

}

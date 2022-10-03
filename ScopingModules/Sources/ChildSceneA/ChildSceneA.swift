import ComposableArchitecture

public enum ChildSceneA {}

// MARK: - State

extension ChildSceneA {

    public struct State: Equatable {

        public var microphoneIsOn: Bool

        public init(microphoneIsOn: Bool = false) {
            self.microphoneIsOn = microphoneIsOn
        }

    }

}

// MARK: - Action

extension ChildSceneA {

    public enum Action: Equatable {

        case microphoneIsOnToggleTapped

    }

}

// MARK: - Environment

extension ChildSceneA {

    public typealias Environment = Void

}

// MARK: - Reducers

extension ChildSceneA {

    public static let reducer: Reducer<State, Action, Environment> = localReducer

    static let localReducer: Reducer<State, Action, Environment> =
    Reducer { state, action, environment in
        switch action {

            case .microphoneIsOnToggleTapped:
                state.microphoneIsOn.toggle()
                return .none

        }
    }

}

import SwiftUI

// MARK: - View

extension ChildSceneA {

    public struct View: SwiftUI.View {

        private let store: Store<State, Action>

        public init(store: Store<State, Action>) {
            self.store = store
        }

        public var body: some SwiftUI.View {
            print("ChildSceneA.View rendered")
            return GroupBox(label: Text("ChildSceneA") ) {
                WithViewStore(store, observe: \.microphoneIsOn) { viewStore in
                    Toggle(
                        "Microphone is on",
                        isOn: viewStore.binding(send: .microphoneIsOnToggleTapped)
                    )
                }
            }
        }

    }

}

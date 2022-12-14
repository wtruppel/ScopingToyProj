import ChildSceneA
import ChildSceneB
import ComposableArchitecture

public enum RootScene {}

// MARK: - State

extension RootScene {

    @dynamicMemberLookup
    public struct State: Equatable {

        public var childSceneA: ChildSceneA.State
        public var childSceneB: ChildSceneB.State

        public init(
            childSceneA: ChildSceneA.State = .init(),
            childSceneB: ChildSceneB.State = .init()
        ) {
            self.childSceneA = childSceneA
            self.childSceneB = childSceneB
        }

        public subscript <Value> (dynamicMember kp: WritableKeyPath<ChildSceneA.State, Value>) -> Value {
            get { childSceneA[keyPath: kp] }
            set { childSceneA[keyPath: kp] = newValue }
        }

        public subscript <Value> (dynamicMember kp: WritableKeyPath<ChildSceneB.State, Value>) -> Value {
            get { childSceneB[keyPath: kp] }
            set { childSceneB[keyPath: kp] = newValue }
        }

    }

}

// MARK: - Action

extension RootScene {

    public enum Action: Equatable {

        case userIsLoggedInToggleTapped

        case childSceneA(ChildSceneA.Action)
        case childSceneB(ChildSceneB.Action)

    }

}

// MARK: - Environment

extension RootScene {

    public typealias Environment = Void

}

// MARK: - Reducers

extension RootScene {

    public static let reducer: Reducer<State, Action, Environment> =
        .combine(
            childSceneAReducer,
            childSceneBReducer,
            localReducer
        )

    static let localReducer: Reducer<State, Action, Environment> =
    Reducer { state, action, environment in
        switch action {

            case .userIsLoggedInToggleTapped:
                state.userIsLoggedIn.toggle()
                return .none

            case .childSceneA(.microphoneIsOnToggleTapped):
                return .none

            case let .childSceneB(action):
                return .none

        }
    }

    static let childSceneAReducer: Reducer<State, Action, Environment> =
    ChildSceneA.reducer
        .pullback(
            state: \.childSceneA,
            action: /Action.childSceneA,
            environment: {}
        )

    static let childSceneBReducer: Reducer<State, Action, Environment> =
    ChildSceneB.reducer
        .pullback(
            state: \.childSceneB,
            action: /Action.childSceneB,
            environment: {}
        )

}

import SwiftUI

// MARK: - View

extension RootScene {

    public struct View: SwiftUI.View {

        private let childSceneAStore: Store<ChildSceneA.State, ChildSceneA.Action>
        private let childSceneBStore: Store<ChildSceneB.State, ChildSceneB.Action>

        @ObservedObject private var userIsLoggedInViewStore: ViewStore<Bool, Action>

        public init(store: Store<State, Action>) {
            self.childSceneAStore = store.scope(
                state: \.childSceneA,
                action: Action.childSceneA
            )
            self.childSceneBStore = store.scope(
                state: \.childSceneB,
                action: Action.childSceneB
            )
            self.userIsLoggedInViewStore = ViewStore(store.scope(state: \.userIsLoggedIn))
        }

        public var body: some SwiftUI.View {
            print("RootScene.View rendered")
            return GroupBox(label: Text("RootScene") ) {
                VStack {

                    Toggle(
                        "User is logged in",
                        isOn: userIsLoggedInViewStore.binding(send: .userIsLoggedInToggleTapped)
                    )

                    ChildSceneA.View(store: childSceneAStore)
                        .padding(15)

                    ChildSceneB.View(store: childSceneBStore)
                        .padding(15)

                }
            }
        }

    }

}

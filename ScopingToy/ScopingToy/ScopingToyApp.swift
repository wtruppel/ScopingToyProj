import ComposableArchitecture
import RootScene
import SwiftUI

@main
struct ScopingToyApp: App {

    let store = Store<RootScene.State, RootScene.Action>(
        initialState: RootScene.State(),
        reducer: RootScene.reducer,
        environment: ()
    )

    var body: some Scene {
        print("ScopingToyApp.View rendered")
        return WindowGroup {
            RootScene.View(store: store)
        }
    }
}

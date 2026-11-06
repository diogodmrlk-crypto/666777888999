// App.swift
import SwiftUI

@main
struct NubankDashboardApp: App {
    @StateObject private var state = AppState()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(state)
        }
    }
}

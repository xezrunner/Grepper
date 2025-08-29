// Grepper::GrepperApp.swift - 27/08/2025

import SwiftUI

@main
struct GrepperApp: App {
    @State var workspaceInfo: WorkspaceInfo = .defaultWorkspace
    
    var body: some Scene {
        WindowGroup {
            ContentView(workspaceInfo: workspaceInfo)
        }
        .commands {
            SidebarCommands()
            
            GrepperCommands.MenuBarCommands(with: workspaceInfo)
        }
    }
}



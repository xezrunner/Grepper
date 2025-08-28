// Grepper::GrepperApp.swift - 27/08/2025

import SwiftUI

@main
struct GrepperApp: App {
    @State var workspaceInfo: WorkspaceInfo = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView(workspaceInfo: workspaceInfo)
        }
        .commands {
            SidebarCommands()
            
            CommandGroup(after: .newItem) {
                Button("Open entry...", systemImage: "arrow.up.right.square") {
                    GrepperCommands.OpenEntry(workspaceInfo: workspaceInfo)
                }
            }
        }
    }
}

enum GrepperCommands {
    static func OpenEntry(workspaceInfo: WorkspaceInfo) {
        FilePicker.pick(allowDirectories: true) { url in
            guard let url else { return }
            workspaceInfo.addEntry(from: url)
        }
    }
}

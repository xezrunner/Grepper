// Grepper::GrepperCommands.swift - 29/08/2025
import SwiftUI

enum GrepperCommands {
    struct MenuBarCommands: Commands {
        @FocusedValue(WorkspaceInfo.self) var activeWorkspace

        var body: some Commands {
            CommandGroup(after: .newItem) {
                Button("Open entry...", systemImage: "arrow.up.right.square") {
                    if let activeWorkspace {
                        GrepperCommands.OpenEntry(workspaceInfo: activeWorkspace)
                    }
                }
                .disabled(activeWorkspace == nil)
                .keyboardShortcut("o", modifiers: .command)
            }
        }
    }
    
    static func OpenEntry(workspaceInfo: WorkspaceInfo) {
        FilePicker.pick(allowDirectories: true) { url in
            guard let url else { return }
            workspaceInfo.addEntry(from: url, navigate: true)
        }
    }
}

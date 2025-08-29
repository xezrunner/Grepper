// Grepper::GrepperCommands.swift - 29/08/2025
import SwiftUI

enum GrepperCommands {
    static func MenuBarCommands(with workspaceInfo: WorkspaceInfo?) -> some Commands {
        CommandGroup(after: .newItem) {
            Button("Open entry...", systemImage: "arrow.up.right.square") {
                GrepperCommands.OpenEntry(workspaceInfo: workspaceInfo!)
            }
            .disabled(workspaceInfo == nil)
            .keyboardShortcut("o", modifiers: .command)
        }
    }
    
    static func OpenEntry(workspaceInfo: WorkspaceInfo) {
        FilePicker.pick(allowDirectories: true) { url in
            guard let url else { return }
            workspaceInfo.addEntry(from: url, navigate: true)
        }
    }
}

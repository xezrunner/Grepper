// Grepper::GrepperCommands.swift - 29/08/2025
import SwiftUI

enum GrepperCommands {
    struct MenuBarCommands: Commands {
        @FocusedValue(WorkspaceController.self) var activeWorkspace

        var body: some Commands {
            CommandGroup(after: .newItem) {
                Button("Open entry...", systemImage: "arrow.up.right.square") {
                    if let activeWorkspace {
                        GrepperCommands.OpenEntry(for: activeWorkspace)
                    }
                }
                .disabled(activeWorkspace == nil)
                .keyboardShortcut("o", modifiers: .command)
            }
        }
    }
    
    static func OpenEntry(for workspaceController: WorkspaceController) {
        FilePicker.pick(allowDirectories: true) { url in
            guard let url else { return }
            do {
                try workspaceController.addEntry(from: url, navigate: true)
            } catch {
                // FIXME: Error UI
                print("⚠️ Failed to open entry: \(error)")
            }
        }
    }
}

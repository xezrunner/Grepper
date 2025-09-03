// Grepper::GrepperApp.swift - 27/08/2025

import SwiftUI

var WORKSPACE_UI_DEBUG_STRIP = true

@main
struct GrepperApp: App {
    @State private var workspaceRegistry = WorkspaceRegistry()
    
    @FocusedValue(WorkspaceController.self) var activeWorkspace
    
    init() {
//        UserDefaults.standard.setValue(1.0, forKey: "iOSMacScaleFactor")
//        UserDefaults.standard.setValue(true, forKey: "UIUserInterfaceIdiomMac")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(workspaceRegistry)
        }
        .commands {
            SidebarCommands()
            GrepperCommands.MenuBarCommands()
        }
        
        #if os(macOS)
        UtilityWindow("Workspace Debug", id: WORKSPACE_DEBUG_INSPECTOR_SCENE_ID) {
            WorkspaceDebugInspectorView(activeWorkspace: activeWorkspace)
        }
        .environment(workspaceRegistry)
        #endif
    }
}

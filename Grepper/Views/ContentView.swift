// Grepper::ContentView.swift - 27/08/2025
import SwiftUI

struct ContentView: View {
    @Environment(WorkspaceRegistry.self) var workspaceRegistry
    
    @State var workspaceInfo: WorkspaceInfo // Each window gets its own workspace
    
    @State var activeWorkspace: WorkspaceInfo?

    init(workspaceInfo: WorkspaceInfo? = nil) {
        self._workspaceInfo = State(initialValue: workspaceInfo ?? .defaultWorkspace)
    }
    
    var body: some View {
        WorkspaceView(workspaceInfo: workspaceInfo)
            .onAppear    { workspaceRegistry.register(workspaceInfo) }
            .onDisappear { workspaceRegistry.unregister(workspaceInfo) }
        
            .focusedSceneValue(workspaceInfo)
    }
}

#Preview {
    ContentView()
        .environment(WorkspaceRegistry())
}

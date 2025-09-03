// Grepper::ContentView.swift - 27/08/2025
import SwiftUI

struct ContentView: View {
    @Environment(WorkspaceRegistry.self) var workspaceRegistry
    
    // Each window gets its own workspace:
    @State var workspaceController: WorkspaceController
    
    init(workspaceController: WorkspaceController? = nil) {
        self.workspaceController = workspaceController ?? .defaultWorkspace
    }
    
    var body: some View {
        WorkspaceView(workspace: workspaceController)
            .onAppear    { workspaceRegistry.register  (workspaceController) }
            .onDisappear { workspaceRegistry.unregister(workspaceController) }
        
            .focusedSceneValue(workspaceController)
    }
}

#Preview {
    ContentView()
        .environment(WorkspaceRegistry())
}

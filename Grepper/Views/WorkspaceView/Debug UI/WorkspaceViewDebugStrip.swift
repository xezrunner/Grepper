// Grepper::WorkspaceViewDebugStrip.swift - 29/08/2025

import SwiftUI

let WORKSPACE_DEBUG_INSPECTOR_SCENE_ID = "workspace-inspector"

struct WorkspaceViewDebugStrip: View {
    @Environment(WorkspaceRegistry.self) private var workspaceRegistry
    @Environment(\.openWindow) private var openWindow
    
    @FocusedValue(WorkspaceController.self) var activeWorkspace
    
    var workspace: WorkspaceController?
    
    func openDebugInspector() {
        workspaceRegistry.debugInspector_fromWorkspace = workspace
        openWindow(id: WORKSPACE_DEBUG_INSPECTOR_SCENE_ID)
    }
    
    var body: some View {
        HStack(spacing: 4) {
            if let workspace {
                if workspaceRegistry.workspaces.count > 1 {
                    Text("\(workspace.id.uuidString) |")
                }
                Text("entries: \(workspace.info.entries.count) [\(workspace.entrySelection?.displayName ?? "<none>")]")
            }
            else {
                Text("No workspace selected").foregroundStyle(.secondary)
            }
        }
        .monospaced().font(.system(size: 10))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .background(.black).foregroundStyle(.white)
        .contentShape(.rect)
        
        .onTapGesture(perform: openDebugInspector)
    }
}

#Preview {
    @Previewable @State var registry: WorkspaceRegistry = .registryForPreviews

    var activeWorkspace: WorkspaceController? { registry.workspaces.first }
    
    VStack {
        Text("< content >")
            .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    
    .safeAreaInset(edge: .bottom) { WorkspaceViewDebugStrip() }
    
    .environment(registry)
}

// Grepper::WorkspaceRegistry.swift - 29/08/2025

import SwiftUI
import Observation

@MainActor @Observable class WorkspaceRegistry {
    var workspaces: [WorkspaceController] = []
    
    func register(_ workspace: WorkspaceController) {
        workspaces.append(workspace)
    }
    func unregister(_ workspace: WorkspaceController) {
        workspaces.removeAll(where: { $0 == workspace })
    }
    
    var debugInspector_fromWorkspace: WorkspaceController?
}

extension WorkspaceRegistry {
    static var registryForPreviews: WorkspaceRegistry {
        let registry = WorkspaceRegistry()
        
        registry.workspaces.append(.defaultWorkspace)
        registry.debugInspector_fromWorkspace = registry.workspaces.first!
        
        return registry
    }
}

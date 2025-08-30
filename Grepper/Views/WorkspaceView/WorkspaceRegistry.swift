// Grepper::WorkspaceRegistry.swift - 29/08/2025

import SwiftUI
import Observation

@MainActor @Observable class WorkspaceRegistry {
    var workspaces: [WorkspaceInfo] = []
    
    func register(_ workspace: WorkspaceInfo) {
        workspaces.append(workspace)
    }
    func unregister(_ workspace: WorkspaceInfo) {
        workspaces.removeAll(where: { $0 == workspace })
    }
    
    var debugInspector_fromWorkspace: WorkspaceInfo?
}

extension WorkspaceRegistry {
    static var registryForPreviews: WorkspaceRegistry {
        let registry = WorkspaceRegistry()
        
        registry.workspaces.append(.defaultWorkspace)
        registry.workspaces.first?.entries.append(.init())
        
        registry.workspaces.append(.defaultWorkspace)
        registry.debugInspector_fromWorkspace = registry.workspaces.first!
        
        return registry
    }
}

// Grepper::WorkspaceView.swift - 27/08/2025

import SwiftUI

enum WorkspaceViewPage: Codable, Hashable, Identifiable {
    var id: UUID { UUID() } // TEMP
    
    case entry(entry: WorkspaceEntry)
    case entrySettings(entry: WorkspaceEntry)
    case workspaceSettings
    
    var entry: WorkspaceEntry? {
        switch self {
            case .entry        (entry: let e): return e
            case .entrySettings(entry: let e): return e
            default: return nil
        }
    }
    
    var friendlyName: String { // Mainly for back/forward navigation:
        switch self {
            case .entry:             "\(entry?.name ?? "<nil>")"
            case .entrySettings:     "Settings for \(entry?.name ?? "<nil>")"
            case .workspaceSettings: "Workspace settings"
        }
    }
}

struct WorkspaceView: View {
    var workspaceInfo: WorkspaceInfo
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detail
        }
    }
    
    @ViewBuilder var sidebar: some View {
        if workspaceInfo.entries.isEmpty { emptySidebar }
        else                             { workspaceSidebar }
    }
    
    @ViewBuilder var detail: some View {
        if workspaceInfo.entries.isEmpty            { emptyDetail }
        else if workspaceInfo.entrySelection == nil { noSelectionDetail }
        else                                        { workspaceDetail }
    }
}

#Preview {
    WorkspaceView(workspaceInfo: .defaultWorkspace)
}

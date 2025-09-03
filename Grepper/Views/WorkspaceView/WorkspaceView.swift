// Grepper::WorkspaceView.swift - 27/08/2025

import SwiftUI

enum WorkspaceViewPage: Codable, Hashable, Identifiable {
    var id: UUID { UUID() } // TEMP
    
    case entry(with: WorkspaceEntry)
    case entrySettings(with: WorkspaceEntry)
    case workspaceSettings
    
    var entry: WorkspaceEntry? {
        switch self {
            case .entry        (with: let entry): return entry
            case .entrySettings(with: let entry): return entry
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
    var workspace: WorkspaceController
    
    var navigation:    WorkspaceNavigation { workspace.info.navigation }
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detail
        }
    }
    
    @ViewBuilder var sidebar: some View {
        if workspace.info.entries.isEmpty { emptySidebar }
        else                             { workspaceSidebar }
    }
    
    var detail: some View {
        ZStack {
            if workspace.info.entries.isEmpty { emptyDetail }
            else {
                if workspace.currentPage == nil { noSelectionDetail }
                else                                { workspaceDetail }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) { if WORKSPACE_UI_DEBUG_STRIP { WorkspaceViewDebugStrip(workspace: workspace) } }
    }
}

#Preview {
    WorkspaceView(workspace: .defaultWorkspace)
        .environment(WorkspaceRegistry())
}

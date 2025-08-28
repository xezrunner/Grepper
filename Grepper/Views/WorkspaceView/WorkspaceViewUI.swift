// Grepper::WorkspaceViewUI.swift - 28/08/2025
import SwiftUI

extension WorkspaceView {
    var workspaceSidebar: some View {
        List(workspaceInfo.entries, selection: _currentPage) { entry in
            let tag = WorkspaceViewPage.entry(entry: entry)
            Text(entry.name).tag(tag)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { pushPage(page: .workspaceSettings) } label: {
                    Label("Workspace settings", systemImage: "gear")
                }
            }
            
            sidebarNavigationToolbarGroup
        }
    }
    
    var workspaceDetail: some View {
        VStack {
            Text("< workspace detail >")
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                Text("Workspace: \(workspaceInfo.hashValue.description)  selection: \(workspaceInfo.entrySelection.debugDescription)")
                Text("Page: \(currentPage.debugDescription)")
                Text("Path: \(navigationPath.count)  forwards: \(navigationPathForwards.count)")
            }
        }
    }
}
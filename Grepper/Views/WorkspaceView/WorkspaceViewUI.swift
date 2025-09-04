// Grepper::WorkspaceViewUI.swift - 28/08/2025
import SwiftUI

extension WorkspaceView {
    func sidebarEntry(with entry: WorkspaceEntry) -> some View {
        let tag = WorkspaceViewPage.entry(with: entry)
        return Text(entry.displayName).tag(tag)
    }
    
    var workspaceSidebar: some View {
        List(workspace.info.entries, selection: navigation._currentPage) { entry in
            sidebarEntry(with: entry)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { navigation.pushPage(page: .workspaceSettings) } label: {
                    Label("Workspace settings", systemImage: "gear")
                }
            }
        }
    }
    
    var workspaceDetail: some View {
        return VStack {
            Text("< workspace detail >")
        }
        .toolbar { sidebarNavigationToolbarGroup }
    }
}

struct WorkspaceView_ListView: View {
    var workspaceInfo: WorkspaceInfo
    
    var body: some View {
        Text("< list view >")
    }
}


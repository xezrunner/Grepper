// Grepper::WorkspaceViewUI.swift - 28/08/2025
import SwiftUI

extension WorkspaceView {
    var workspaceSidebar: some View {
        List(workspaceInfo.entries, selection: navigation._currentPage) { entry in
            let tag = WorkspaceViewPage.entry(entry: entry)
            Text(entry.name).tag(tag)
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


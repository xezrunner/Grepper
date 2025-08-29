// Grepper::WorkspaceViewUI.swift - 28/08/2025
import SwiftUI

extension WorkspaceView {
    var workspaceSidebar: some View {
        List(workspaceInfo.entries, selection: workspaceInfo._currentPage) { entry in
            let tag = WorkspaceViewPage.entry(entry: entry)
            Text(entry.name).tag(tag)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { workspaceInfo.pushPage(page: .workspaceSettings) } label: {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Text("Workspace \(workspaceInfo.hashValue.description) | entries: \(workspaceInfo.entries.count) | entry: \"\(workspaceInfo.entrySelection?.name ?? "<nil>")\"")
            }
            .monospaced()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .background(.black).foregroundStyle(.white)
        }
    }
}

struct WorkspaceView_ListView: View {
    var workspaceInfo: WorkspaceInfo
    
    var body: some View {
        Text("< list view >")
    }
}

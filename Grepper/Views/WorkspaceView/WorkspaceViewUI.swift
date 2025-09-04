// Grepper::WorkspaceViewUI.swift - 28/08/2025
import SwiftUI

extension WorkspaceView {
    var workspaceSidebar: some View {
        List(workspace.info.entries, selection: navigation._currentPage) { entry in
            WorkspaceView_Sidebar.sidebarEntry(with: entry)
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

struct WorkspaceView_Sidebar {
    // TEMP:
    private static func sidebarEntryBaseRow(text: String, error: String?) -> some View {
        HStack {
            Text(text)
            Spacer()
            if error != nil { Image(systemName: "exclamationmark.triangle.fill").symbolRenderingMode(.multicolor) }
        }
        .monospaced().font(.system(size: 12))
        .foregroundStyle(error == nil ? .primary : .tertiary)
    }
    
    @ViewBuilder private static func sidebarEntryRow(with entry: WorkspaceEntry) -> some View {
        switch entry.self {
            case .file  (let file):   sidebarEntryBaseRow(text: file.displayName,   error: file.error)
            case .folder(let folder): sidebarEntryBaseRow(text: folder.displayName, error: folder.error)
            case .group (let group):  sidebarEntryBaseRow(text: group.displayName,  error: nil)
        }
    }
    
    @ViewBuilder static func sidebarEntry(with entry: WorkspaceEntry) -> some View {
        let rootTag = WorkspaceViewPage.entry(with: entry)
        
        switch entry.self {
            case .file: sidebarEntryRow(with: entry).tag(rootTag)
            case .folder, .group:
                OutlineGroup(entry, children: \.children) { subentry in
                    let subentryTag = WorkspaceViewPage.entry(with: subentry)
                    switch subentry {
                        case .file  : sidebarEntryRow(with: subentry).tag(subentryTag)
                        case .folder: sidebarEntryRow(with: subentry).tag(subentryTag)
                        case .group : sidebarEntryRow(with: subentry).tag(subentryTag)
                    }
                }
                .tag(rootTag)
        }
    }
}

struct WorkspaceView_ListView: View {
    var workspaceInfo: WorkspaceInfo
    
    var body: some View {
        Text("< list view >")
    }
}


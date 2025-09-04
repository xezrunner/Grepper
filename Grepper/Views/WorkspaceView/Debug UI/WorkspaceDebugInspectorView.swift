// Grepper::WorkspaceDebugView.swift - 29/08/2025
import SwiftUI

struct WorkspaceDebugInspectorView: View {
    @Environment(WorkspaceRegistry.self) private var registry
    
    @Environment(\.colorScheme) var colorScheme
    
    //@FocusedValue(WorkspaceInfo.self)
    var activeWorkspace: WorkspaceController?
    
    var _selectedWorkspace: Binding<WorkspaceController?> {
        Binding(
            get: { registry.debugInspector_fromWorkspace},
            set: { newValue in registry.debugInspector_fromWorkspace = newValue })
    }
    var selectedWorkspace: WorkspaceController? { _selectedWorkspace.wrappedValue }
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detail
        }
    }
    
    var sidebar: some View {
        List(Array(registry.workspaces.enumerated()),  id: \.element, selection: _selectedWorkspace) { index, workspace in
            // FIXME: FB19978904
            HStack(spacing: 8) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Workspace #\(index+1)").font(.headline)
                        Badge(text: "Active", visible: activeWorkspace == workspace)
                    }
                    Group {
                        Text(workspace.id.uuidString).monospaced()
                        Text("Entries: \(workspace.info.entries.count)").foregroundStyle(.secondary)
                    }
                    .font(.footnote)
                }
            }
            .tag(workspace)
        }
        .toolbar(removing: .sidebarToggle)
        .navigationTitle("Workspaces")
        .navigationSplitViewColumnWidth(min: 150, ideal: 220)
    }
    
    @ViewBuilder var detail: some View {
        if let selectedWorkspace { workspaceDetail(for: selectedWorkspace) }
        else {
            Text("Select a workspace")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Workspace Details")
        }
    }
    
    func workspaceEntryRowButton(with workspace: WorkspaceController, for entry: WorkspaceEntry) -> some View {
        Button {
            if let selected = workspace.entrySelection { workspace.entrySelection = (entry == selected) ? nil : entry }
            else { workspace.entrySelection = entry }
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(entry.displayName).bold().font(.callout)
                    Text("\(entry.id.uuidString)  type: \(entry.typeName)").font(.footnote)
                    Group {
                        switch entry.self {
                            case .file  (let file):   if let error = file.error   { Text("⚠️ Error: \(error)") }
                            case .folder(let folder): if let error = folder.error { Text("⚠️ Error: \(error)") }
                            case .group: EmptyView()
                        }
                    }
                }
                .monospaced().font(.footnote)
                Spacer()
                Badge(text: "Selected", visible: entry == workspace.entrySelection)
            }
        }
        .buttonStyle(.borderless)
    }
    
    func workspaceDetail(for workspace: WorkspaceController) -> some View {
        let entries = workspace.info.entries
        
        return VStack(alignment: .leading) {
            Group {
                Text("ID: \(Text(workspace.id.uuidString).monospaced())")
                Text("Page: \(Text(workspace.currentPage?.friendlyName ?? "<nil>").monospaced())")
            }
            .foregroundStyle(.secondary)
            
            Divider()
            
            Text("Entries (\(entries.count))")
                .font(.headline)
            
            if !entries.isEmpty {
                List(entries) { entry in
                    switch entry.self {
                        case .file:
                            workspaceEntryRowButton(with: workspace, for: entry)
                        default:
                            OutlineGroup(entry, children: \.children) { subentry in
                                workspaceEntryRowButton(with: workspace, for: subentry)
                            }
                    }
                }
#if os(macOS)
                .alternatingRowBackgrounds()
#endif
            } else {
                Text("No entries").foregroundStyle(.secondary)
            }
        }
        .padding()
        .navigationTitle("Workspace \(workspace.id.uuidString.prefix(6))")
    }
}

extension WorkspaceDebugInspectorView {
    var blackOrWhiteByTheme: Color { colorScheme == .light ? .black : .white }
    
    func Badge(text: String, visible: Bool = true) -> some View {
        Text(text)
            .font(.footnote).bold().textCase(.uppercase)
            .padding(.vertical, 2).padding(.horizontal, 8)
            .background(blackOrWhiteByTheme, in: .capsule).foregroundStyle(.background)
            .opacity(visible ? 1 : 0)
    }
    
    func SidebarWorkspaceRow(for workspace: WorkspaceInfo) -> some View {
        // FIXME: FB19978904
        EmptyView()
    }
}

#Preview {
    @Previewable @State var registry: WorkspaceRegistry = .registryForPreviews
    
    var activeWorkspace: WorkspaceController? { registry.workspaces.first }
    
    WorkspaceDebugInspectorView(activeWorkspace: activeWorkspace)
        .environment(registry)
}


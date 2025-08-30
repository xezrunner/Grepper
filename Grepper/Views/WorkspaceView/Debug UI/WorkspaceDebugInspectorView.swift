// Grepper::WorkspaceDebugView.swift - 29/08/2025
import SwiftUI

struct WorkspaceDebugInspectorView: View {
    @Environment(WorkspaceRegistry.self) private var registry
    
    @Environment(\.colorScheme) var colorScheme
    
    //@FocusedValue(WorkspaceInfo.self)
    var activeWorkspace: WorkspaceInfo?
    
    var _selectedWorkspace: Binding<WorkspaceInfo?> {
        Binding(
            get: { registry.debugInspector_fromWorkspace},
            set: { newValue in registry.debugInspector_fromWorkspace = newValue })
    }
    var selectedWorkspace: WorkspaceInfo? { _selectedWorkspace.wrappedValue }
    
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
                        Text("Entries: \(workspace.entries.count)").foregroundStyle(.secondary)
                    }
                    .font(.footnote)
                }
            }
            .tag(workspace)
        }
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
    
    func workspaceDetail(for selectedWorkspace: WorkspaceInfo) -> some View {
        VStack(alignment: .leading) {
            Group {
                Text("ID: \(Text(selectedWorkspace.id.uuidString).monospaced())")
                Text("Page: \(Text(selectedWorkspace.currentPage?.friendlyName ?? "<nil>").monospaced())")
            }
            .foregroundStyle(.secondary)
            
            Divider()
            
            Text("Entries (\(selectedWorkspace.entries.count))")
                .font(.headline)
            
            if !selectedWorkspace.entries.isEmpty {
                List(selectedWorkspace.entries) { entry in
                    Button {
                        selectedWorkspace.entrySelection = selectedWorkspace.entrySelection == nil ? entry : nil
                    } label: {
                        HStack {
                            Text(entry.name).font(.body)
                            Spacer()
                            Badge(text: "Selected", visible: entry == selectedWorkspace.entrySelection)
                        }
                    }
                    .buttonStyle(.borderless)
                }
                #if os(macOS)
                .alternatingRowBackgrounds()
                #endif
            } else {
                Text("No entries")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .navigationTitle(selectedWorkspace.entrySelection?.name ?? "Workspace \(selectedWorkspace.id.uuidString.prefix(6))")
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
    
    var activeWorkspace: WorkspaceInfo? { registry.workspaces.first }
    
    WorkspaceDebugInspectorView(activeWorkspace: activeWorkspace)
        .environment(registry)
}

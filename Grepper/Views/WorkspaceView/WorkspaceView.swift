// Grepper::WorkspaceView.swift - 27/08/2025

import SwiftUI

enum WorkspaceViewPage: Hashable {
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
    @State var workspaceInfo: WorkspaceInfo
    
    @State var navigationPathForwards: [WorkspaceViewPage] = []
    @State var navigationPath:         [WorkspaceViewPage] = []
    
    // MARK: - UI
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

// TODO: clean up UI situation!

// MARK: - Empty state UIs
extension WorkspaceView {
    var emptySidebar: some View {
        VStack(spacing: 12) {
            Image(systemName: "tablecells")
                .foregroundStyle(.tertiary)
                .font(.system(size: 30))
            
#if false
            Text("No entries").font(.title2)
            
            VStack {
                Button(action: {}, label: { Label("Browse", systemImage: "folder.fill") })
                    .buttonStyle(.borderedProminent)
                
                Text("or drag & drop...")
            }
            .padding(.top, 8)
#endif
        }
        .padding()
    }
    
    var emptyDetail: some View {
        VStack(spacing: 8) {
            Image(systemName: "table.furniture")
                .imageScale(.large)
                .font(.system(size: 52))
            
            Text("Your workspace is empty").font(.title)
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text("Start with")
                
                Button("File > Open entry") { GrepperCommands.OpenEntry(workspaceInfo: workspaceInfo) }
                    .buttonStyle(.link).fontWeight(.medium)
                
                Text(", or drag & drop a file / folder here...").padding(.leading, -3)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding()
    }
    
    var noSelectionDetail: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "arrow.left")
                    .imageScale(.large)
                    .font(.system(size: 32))
                
                Image(systemName: "tablecells")
                    .imageScale(.large)
                    .font(.system(size: 52))
            }
            
            Text("Select an entry to get started").font(.title)
        }
    }
}

// MARK: - Workspace UIs
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

// MARK: - Navigation
extension WorkspaceView {
    var _currentPage: Binding<WorkspaceViewPage?> {
        Binding {
            navigationPath.last ?? nil
        } set: { newValue in
            pushPage(page: newValue)
        }
    }
    var currentPage: WorkspaceViewPage? {
        get { _currentPage.wrappedValue }
        set { _currentPage.wrappedValue = newValue }
    }
    
    func pushPage(page: WorkspaceViewPage?) {
        guard let page else { return }
        guard page != navigationPath.last else { return }
        
        if let entry = page.entry { workspaceInfo.entrySelection = entry }
        
        navigationPath.append(page)
        // Put all forward navigation into path itself, behind the previous entry:
        // TODO: this may be confusing, but it is safer than usual, as it would keep history in case you mindlessly navigate back/forward. Evaluate!
        navigationPath.insert(contentsOf: navigationPathForwards, at: navigationPath.count - 1)
        navigationPathForwards.removeAll()
    }
    
    func navigateBack(to index: Int? = nil) {
        if var index                    {
            index += 1
            navigationPathForwards.append(contentsOf: navigationPath[index...]); navigationPath.removeSubrange(index...)
        } else if let it = navigationPath.popLast() {
            navigationPathForwards.append(it)
        }
    }
    func navigateForward(to index: Int? = nil) {
        if let index {
            navigationPath.append(contentsOf: navigationPathForwards[...index]); navigationPathForwards.removeSubrange(...index)
        } else if let it = navigationPathForwards.popLast() {
            navigationPath.append(it)
        }
    }
    
    var sidebarNavigationToolbarGroup: some ToolbarContent {
        // Back/Forward buttons:
        // Since we are using .enumerated() in the ForEaches, we get no automatic updates, so use .id() to re-subscribe to changes
        ToolbarItemGroup(placement: .navigation) {
            // TODO: visibility based on whether we can navigate in a particular direction
            // TODO: should probably reverse the lists for UI
            // TODO: this would animate nicely in Catalyst...
            if navigationPath.count > 1 {
                Menu {
                    ForEach(Array(navigationPath.enumerated()), id: \.offset) { index, it in
                        Button(it.friendlyName) { navigateBack(to: index) }
                    }
                } label: {
                    Label("Backward", systemImage: "chevron.left")
                } primaryAction: {
                    navigateBack()
                }
                .menuIndicator(.hidden)
                .id(navigationPath)
            }
            
            if !navigationPathForwards.isEmpty {
                Menu {
                    ForEach(Array(navigationPathForwards.enumerated()), id: \.offset) { index, it in
                        Button(it.friendlyName) { navigateForward(to: index) }
                    }
                } label: {
                    Label("Forward", systemImage: "chevron.right")
                } primaryAction: {
                    navigateForward()
                }
                .menuIndicator(.hidden)
                .id(navigationPathForwards)
            }
        }
    }
}

#Preview {
    WorkspaceView(workspaceInfo: .init())
}

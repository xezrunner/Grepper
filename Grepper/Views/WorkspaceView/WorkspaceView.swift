// Grepper::WorkspaceView.swift - 27/08/2025

import SwiftUI

enum WorkspaceViewPage: Hashable {
    case entry(entry: WorkspaceEntry)
    case settings
    
    var entry: WorkspaceEntry? {
        switch self {
            case .entry(entry: let e): return e
            default:                   return nil
        }
    }
    
    var friendlyName: String { // Mainly for back/forward navigation:
        switch self {
            case .entry(entry: let e): "\(e.name)"
            case .settings:            "Workspace settings"
        }
    }
}

struct WorkspaceView: View {
    var entries: [WorkspaceEntry] = [
        .init(), .init(), .init(), .init(), .init(), .init(),
        .init(), .init(), .init(), .init(), .init(), .init(),
        .init(), .init(), .init(), .init(), .init(), .init(),
        .init(), .init(), .init(), .init(), .init(), .init(),
    ]
    
    // MARK: - Navigation
    @State var pathForward: [WorkspaceViewPage] = []
    @State var path:        [WorkspaceViewPage] = []
    
    func navigateBack(to index: Int? = nil) {
        if var index                    {
            index += 1
            pathForward.append(contentsOf: path[index...]); path.removeSubrange(index...)
        } else if let it = path.popLast() {
            pathForward.append(it)
        }
    }
    func navigateForward(to index: Int? = nil) {
        if let index {
            path.append(contentsOf: pathForward[...index]); pathForward.removeSubrange(...index)
        } else if let it = pathForward.popLast() {
            path.append(it)
        }
    }
    
    func pushPage(page: WorkspaceViewPage?) {
        guard let page else { return }
        
        path.append(page)
        // Put all forward navigation into path itself, behind the previous entry:
        // TODO: this may be confusing, but it is safer than usual, as it would keep history in case you mindlessly navigate back/forward. Evaluate!
        path.insert(contentsOf: pathForward, at: path.count - 1)
        pathForward.removeAll()
    }
    
    var _selection: Binding<WorkspaceViewPage?> {
        Binding {
            path.last ?? nil
        } set: { newValue in
            pushPage(page: newValue)
        }
    }
    var selection: WorkspaceViewPage? {
        get { _selection.wrappedValue }
        set { _selection.wrappedValue = newValue }
    }
    
    // MARK: - UI
    var sidebar: some View {
        List(entries, selection: _selection) { entry in
            let tag = WorkspaceViewPage.entry(entry: entry)
            Text(entry.name).tag(tag)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { pushPage(page: .settings) } label: {
                    Label("Settings", systemImage: "gear")
                }
            }
            
            // Back/Forward buttons:
            // Since we are using .enumerated() in the ForEaches, we get no automatic updates, so use .id() to re-subscribe to changes
            ToolbarItemGroup(placement: .navigation) {
                // TODO: visibility based on whether we can navigate in a particular direction
                // TODO: this would animate nicely in Catalyst...
                Menu {
                    ForEach(Array(path.enumerated()), id: \.offset) { index, it in Button(it.friendlyName) { navigateBack(to: index) } }
                } label: {
                    Label("Backward", systemImage: "chevron.left")
                } primaryAction: { navigateBack() }
                .menuIndicator(.hidden)
                .id(path)
                
                Menu {
                    ForEach(Array(pathForward.enumerated()), id: \.offset) { index, it in Button(it.friendlyName) { navigateForward(to: index) } }
                } label: {
                    Label("Forward", systemImage: "chevron.right")
                } primaryAction: { navigateForward() }
                .menuIndicator(.hidden)
                .id(pathForward)
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            if let selection {
                Text("WorkspacePage! \(selection.friendlyName)")
            } else {
                Text("none")
            }
        }
    }
}

#Preview {
    WorkspaceView()
}

// Grepper::WorkspaceViewNavigation.swift - 28/08/2025
import SwiftUI

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
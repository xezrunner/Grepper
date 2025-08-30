// Grepper::WorkspaceViewNavigation.swift - 28/08/2025
import SwiftUI

@Observable class WorkspaceNavigation: Codable {
    var navigationPathForwards: [WorkspaceViewPage] = []
    var navigationPath:         [WorkspaceViewPage] = []
    
    var _currentPage: Binding<WorkspaceViewPage?> {
        Binding {
            self.navigationPath.last ?? nil
        } set: { newValue in
            self.pushPage(page: newValue)
        }
    }
    var currentPage: WorkspaceViewPage? {
        get { _currentPage.wrappedValue }
        set { _currentPage.wrappedValue = newValue }
    }
    
    func pushPage(page: WorkspaceViewPage?) {
        guard let page else { return }
        guard page != currentPage else { return }
        
        navigationPath.append(page)
        // Put all forward navigation into path itself, behind the previous entry:
        // TODO: this may be confusing, but it is safer than usual, as it would keep history in case you mindlessly navigate back/forward. Evaluate!
        navigationPath.insert(contentsOf: navigationPathForwards, at: navigationPath.count - 1)
        navigationPathForwards.removeAll()
    }
    
    var canNavigateBack:    Bool {  navigationPath.count > 1 }
    var canNavigateForward: Bool { !navigationPathForwards.isEmpty }
    
    func navigateBack(to index: Int? = nil) {
        if var index {
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
}

extension WorkspaceView {
    var sidebarNavigationToolbarGroup: some ToolbarContent {
        let navigation = workspaceInfo.navigation
        
        // Back/Forward buttons:
        // Since we are using .enumerated() in the ForEaches, we get no automatic updates, so use .id() to re-subscribe to changes
        return ToolbarItemGroup(placement: .navigation) {
            // TODO: reverse the lists for UI?
            // TODO: this could animate nicely in Catalyst...
            // FIXME: these no longer group when both are visible for some reason...
            if navigation.canNavigateBack {
                Menu {
                    ForEach(Array(navigation.navigationPath.enumerated()), id: \.offset) { index, it in
                        Button(it.friendlyName) { navigation.navigateBack(to: index) }
                    }
                } label: {
                    Label("Backward", systemImage: "chevron.left")
                } primaryAction: {
                    navigation.navigateBack()
                }
                .menuIndicator(.hidden)
                .id(navigation.navigationPath)
            }
            
            if navigation.canNavigateForward {
                Menu {
                    ForEach(Array(navigation.navigationPathForwards.enumerated()), id: \.offset) { index, it in
                        Button(it.friendlyName) { navigation.navigateForward(to: index) }
                    }
                } label: {
                    Label("Forward", systemImage: "chevron.right")
                } primaryAction: {
                    navigation.navigateForward()
                }
                .menuIndicator(.hidden)
                .id(navigation.navigationPathForwards)
            }
        }
    }
}

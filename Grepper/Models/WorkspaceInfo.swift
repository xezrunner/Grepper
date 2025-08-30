// Grepper::WorkspaceInfo.swift - 28/08/2025
import SwiftUI

@Observable final class WorkspaceInfo: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    
    var entries: [WorkspaceEntry] = []
    
    var navigation = WorkspaceNavigation()
    
    static let BUG_REPRO_FOCUSEDVALUE_IN_APP_REINIT = false
    #if BUG_REPRO_FOCUSEDVALUE_IN_APP_REINIT
    init() {
        print("WorkspaceInfo/init(): Initialized \(id.uuidString)")
    }
    #endif
    
    // MARK: - Properties:
    
    var entrySelection: WorkspaceEntry? {
        // This is linked to currentPage. Changing it will push a new page with .entry!
        get { currentPage?.entry }
        set {
            if let newValue {
                navigation.pushPage(page: .entry(entry: newValue))
            } else {
                navigation.pushPage(page: nil)
            }
        }
    }
    
    var currentPage: WorkspaceViewPage? {
        get { navigation._currentPage.wrappedValue }
        set { navigation._currentPage.wrappedValue = newValue }
    }
}

extension WorkspaceInfo {
    static var _defaultWorkspaceDebugMessageShown = false
    static var defaultWorkspace: WorkspaceInfo {
        let info = WorkspaceInfo()

        #if DEBUG
        let url = Bundle.main.url(forResource: "Grepper.debug", withExtension: "dylib")
        if let url {
            if !_defaultWorkspaceDebugMessageShown { print("Test file \"Grepper.debug.dylib\" exists - using it for DEBUG default workspace. "); _defaultWorkspaceDebugMessageShown.toggle() }
            info.addEntry(from: url)
        }
        #endif
        
        return info
    }
    
    public func addEntry(from url: URL, navigate: Bool = false) {
        do {
            if try !url.checkResourceIsReachable() {
                print("addEntry(\(url)): URL not reachable")
            }
        } catch {
            print("addEntry(\(url)): \(error)")
        }
        
        let entry = WorkspaceEntry(path: url)
        entries.append(entry)
        
        if navigate { entrySelection = entry }
    }
    
    // Misc:
    static func == (lhs: WorkspaceInfo, rhs: WorkspaceInfo) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

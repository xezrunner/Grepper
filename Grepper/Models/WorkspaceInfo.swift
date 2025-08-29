// Grepper::WorkspaceInfo.swift - 28/08/2025
import SwiftUI

@Observable class WorkspaceInfo: Codable, Hashable, Identifiable {
    var id: UUID { UUID() }
    
    var entries: [WorkspaceEntry] = []
    
    var navigationPathForwards: [WorkspaceViewPage] = []
    var navigationPath:         [WorkspaceViewPage] = []
    
    // MARK: - Properties:
    
    var entrySelection: WorkspaceEntry? {
        // This is linked to currentPage. Changing it will push a new page with .entry!
        get { currentPage?.entry }
        set { if let newValue { pushPage(page: .entry(entry: newValue)) } else { pushPage(page: nil) } }
    }
    
    var currentPage: WorkspaceViewPage? {
        get { _currentPage.wrappedValue }
        set { _currentPage.wrappedValue = newValue }
    }
}

extension WorkspaceInfo {
    static var defaultWorkspace: WorkspaceInfo {
        let info = WorkspaceInfo()

        #if DEBUG
        let url = Bundle.main.url(forResource: "Grepper.debug", withExtension: "dylib")
        if let url {
            print("Test file \"Grepper.debug.dylib\" exists - using it for DEBUG default workspace. ")
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

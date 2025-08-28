// Grepper::WorkspaceInfo.swift - 28/08/2025
import Foundation

@Observable class WorkspaceInfo: Codable, Hashable, Identifiable {
    var id: UUID { UUID() }
    
    var entries: [WorkspaceEntry] = []
    var entrySelection: WorkspaceEntry?

    static func == (lhs: WorkspaceInfo, rhs: WorkspaceInfo) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
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
    
    public func addEntry(from url: URL) {
        do {
            if try !url.checkResourceIsReachable() {
                print("addEntry(\(url)): URL not reachable")
            }
        } catch {
            print("addEntry(\(url)): \(error)")
        }
        
        let entry = WorkspaceEntry(path: url)
        entries.append(entry)
    }
}

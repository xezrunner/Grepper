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
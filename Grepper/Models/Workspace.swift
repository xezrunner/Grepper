// Grepper::Workspace.swift - 27/08/2025
import Foundation

@Observable class WorkspaceInfo: Codable, Hashable, Identifiable {
    var id: UUID { UUID() }
    
    var entries: [WorkspaceEntry] = []
    var entrySelection: WorkspaceEntry?
    
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
    
    static func == (lhs: WorkspaceInfo, rhs: WorkspaceInfo) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct WorkspaceEntry: Codable, Hashable, Identifiable {
    var id: UUID { UUID() }
    
    var path: URL
    var isDemo  = false
    
    init(path: URL? = nil) {
        self.path = path ?? URL(filePath: "Test/File \(UUID().uuidString.suffix(5)).bin")
        isDemo = path == nil
    }
    
    var name: String     { return path.lastPathComponent }
    var fullPath: String { return path.absoluteString }
}

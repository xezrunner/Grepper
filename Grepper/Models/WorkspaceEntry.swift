// Grepper::WorkspaceEntry.swift - 28/08/2025
import Foundation

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

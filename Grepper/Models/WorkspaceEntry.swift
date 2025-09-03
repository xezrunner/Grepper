// Grepper::WorkspaceEntry.swift - 28/08/2025
import Foundation

struct WorkspaceEntry: Codable, Hashable, Identifiable {
    var id: UUID { UUID() }
    
    var path: URL
    var isDemo = false
    
    fileprivate init(path: URL, isDemo: Bool = false) {
        self.path = path
        self.isDemo = isDemo
    }
    
    var name: String     { return path.lastPathComponent }
    var fullPath: String { return path.absoluteString }
}

extension WorkspaceEntry {
    static func create(from url: URL? = nil) -> WorkspaceEntry? {
        let isDemo = (url == nil)
        let url = url ?? .init(filePath: "Test/File \(UUID().uuidString.suffix(5)).bin")
        
        do {
            if try !url.checkResourceIsReachable() {
                print("addEntry(\(url)): URL not reachable")
            }
        } catch {
            print("WorkspaceEntry::create(\(url)): \(error)")
            return nil
        }
        
        let entry = WorkspaceEntry(path: url, isDemo: isDemo)
        return entry
    }
}

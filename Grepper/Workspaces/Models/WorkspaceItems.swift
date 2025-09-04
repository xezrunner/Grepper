// Grepper::WorkspaceGroupItem.swift - 05/09/2025
import Foundation

protocol WorkspaceItem: Codable, Identifiable, Hashable {
    var id: UUID { get }
    
    var displayName: String { get }
}

struct WorkspaceFile: WorkspaceItem {
    var id = UUID()
    
    var name: String?
    var url: URL
    
    var _error: String?
    
    init(name: String? = nil, url: URL) {
        self.name = name
        self.url = url
    }
    
    var displayName: String {
        if let name { name } else { url.lastPathComponent }
    }
    
    var error: String? { _error }
}

struct WorkspaceGroup: WorkspaceItem {
    var id = UUID()
    
    var name: String?
    var items: [WorkspaceEntry] = []
    
    var displayName: String { name ?? "Group \(id.uuidString)" } // TODO: nicer auto name
}

struct WorkspaceFolder: WorkspaceItem {
    var id = UUID()
    
    // TODO: when the user wants to put other files into a folder, convert to a group
    
    var url: URL
    
    var group: WorkspaceGroup?
    
    var _error: String?
    
    init(url: URL) {
        self.url = url
        
        do {
            let accessing = url.startAccessingSecurityScopedResource()
            defer { if accessing { url.stopAccessingSecurityScopedResource() } }
            
            let folderContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) // TODO: let .skipsHiddenFiles be configurable  @Settings
            let items = folderContents.compactMap({ try? WorkspaceEntry.create(from: $0) })
            
            self.group = .init(name: "📁 \(url.lastPathComponent)", items: items) // TODO: get files
        } catch {
            // FIXME: Error UI
            self._error = error.localizedDescription
            print("⚠️ WorkspaceFolder init() fail: \(error)")
        }
    }
    
    var displayName: String { group?.name ?? url.lastPathComponent } // TODO: how should we name and present folders?
    
    var isAccessible: (result: Bool, error: String?) {
        if group == nil { return (false, "Group not initialized") }
        
        return (true, nil)
    }
    
    var error: String? { _error ?? isAccessible.error }
}

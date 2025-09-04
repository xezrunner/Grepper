// Grepper::WorkspaceEntry.swift - 28/08/2025
import Foundation

protocol WorkspaceGroupItem: Codable, Identifiable, Hashable {
    var id: UUID { get }

    var displayName: String { get }
}

// TODO: factor out into files
struct WorkspaceFile: WorkspaceGroupItem {
    var id = UUID()
    
    var name: String?
    var url: URL
    
    var _error: String?
    
    fileprivate init(name: String? = nil, url: URL) {
        self.name = name
        self.url = url
    }
    
    var displayName: String {
        if let name { name } else { url.lastPathComponent }
    }
    
    var error: String? { _error }
}

struct WorkspaceGroup: WorkspaceGroupItem {
    var id = UUID()
    
    var name: String?
    var items: [WorkspaceEntry] = []
    
    var displayName: String { name ?? "Group \(id.uuidString)" } // TODO: nicer auto name
}

struct WorkspaceFolder: WorkspaceGroupItem {
    var id = UUID()
    
    // TODO: when the user wants to put other files into a folder, convert to a group
    
    var url: URL
    
    var group: WorkspaceGroup?
    
    var _error: String?
    
    fileprivate init(name: String? = nil, url: URL) {
        self.url = url
        
        do {
            let accessing = url.startAccessingSecurityScopedResource()
            defer { if accessing { url.stopAccessingSecurityScopedResource() } }
            
            let folderContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) // TODO: let .skipsHiddenFiles be configurable  @Settings
            let items = folderContents.compactMap({ try? WorkspaceEntry.create(from: $0) })
            
            self.group = .init(name: name ?? "📁 \(url.lastPathComponent)", items: items) // TODO: get files
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

enum WorkspaceEntryError: Error {
    case pathDoesNotExist
    case pathInvalidType
}

enum WorkspaceEntry: Codable, Hashable, Identifiable {
    var id: UUID { 
        switch self {
            case .file  (let it): it.id
            case .folder(let it): it.id
            case .group (let it): it.id 
        }
    }
    
    case file  (WorkspaceFile)
    case folder(WorkspaceFolder)
    case group (WorkspaceGroup)
    
    var displayName: String {
        switch self {
            case .file  (let it): it.displayName
            case .folder(let it): it.displayName
            case .group (let it): it.displayName
        }
    }

    var children: [WorkspaceEntry]? {
        switch self {
            case .folder(let it): it.group?.items
            case .group (let it): it.items
            default:              nil

        }
    }

    var typeName: String {
        switch self {
            case .file  : "file"
            case .folder: "folder"
            case .group : "group"
        }
    }
    
    static func create(from url: URL) throws -> WorkspaceEntry {
        let url = url.resolvingSymlinksInPath() // TODO: should we allow controlling this?  @Settings
        
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: url.path(percentEncoded: false), isDirectory: &isDirectory)
        
        if !exists { throw WorkspaceEntryError.pathDoesNotExist }
        
        if !isDirectory.boolValue { return WorkspaceEntry.file  (.init(url: url)) }
        else                      { return WorkspaceEntry.folder(.init(url: url)) }
    }
}

// Grepper::WorkspaceEntry.swift - 28/08/2025
import Foundation

protocol WorkspaceGroupItem: Codable, Identifiable, Hashable {
    var id: UUID { get }

    var displayName: String { get }
}
extension WorkspaceGroupItem {
    var id: UUID { UUID() }
}

// TODO: factor out into files
// TODO: do these need to be classes?  @Perf
struct WorkspaceFile: WorkspaceGroupItem {
    var name: String?
    var url: URL
    
    fileprivate init(name: String? = nil, url: URL) {
        self.name = name
        self.url = url
    }
    
    var displayName: String {
        if let name { name } else { url.lastPathComponent }
    }
    
    var isAccessible: (result: Bool, error: String?) {
        if url.hasDirectoryPath { return (false, "Workspace file \(displayName) has a path to a folder.") }
        
        do    { return (try url.checkResourceIsReachable(), nil) }
        catch { return (false, "\(error)") }
        
        return (false, nil)
    }
}

struct WorkspaceGroup: WorkspaceGroupItem {
    var name: String?
    var items: [WorkspaceEntry] = []
    
    var displayName: String {
        if let name { name } else { "Group \(id.uuidString)" } // TODO: nicer auto name
    }
}

struct WorkspaceFolder: WorkspaceGroupItem {
    // TODO: when the user wants to put other files into a folder, convert to a group
    
    var url: URL
    var group: WorkspaceGroup
    
    fileprivate init(url: URL) {
        self.url = url
        self.group = .init(name: "\(url.lastPathComponent)", items: []) // TODO: get files
    }
    
    var displayName: String { group.displayName }
    
    var isAccessible: (result: Bool, error: String?) {
        if !url.hasDirectoryPath { return (false, "Workspace folder \(displayName) has a path to a file.") }
        
        do    { return (try url.checkResourceIsReachable(), nil) }
        catch { return (false, "\(error)") }
        
        return (false, nil)
    }
}

enum WorkspaceEntryError: Error {
    case pathNotReachable
}

enum WorkspaceEntry: Codable, Hashable, Identifiable {
    var id: UUID { UUID() }
    
    case file  (WorkspaceFile)
    case group (WorkspaceGroup)
    case folder(WorkspaceFolder)
    
    var displayName: String {
        switch self {
            case .file  (let it): it.displayName
            case .group (let it): it.displayName
            case .folder(let it): it.displayName
        }
    }
    
    static func create(from url: URL) throws -> WorkspaceEntry {
        do    { if try !url.checkResourceIsReachable() { throw WorkspaceEntryError.pathNotReachable } }
        catch { throw error }
        
        if !url.hasDirectoryPath {
            return WorkspaceEntry.file(.init(url: url))
        } else {
            return WorkspaceEntry.folder(.init(url: url))
        }
    }
}

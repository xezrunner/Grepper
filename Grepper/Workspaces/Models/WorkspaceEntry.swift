// Grepper::WorkspaceEntry.swift - 28/08/2025
import Foundation

enum WorkspaceEntryError: Error {
    case pathDoesNotExist
    case pathInvalidType
}

enum WorkspaceEntry: Codable, Hashable, Identifiable {
    case file  (WorkspaceFile)
    case folder(WorkspaceFolder)
    case group (WorkspaceGroup)
    
    var id: UUID {
        switch self {
            case .file  (let it): it.id
            case .folder(let it): it.id
            case .group (let it): it.id 
        }
    }
    
    var typeName: String {
        switch self {
            case .file  : "file"
            case .folder: "folder"
            case .group : "group"
        }
    }
    
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
    
    static func create(from url: URL) throws -> WorkspaceEntry {
        let url = url.resolvingSymlinksInPath() // TODO: should we allow controlling this?  @Settings
        
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: url.path(percentEncoded: false), isDirectory: &isDirectory)
        
        if !exists { throw WorkspaceEntryError.pathDoesNotExist }
        
        if !isDirectory.boolValue { return WorkspaceEntry.file  (.init(url: url)) }
        else                      { return WorkspaceEntry.folder(.init(url: url)) }
    }
}

// Grepper::WorkspaceController.swift - 03/09/2025
import SwiftUI

@Observable class WorkspaceController: Identifiable, Hashable, Equatable {
    var id: UUID = UUID()
    
    var info: WorkspaceInfo
    
    var navigation: WorkspaceNavigation { info.navigation }
    
    init(with workspaceInfo: WorkspaceInfo) {
        self.info = workspaceInfo
    }
    
    func addEntry(_ entry: WorkspaceEntry, navigate: Bool = true) {
        info.entries.append(entry)
        if navigate { entrySelection = entry }
    }
    
    func addEntry(from url: URL, navigate: Bool = true) throws {
        do {
            let entry = try WorkspaceEntry.create(from: url)
            info.entries.append(entry)
            if navigate { entrySelection = entry }
        } catch {
            throw error
        }
    }
    
    var currentPage: WorkspaceViewPage? {
        get { navigation._currentPage.wrappedValue }
        set { navigation._currentPage.wrappedValue = newValue }
    }
    
    var entrySelection: WorkspaceEntry? {
        // This is linked to currentPage. Changing it will push a new page with .entry!
        get { currentPage?.entry }
        set {
            if let newValue {
                navigation.pushPage(page: .entry(with: newValue))
            } else {
                navigation.pushPage(page: nil)
            }
        }
    }
    
    static func == (lhs: WorkspaceController, rhs: WorkspaceController) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension WorkspaceController {
    static var _defaultWorkspaceDebugMessageShown = false
    static var defaultWorkspace: WorkspaceController {
        let info = WorkspaceInfo()
        
        let url = Bundle.main.url(forResource: "Grepper.debug", withExtension: "dylib")
        if let url {
            if !_defaultWorkspaceDebugMessageShown {
                print("Test file \"Grepper.debug.dylib\" exists - using it for DEBUG default workspace.")
                _defaultWorkspaceDebugMessageShown.toggle()
            }
            
            info.entries.append(try! WorkspaceEntry.create(from: url))
        }
        
        do {
            let entry = try WorkspaceEntry.create(from: .init(filePath: "~/Desktop"))
            info.entries.append(entry)
        } catch { }
        
        return .init(with: info)
    }
}

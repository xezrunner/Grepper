// Grepper::WorkspaceInfo.swift - 28/08/2025
import SwiftUI

@Observable class WorkspaceInfo: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    
    var entries: [WorkspaceEntry] = []
    
    var navigation = WorkspaceNavigation()
    
    static let BUG_REPRO_FOCUSEDVALUE_IN_APP_REINIT = false
    #if BUG_REPRO_FOCUSEDVALUE_IN_APP_REINIT
    init() {
        print("WorkspaceInfo/init(): Initialized \(id.uuidString)")
    }
    #endif
    
    static func == (lhs: WorkspaceInfo, rhs: WorkspaceInfo) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

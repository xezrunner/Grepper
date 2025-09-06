// Grepper::WorkspaceFile_ListView.swift - 06/09/2025
import SwiftUI

struct WorkspaceFile_ListView: View {
    var file: WorkspaceFile
    
    var body: some View {
        Text("Working with file: \(file.displayName) [\(Text(file.id.uuidString).monospaced().font(.footnote))]")
    }
}


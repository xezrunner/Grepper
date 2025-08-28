// Grepper::ContentView.swift - 27/08/2025
import SwiftUI

struct ContentView: View {
    @State var workspaceInfo: WorkspaceInfo
    
    var body: some View {
        WorkspaceView(workspaceInfo: workspaceInfo)
    }
}

#Preview {
    @Previewable @State var workspaceInfo = WorkspaceInfo()
    
    ContentView(workspaceInfo: workspaceInfo)
        .task {
            workspaceInfo.entries.append(.init(path: .init(string: "")))
        }
}

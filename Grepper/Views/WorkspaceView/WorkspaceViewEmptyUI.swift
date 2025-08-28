// Grepper::WorkspaceViewEmptyUI.swift - 28/08/2025
import SwiftUI

extension WorkspaceView {
    var emptySidebar: some View {
        VStack(spacing: 12) {
            Image(systemName: "tablecells")
                .foregroundStyle(.tertiary)
                .font(.system(size: 30))
            
#if false
            Text("No entries").font(.title2)
            
            VStack {
                Button(action: {}, label: { Label("Browse", systemImage: "folder.fill") })
                    .buttonStyle(.borderedProminent)
                
                Text("or drag & drop...")
            }
            .padding(.top, 8)
#endif
        }
        .padding()
    }

    var emptyDetail: some View {
        VStack(spacing: 8) {
            Image(systemName: "table.furniture")
                .imageScale(.large)
                .font(.system(size: 52))
            
            Text("Your workspace is empty").font(.title)
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text("Start with")
                
                Button("File > Open entry") { GrepperCommands.OpenEntry(workspaceInfo: workspaceInfo) }
                    .buttonStyle(.link).fontWeight(.medium)
                
                Text(", or drag & drop a file / folder here...").padding(.leading, -3)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding()
    }

    var noSelectionDetail: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "arrow.left")
                    .imageScale(.large)
                    .font(.system(size: 32))
                
                Image(systemName: "tablecells")
                    .imageScale(.large)
                    .font(.system(size: 52))
            }
            
            Text("Select an entry to get started").font(.title)
        }
    }
}
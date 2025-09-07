// Grepper::WorkspaceFile_ListView.swift - 06/09/2025
import SwiftUI

struct WorkspaceFile_ListView: View {
    var file: WorkspaceFile
    var grepper: Grepper { file.grepper }
    
    var body: some View {
        Text("File: \(file.displayName) [\(Text(file.id.uuidString).monospaced())]")
        Text("Grepper: \(Text(grepper.id.uuidString).monospaced()) | isProcessing: \(grepper.isProcessing.description) task: \(grepper.processingTask.debugDescription) | count: \(grepper.processedStrings.count)")
        
        HStack {
            Button("Scan!") { grepper.startProcessing() }
                .buttonStyle(.borderedProminent)
            
            Button("Cancel") { grepper.cancelProcessing() }
                .buttonStyle(.bordered)
        }
        
        if !grepper.isProcessing {
            List(grepper.processedStrings) { entry in
                HStack(spacing: 12) {
                    Text(entry.id.uuidString).monospaced()
                    Text(entry.string)
                }
            }
        } else {
            ProgressView().progressViewStyle(.circular)
        }
    }
}


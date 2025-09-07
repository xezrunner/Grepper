// Grepper::GrepperEngine.swift - 07/09/2025
import Foundation

actor GrepperEngine {
    static func scan(fileData: Data, options: GrepperOptions) async throws -> [GrepperString] {
        // Determine the amount of cores to use based on the file size. With small files, we don't really need to split
        // work across many cores, as that may actually be slower:
        let totalCores = ProcessInfo.processInfo.activeProcessorCount - 1 // TODO: should we allow using all available cores?  @Settings
        let coreCount = min(options.coresForFileSize(fileSizeInBytes: fileData.count) ?? totalCores, totalCores)
        
        let chunkSize = fileData.count / coreCount
        
        return try await withThrowingTaskGroup(of: [GrepperString].self) { group in
            var total: [GrepperString] = []
            
            for _ in 0..<coreCount {
                group.addTask {
                    try Task.checkCancellation() // @TaskCancellation
                    
                    // TEMP:
                    var list: [GrepperString] = []
                    let total = 800_000
                    for i in 0..<total {
                        let it = GrepperString(fileOffset: 0, string: "Hello, World! \(i)", interestingScore: 2)
                        list.append(it)
                    }
                    
                    try Task.checkCancellation() // @TaskCancellation
                    
                    return list
                }
            }
            
            for try await list in group {
                total.append(contentsOf: list)
            }
            
            return total
        }
    }
}

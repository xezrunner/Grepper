// Grepper::Grepper.swift - 07/09/2025
import Foundation

struct GrepperOptions: Codable, Sendable {
    // TODO: tweak these values for efficiency:
    // [File size: Cores]
    var multiCoreProcessingThresholds: [Measurement<UnitInformationStorage>:Int] = [
        Measurement(value: 128, unit: UnitInformationStorage.megabytes): 1,
        Measurement(value: 256, unit: UnitInformationStorage.megabytes): 2,
        Measurement(value: 500, unit: UnitInformationStorage.megabytes): 4,
        Measurement(value: 1,   unit: UnitInformationStorage.gigabytes): 6,
        Measurement(value: 2,   unit: UnitInformationStorage.gigabytes): 8,
    ]
    
    var minimumStringLength: Int = 3
}

extension GrepperOptions {
    // This will return the number of cores to use for a particular file size. When nil is returned, all cores should be considered.
    nonisolated func coresForFileSize(fileSizeInBytes: Int) -> Int? {
        guard multiCoreProcessingThresholds.count > 0 else { Log("no thresholds are defined - defaulting to using all cores."); return nil }
        
        let fileSizeMeasurement = Measurement(value: Double(fileSizeInBytes), unit: UnitInformationStorage.bytes)

        let thresholds = multiCoreProcessingThresholds.sorted(by: { $0.key < $1.key })
        
        if let smallest = thresholds.first, let largest = thresholds.last {
            if      fileSizeMeasurement < smallest.key { return smallest.value } // use lowest threshold
            else if fileSizeMeasurement > largest.key  { return nil }            // use all cores (not by threshold)  TODO: @Settings
        }
        
        return thresholds.last(where: { $0.key <= fileSizeMeasurement })?.value
    }
}

struct GrepperString: Codable, Identifiable, Hashable, Sendable {
    var id = UUID()
    
    let fileOffset: UInt64
    let string: String
    var interestingScore: Int = 0
}

@Observable class Grepper: Identifiable, Hashable, Codable {
    var id = UUID()
    
    let fileUrl: URL
    var options: GrepperOptions
    
    init(with url: URL, options: GrepperOptions? = nil) {
        self.fileUrl = url
        self.options = options ?? .init()
    }
    
    var processedStrings: [GrepperString] = []
    
    var processingTask: Task<Void, Error>?
    var isProcessing:   Bool { processingTask != nil } // TODO: is nulling the Task for determining in-progress state a good idea?
    
    func startProcessing() {
        if isProcessing { Log("already processing \(fileUrl)") }

        Log("processing \(fileUrl)...")
        
        processedStrings.removeAll()
        
        processingTask = Task {
            do {
                let fileData = try Data(contentsOf: fileUrl, options: .alwaysMapped)
                
                let result = try await GrepperEngine.scan(fileData: fileData, options: options)
                self.processedStrings = result
                
                Log("finished processing \(fileUrl)!")
            } catch {
                Log("error while processing: \(error)")
            }
            
            processingTask = nil
        }
    }
    
    func cancelProcessing() {
        Log("cancelling processing of \(fileUrl)...")
        
        // FIXME: this will not be correct unless we make sure we handle cancellation properly in the engine
        // @TaskCancellation
        
        processingTask?.cancel()
        processingTask = nil
    }
    
    // MARK: - Protocol comformance
    enum CodingKeys: String, CodingKey {
        case id, fileUrl, processedStrings
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fileUrl, forKey: .fileUrl)
        try container.encode(processedStrings, forKey: .processedStrings) // TODO: this might be too large?  @Performance
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let url = try container.decode(URL.self, forKey: .fileUrl)
        self.init(with: url)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.processedStrings = try container.decode([GrepperString].self, forKey: .processedStrings)
    }
    
    static func == (lhs: Grepper, rhs: Grepper) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}


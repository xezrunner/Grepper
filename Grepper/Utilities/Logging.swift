// Grepper::Logging.swift - 07/09/2025
import Foundation

// Logs as "functionName(): message"
internal nonisolated func Log(_ format: String, _ functionName: String = #function, _ args: any CVarArg...) {
    Foundation.NSLog("\(functionName): \(format)", args)
}

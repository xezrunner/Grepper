// Grepper::FilePicker.swift - 28/08/2025

import Foundation
import UniformTypeIdentifiers

#if os(iOS)
import UIKit
import ObjectiveC

final class FilePicker {
    private static var _retainKey = 0

    /// Present a file/folder picker. Completion returns the selected URL or nil.
    static func pick(allowedTypes: [UTType] = [], allowDirectories: Bool = false, completion: @escaping (URL?) -> Void) {
        var types = allowedTypes
        if allowDirectories, !types.contains(UTType.folder) {
            types.append(UTType.folder)
        }
        if types.isEmpty { types = [UTType.item] }

        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: false)
        picker.allowsMultipleSelection = false

        let coordinator = DocumentPickerCoordinator(onPick: { urls in
            completion(urls.first)
            // remove associated object after use
            objc_setAssociatedObject(picker, &(_retainKey), nil, .OBJC_ASSOCIATION_ASSIGN)
        }, onCancel: {
            completion(nil)
            objc_setAssociatedObject(picker, &(_retainKey), nil, .OBJC_ASSOCIATION_ASSIGN)
        })

        picker.delegate = coordinator
        // retain coordinator while picker is alive
        objc_setAssociatedObject(picker, &(_retainKey), coordinator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        // find top-most view controller
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              var top = scene.windows.first?.rootViewController else {
            completion(nil)
            return
        }
        while let presented = top.presentedViewController {
            top = presented
        }

        top.present(picker, animated: true, completion: nil)
    }

    private final class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: ([URL]) -> Void
        let onCancel: () -> Void

        init(onPick: @escaping ([URL]) -> Void, onCancel: @escaping () -> Void) {
            self.onPick = onPick
            self.onCancel = onCancel
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onPick(urls)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            onCancel()
        }
    }
}
#endif

#if os(macOS)
import AppKit

final class FilePicker {
    /// Present a file/folder picker. Completion returns the selected URL or nil.
    static func pick(allowedTypes: [UTType] = [], allowDirectories: Bool = false, completion: @escaping (URL?) -> Void) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = allowDirectories
        panel.allowsMultipleSelection = false
        panel.resolvesAliases = true

        if !allowedTypes.isEmpty {
            panel.allowedContentTypes = allowedTypes
        }

        panel.begin { response in
            if response == .OK {
                completion(panel.url)
            } else {
                completion(nil)
            }
        }
    }
}
#endif

// Grepper::Swizzling.swift - 30/08/2025
import Foundation
import ObjectiveC.runtime

class Swizzling {
    static func SwizzleClassMethod(from_className: String, from: Selector, to_class: AnyClass, to: Selector) {
        guard let from_class = objc_getClass(from_className) as? AnyClass,
              let method1 = class_getClassMethod(from_class, from),
              let method2 = class_getClassMethod(to_class, to) else {
            print("+ Swizzling failed for \(from.description) ")
            return
        }
        method_exchangeImplementations(method1, method2)
        
        print("+ Swizzled \(from.description) to \(to.description)")
    }
    
    static func SwizzleInstanceMethod(from_className: String, from: Selector, to_class: AnyClass, to: Selector) {
        guard let from_class = objc_getClass(from_className) as? AnyClass,
              let method1 = class_getInstanceMethod(from_class, from),
              let method2 = class_getInstanceMethod(to_class, to) else {
            print("- Swizzling failed for \(from.description) ")
            return
        }
        method_exchangeImplementations(method1, method2)
        
        print("- Swizzled \(from.description) to \(to.description)")
    }
    
    @objc class CommonTargets: NSObject {
        @objc static dynamic func returnTrue()  -> Bool { return true }
        @objc static dynamic func returnFalse() -> Bool { return false }
    }
}

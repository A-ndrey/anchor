//
//  AXWindow.swift
//  Anchor
//
//  Created by Андрей Мокрецов on 24.08.2026.
//
import ApplicationServices

struct AXWindow {
    let element: AXUIElement
    
    func title() -> String? {
        var value: CFTypeRef?
        
        guard AXUIElementCopyAttributeValue(self.element, kAXTitleAttribute as CFString, &value) == .success else {
            return nil
        }
        
        return value as? String
    }
    
    func frame() -> CGRect? {
        guard let position = self.position(), let size = self.size() else {
            return nil
        }
        
        return CGRect(origin: position, size: size)
    }
    
    func setFrame(_ frame: CGRect) -> AXError {
        let error = self.setPosition(frame.origin)
        guard error == .success else { return error }

        return self.setSize(frame.size)
    }
    
    private func position() -> CGPoint? {
        var value: CFTypeRef?
        
        guard AXUIElementCopyAttributeValue(self.element, kAXPositionAttribute as CFString, &value) == .success else {
            return nil
        }
        
        var point = CGPoint.zero
        
        guard AXValueGetValue(value as! AXValue, .cgPoint, &point) else {
            return nil
        }
        
        return point
    }
    
    private func setPosition(_ point: CGPoint) -> AXError {
        var positioin = point
        
        guard let value = AXValueCreate(.cgPoint, &positioin) else {
            return .failure
        }
        
        return AXUIElementSetAttributeValue(self.element, kAXPositionAttribute as CFString, value)
    }
    
    private func size() -> CGSize? {
        var value: CFTypeRef?
        
        guard AXUIElementCopyAttributeValue(self.element, kAXSizeAttribute as CFString, &value) == .success else {
            return nil
        }
        
        var size = CGSize.zero
        
        guard AXValueGetValue(value as! AXValue, .cgSize, &size) else {
            return nil
        }
        
        return size
    }
    
    private func setSize(_ size: CGSize) -> AXError {
        var size = size
        
        guard let value = AXValueCreate(.cgSize, &size) else {
            return .failure
        }
        
        return AXUIElementSetAttributeValue(self.element, kAXSizeAttribute as CFString, value)
    }
}

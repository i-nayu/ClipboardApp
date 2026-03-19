
//
//  WindowController.swift
//  ClipboardApp
//
//  Created by Nayu Igami on 2026/03/19.
//

import AppKit
import SwiftUI

class WindowController: NSWindowController {
    
    init(manager: Manager) {
        let contentView = ContentView(manager: manager) // あなたのUI
        
        let hosting = NSHostingView(rootView: contentView)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 250, height: 350),
            styleMask: [.titled, .fullSizeContentView, .closable],
            backing: .buffered,
            defer: false
        )
        
        window.contentView = hosting
        window.isReleasedWhenClosed = true
        
        super.init(window: window)
        
        setupWindowPosition()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupWindowPosition() {
        guard let window = self.window else { return }
        
        let mouseLocation = NSEvent.mouseLocation
        
        if let screen = NSScreen.screens.first(where: {
            NSMouseInRect(mouseLocation, $0.frame, false)
        }) {
            
            let frame = screen.visibleFrame
            let wFrame = window.frame
            
            let x = frame.midX - wFrame.width / 2
            let y = frame.midY - wFrame.height / 2
            
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }
    }
}

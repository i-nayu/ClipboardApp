//
//  ClipboardAppApp.swift
//  ClipboardApp
//
//  Created by Nayu Igami on 2026/03/19.
//

import SwiftUI

@main
struct ClipboardAppApp: App {
    @State private var manager = Manager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(manager: manager)
                .onAppear {
                    NSApp.setActivationPolicy(.accessory)
                }
        }
    }
}


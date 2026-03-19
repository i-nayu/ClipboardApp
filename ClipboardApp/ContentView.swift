//
//  ContentView.swift
//  ClipboardApp
//
//  Created by Nayu Igami on 2026/03/19.
//

import SwiftUI
import KeyboardShortcuts

struct ContentView: View {
    var manager: Manager
    @State private var showCopiedMessage = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("起動ショートカット:")
                KeyboardShortcuts.Recorder(for: .toggleClipboard)
            }
            .padding()
            
                    Text("📋 Clipboard")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.secondary.opacity(0.1))

                    List(manager.history, id: \.self) { item in
                        HStack {
                            Text(item)
                                .lineLimit(1)
                                .font(.system(.body, design: .monospaced))
                            
                            Spacer()
                            
                            // このボタンを押すと「本物のクリップボード」に書き込まれる
                            Button(action: {
                                manager.copyClipboard(text: item)
                                
                                withAnimation {
                                    showCopiedMessage = true
                                }
                                // 1.5秒後に自動で消す
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        showCopiedMessage = false
                                    }
                                }
                            }) {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain) // 余計な装飾を消してアイコンだけにする
                            .help("Copy again") // マウスホバーで説明を出す
                        }
                        .padding(.vertical, 4)
                    }
                }
        .frame(minWidth: 150, minHeight: 350)
        if showCopiedMessage {
            Text("Copied to Clipboard!")
                .font(.caption.bold())
                .foregroundColor(.white)
                .padding(8)
                .background(Capsule().fill(Color.black.opacity(0.7)))
                .padding(.bottom, 20)
                .transition(.opacity.combined(with: .scale)) // ふわっと出てくる
                .shadow(radius: 4)
        }
    }
}



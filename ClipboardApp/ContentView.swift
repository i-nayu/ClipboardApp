//
//  ContentView.swift
//  ClipboardApp
//
//  Created by Nayu Igami on 2026/03/19.
//

import SwiftUI //画面作成のため
import KeyboardShortcuts //ショートカットキー設定用ライブラリ

//UI
struct ContentView: View {
    //データ管理
    var manager: Manager
    
    //コピー完了通知用フラグ
    @State private var showCopiedMessage = false
    
    var body: some View {
        //縦に並べる（隙間なし）
        VStack(spacing: 0) {
            HStack {
                Text("起動ショートカット:")
                
                //ユーザーがキーを設定可能
                KeyboardShortcuts.Recorder(for: .toggleClipboard)
            }
            .padding()
            
                    Text("📋 Clipboard")
                        .font(.headline) //見出し
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.secondary.opacity(0.1))
                    
                    //データを一覧表示
                    //id: 文字列そのものそのものを識別子として使用
                    List(manager.history, id: \.self) { item in
                        //横並びで
                        HStack {
                            Text(item)
                                .lineLimit(1)
                                .font(.system(.body, design: .monospaced)) //等幅フォント
                            
                            Spacer() //左右を離す
                            
                            // このボタンを押すと「本物のクリップボード」に書き込まれる
                            Button(action: {
                                manager.copyClipboard(text: item)
                                
                                //コピー完了通知を表示
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
                        .padding(.vertical, 4) //行の余白
                    }
                }
        .frame(minWidth: 150, minHeight: 350)
        
        //コピー完了通知
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



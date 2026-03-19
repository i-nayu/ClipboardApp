//
//  Manager.swift
//  ClipboardApp
//
//  Created by Nayu Igami on 2026/03/19.
//

import SwiftUI
import AppKit // macOS固有の機能（NSPasteboard）を使うために必要
import KeyboardShortcuts

@Observable
class Manager {
    var history : [String] = [] //履歴を保存
    
    private var changeCount = NSPasteboard.general.changeCount //クリップボードの変更回数
    private var timer : Timer?
    
    
    init(){
        monitoring()
        setupShortcuts() // ショートカットの登録をここで呼ぶ
    }
    
    //------ショートカットの設定---------
    func setupShortcuts() {
        KeyboardShortcuts.onKeyDown(for: .toggleClipboard) { [weak self] in
            // キーが押された時の処理
            self?.showAppWindow()
        }
    }
    
    //--------ウィンドウを最前面に出す関数---------
    private var windowController: WindowController?
    
    func showAppWindow() {
        DispatchQueue.main.async {
            
            NSApp.activate(ignoringOtherApps: true)
            
            // 毎回新しく作る
            self.windowController = WindowController(manager: self)
            
            self.windowController?.showWindow(nil)
            self.windowController?.window?.makeKeyAndOrderFront(nil)
        }
    }
    
    
    //-------定期的に監視する関数--------------
    func monitoring(){
        //0.5秒ごとに関数を呼び出す
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){_ in
            self.chaeckClipboard()
        }
    }
    
    //--------クリップボードを更新する関数-----------
    private func chaeckClipboard(){
        let clipboard = NSPasteboard.general
        
        if(clipboard.changeCount != changeCount){
            changeCount = clipboard.changeCount //最新の回数を更新
            
            //文字でコピーされたものだけを取り出す
            if let newString = clipboard.string(forType: .string) {
                    
                //画面を更新
                DispatchQueue.main.async{
                    if let index = self.history.firstIndex(of: newString){
                        self.history.remove(at: index)
                    }
                    
                    //先頭に追加
                    self.history.insert(newString, at: 0)
                    
                    //30件以内
                    if self.history.count > 30 {
                        self.history.removeLast()
                    }
                }
            }
        }
    }
    
    //-------選択された項目をクリップボードにコピーする関数-------
    func copyClipboard(text: String){
        let clipboard = NSPasteboard.general
        
        clipboard.clearContents() //一度空にする
        clipboard.setString(text, forType: .string) //文字をセット
        
        print("Copied to system clipboard: \(text)")
        
        // コピーしたら自分を隠す（フルスクリーン画面から退場する）
        NSApp.hide(nil)
    }
}

// Manager.swift の一番下（ } の外側）に貼り付けてください
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleClipboard = Self("toggleClipboard")
}

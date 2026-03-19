//
//  Manager.swift
//  ClipboardApp
//
//  Created by Nayu Igami on 2026/03/19.
//

import SwiftUI
import AppKit // macOS固有の機能（NSPasteboard）を使うために必要
import KeyboardShortcuts

@Observable //値が変わると更新
class Manager {
    var history : [String] = [] //履歴を保存
    
    private var changeCount = NSPasteboard.general.changeCount //クリップボードの変更回数
    private var timer : Timer?
    
    
    init(){
        monitoring()
        setupShortcuts() // ショートカットの登録をここで呼ぶ
    }
    
    //------ショートカットの設定を行う関数---------
    func setupShortcuts() {
        KeyboardShortcuts.onKeyDown(for: .toggleClipboard) { [weak self] in
            // キーが押された時の処理
            self?.showAppWindow() //ウィンドウを表示する関数
        }
    }
    
    private var windowController: WindowController?
    
    //--------ウィンドウを表示する関数---------
    func showAppWindow() {
        //UIに関する操作
        DispatchQueue.main.async {
            
            //毎回新しく作成
            NSApp.activate(ignoringOtherApps: true) //このアプリに操作権を移す
            self.windowController = WindowController(manager: self)
            self.windowController?.showWindow(nil) //ディスプレイに表示（空でない場合のみ）
            self.windowController?.window?.makeKeyAndOrderFront(nil) //いちばん手前に表示し、操作可能に
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
        let clipboard = NSPasteboard.general //本体のクリップボードにアクセスするため
        
        if(clipboard.changeCount != changeCount){
            changeCount = clipboard.changeCount //最新の回数を更新
            
            //文字だけを取り出す
            if let newString = clipboard.string(forType: .string) {
                    
                //画面を更新
                DispatchQueue.main.async{
                    //重複しているものは古い方を削除
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
        
        clipboard.clearContents() //本物のクリップボードを空に
        clipboard.setString(text, forType: .string) //文字をセット
        
        print("Copied to system clipboard: \(text)")
        
        NSApp.hide(nil) //ウィンドウを消す
    }
}

//ショートカットキーの名前定義
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleClipboard = Self("toggleClipboard")
}

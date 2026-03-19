//
//  ClipboardAppApp.swift
//  ClipboardApp
//
//  Created by Nayu Igami on 2026/03/19.
//

import SwiftUI  //画面作成のため

@main
struct ClipboardAppApp: App {
    //Magerクラスのインスタンス作成
    @State private var manager = Manager() //値が変わったら更新
    
    //画面構造
    var body: some Scene {
        //ウィンドウ作成
        WindowGroup {
            ContentView(manager: manager) //メイン画面表示
            
                //画面が表示された時に実行される処理
                .onAppear {
                    //アプリの表示方法を設定
                    NSApp.setActivationPolicy(.accessory) //Dockに表示しない
                }
        }
    }
}


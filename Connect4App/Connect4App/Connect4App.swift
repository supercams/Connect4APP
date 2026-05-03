//
//  Connect4AppApp.swift
//  Connect4App
//
//  Created by Parchment on 2/23/26.
//

import SwiftUI
import GoogleMobileAds

@main
struct Connect4App: App {

    init() {
        MobileAds.shared.start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

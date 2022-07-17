//
//  week3_indianPokerApp.swift
//  week3_indianPoker
//
//  Created by Chanwoo on 2022/07/17.
//

import SwiftUI

@main
struct week3_indianPokerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

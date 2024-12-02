//
//  LooseEndsApp.swift
//  LooseEnds
//
//  Created by Javier Heisecke on 2024-11-28.
//

import SwiftUI

@main
struct LooseEndsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

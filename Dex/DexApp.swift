//
//  DexApp.swift
//  Dex
//
//  Created by Ryan Davi Oliveira de Meneses on 22/08/25.
//

import SwiftUI

@main
struct DexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

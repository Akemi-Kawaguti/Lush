//
//  LushApp.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 11/09/26.
//


import SwiftUI
import SwiftData

@main
struct LushApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
                    UserModel.self,
                    AnalysisModel.self,
                    SizeSpecifications.self,
                    ClothesModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}

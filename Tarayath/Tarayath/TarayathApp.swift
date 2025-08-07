//
//  TarayathApp.swift
//  Tarayath
//
//  Created by Yousef99 on 10/02/1447 AH.
//

import SwiftUI

@main
struct TarayathApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        // Configure navigation bar appearance for consistent styling
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color.primaryText),
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        appearance.shadowColor = UIColor(Color.primaryBackground.opacity(0.1))
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(appState)
                .preferredColorScheme(.light) // Force light mode initially, can be removed later
        }
    }
}

struct MainContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            switch appState.currentScreen {
            case .splash:
                SplashScreen()
            case .collectInfo:
                CollectInfoScreen()
            case .dashboard:
                DashboardScreen()
            case .savingsPlan:
                SavingsPlanScreen()
            case .purchaseDecision:
                PurchaseDecisionScreen()
            case .profile:
                ProfileScreen()
            }
        }
        .frame(maxWidth: 428)
        .background(Color.cardBackground)
        .onAppear {
            appState.loadInitialData()
        }
    }
}

#Preview {
    MainContentView()
        .environmentObject(AppState())
}
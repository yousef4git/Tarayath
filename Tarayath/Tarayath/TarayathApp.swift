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
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(appState)
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
        .frame(maxWidth: 428, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(.keyboard)
        .background(Color.dynamicBackground)
        .onAppear {
            appState.loadInitialData()
        }
    }
}

#Preview {
    MainContentView()
        .environmentObject(AppState())
}

import SwiftUI

@main
struct TarayathApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

struct ContentView: View {
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
        .background(Color.appBackground)
        .onAppear {
            appState.loadInitialData()
        }
    }
}
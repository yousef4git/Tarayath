import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var currentScreen: Screen = .splash
    @Published var userData: UserData?
    @Published var savingsPlans: [SavingsPlan] = []
    @Published var purchaseDecisions: [PurchaseDecision] = []
    @Published var budgetBuckets: BudgetBuckets = BudgetBuckets()
    @Published var isLoading: Bool = true
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadInitialData()
    }
    
    func loadInitialData() {
        DispatchQueue.main.async {
            self.isLoading = true
            
            // Load user data
            if let userData = self.loadUserData() {
                self.userData = userData
            }
            
            // Load savings plans
            self.savingsPlans = self.loadSavingsPlans()
            
            // Load purchase decisions
            self.purchaseDecisions = self.loadPurchaseDecisions()
            
            // Load budget buckets
            self.budgetBuckets = self.loadBudgetBuckets()
            
            self.isLoading = false
        }
    }
    
    func navigateToScreen(_ screen: Screen) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = screen
        }
    }
    
    func updateUserData(_ userData: UserData) {
        self.userData = userData
        saveUserData(userData)
    }
    
    func addSavingsPlan(_ plan: SavingsPlan) {
        savingsPlans.append(plan)
        saveSavingsPlans()
    }
    
    func updateBudgetBuckets(_ buckets: BudgetBuckets) {
        budgetBuckets = buckets
        saveBudgetBuckets(buckets)
    }
    
    func addPurchaseDecision(_ decision: PurchaseDecision) {
        purchaseDecisions.append(decision)
        savePurchaseDecisions()
        
        // Update user balance if purchased
        if decision.purchased, var user = userData {
            user.currentBalance -= decision.price
            updateUserData(user)
        }
    }
    
    func resetApp() {
        userData = nil
        savingsPlans = []
        purchaseDecisions = []
        budgetBuckets = BudgetBuckets()
        
        userDefaults.removeObject(forKey: "userData")
        userDefaults.removeObject(forKey: "savingsPlans")
        userDefaults.removeObject(forKey: "purchaseDecisions")
        userDefaults.removeObject(forKey: "budgetBuckets")
        
        navigateToScreen(.splash)
    }
    
    // MARK: - Private Methods
    
    private func loadUserData() -> UserData? {
        guard let data = userDefaults.data(forKey: "userData") else { return nil }
        return try? JSONDecoder().decode(UserData.self, from: data)
    }
    
    private func saveUserData(_ userData: UserData) {
        if let data = try? JSONEncoder().encode(userData) {
            userDefaults.set(data, forKey: "userData")
        }
    }
    
    private func loadSavingsPlans() -> [SavingsPlan] {
        guard let data = userDefaults.data(forKey: "savingsPlans") else { return [] }
        return (try? JSONDecoder().decode([SavingsPlan].self, from: data)) ?? []
    }
    
    private func saveSavingsPlans() {
        if let data = try? JSONEncoder().encode(savingsPlans) {
            userDefaults.set(data, forKey: "savingsPlans")
        }
    }
    
    private func loadPurchaseDecisions() -> [PurchaseDecision] {
        guard let data = userDefaults.data(forKey: "purchaseDecisions") else { return [] }
        return (try? JSONDecoder().decode([PurchaseDecision].self, from: data)) ?? []
    }
    
    private func savePurchaseDecisions() {
        if let data = try? JSONEncoder().encode(purchaseDecisions) {
            userDefaults.set(data, forKey: "purchaseDecisions")
        }
    }
    
    private func loadBudgetBuckets() -> BudgetBuckets {
        guard let data = userDefaults.data(forKey: "budgetBuckets") else { return BudgetBuckets() }
        return (try? JSONDecoder().decode(BudgetBuckets.self, from: data)) ?? BudgetBuckets()
    }
    
    private func saveBudgetBuckets(_ buckets: BudgetBuckets) {
        if let data = try? JSONEncoder().encode(buckets) {
            userDefaults.set(data, forKey: "budgetBuckets")
        }
    }
} 
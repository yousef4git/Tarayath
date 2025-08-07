import Foundation

enum Screen: CaseIterable {
    case splash
    case collectInfo
    case dashboard
    case savingsPlan
    case purchaseDecision
    case profile
}

enum Currency: String, CaseIterable, Codable {
    case SAR = "SAR"
    case USD = "USD"
    
    var symbol: String {
        switch self {
        case .SAR: return "ر.س"
        case .USD: return "$"
        }
    }
}

enum AppLanguage: String, CaseIterable, Codable {
    case english = "en"
    case arabic = "ar"
    
    var isRTL: Bool {
        return self == .arabic
    }
}

struct UserData: Codable {
    var fullName: String
    var monthlyIncome: Double
    var monthlyObligations: Double
    var currentBalance: Double
    var currency: Currency
    var language: AppLanguage
    
    init() {
        self.fullName = ""
        self.monthlyIncome = 0  // This will be set from string input
        self.monthlyObligations = 0  // This will be set from string input
        self.currentBalance = 0  // This will be set from string input
        self.currency = .SAR
        self.language = .english
    }
}

struct BudgetBuckets: Codable {
    var needs: Int
    var wants: Int
    var savings: Int
    
    init() {
        self.needs = 50
        self.wants = 30
        self.savings = 20
    }
}

struct SavingsPlan: Codable, Identifiable {
    let id: String
    var goal: String
    var targetAmount: Double
    var monthlyAmount: Double
    var duration: Int
    var currentSavings: Double
    var isCompleted: Bool
    var createdAt: Date
    
    init(goal: String, targetAmount: Double, monthlyAmount: Double, duration: Int) {
        self.id = UUID().uuidString
        self.goal = goal
        self.targetAmount = targetAmount
        self.monthlyAmount = monthlyAmount
        self.duration = duration
        self.currentSavings = 0
        self.isCompleted = false
        self.createdAt = Date()
    }
}

struct PurchaseDecision: Codable, Identifiable {
    let id: String
    var item: String
    var price: Double
    var decision: String
    var reasoning: [String: String]
    var answers: [String: String]
    var purchased: Bool
    var purchasedDate: Date?
    var createdAt: Date
    
    init(item: String, price: Double, decision: String, reasoning: [String: String], answers: [String: String], purchased: Bool) {
        self.id = UUID().uuidString
        self.item = item
        self.price = price
        self.decision = decision
        self.reasoning = reasoning
        self.answers = answers
        self.purchased = purchased
        self.purchasedDate = purchased ? Date() : nil
        self.createdAt = Date()
    }
}
import SwiftUI

struct PurchaseDecisionScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var showingNewDecisionSheet = false
    
    private var userData: UserData {
        appState.userData ?? UserData()
    }
    
    private var texts: [AppLanguage: DecisionTexts] = [
        .english: DecisionTexts(
            title: "Decision Helper",
            backToDashboard: "Back to Dashboard",
            makeNewDecision: "Get Decision Help",
            recentDecisions: "Recent Decisions",
            noDecisions: "No decisions made yet",
            createFirstDecision: "Get help making your first smart purchase decision!",
            recommended: "Recommended",
            notRecommended: "Not Recommended",
            wait: "Wait",
            purchased: "Purchased",
            declined: "Declined",
            price: "Price",
            decision: "Decision",
            reasoning: "Reasoning"
        ),
        .arabic: DecisionTexts(
            title: "مساعد القرارات",
            backToDashboard: "العودة للوحة الرئيسية",
            makeNewDecision: "احصل على مساعدة القرار",
            recentDecisions: "القرارات الأخيرة",
            noDecisions: "لم يتم اتخاذ قرارات بعد",
            createFirstDecision: "احصل على المساعدة في اتخاذ قرار الشراء الذكي الأول!",
            recommended: "موصى به",
            notRecommended: "غير موصى به",
            wait: "انتظر",
            purchased: "تم الشراء",
            declined: "تم الرفض",
            price: "السعر",
            decision: "القرار",
            reasoning: "السبب"
        )
    ]
    
    struct DecisionTexts {
        let title: String
        let backToDashboard: String
        let makeNewDecision: String
        let recentDecisions: String
        let noDecisions: String
        let createFirstDecision: String
        let recommended: String
        let notRecommended: String
        let wait: String
        let purchased: String
        let declined: String
        let price: String
        let decision: String
        let reasoning: String
    }
    
    private var t: DecisionTexts {
        texts[userData.language] ?? texts[.english]!
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.mediumGreen.opacity(0.05)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                        .padding(.top, geometry.safeAreaInsets.top)
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 24) {
                            // Make New Decision Button
                            makeNewDecisionButton
                            
                            // Recent Decisions Section
                            if !appState.purchaseDecisions.isEmpty {
                                recentDecisionsSection
                            } else {
                                emptyStateView
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewDecisionSheet) {
            NewDecisionHelperFlow(
                userData: userData,
                savingsPlans: appState.savingsPlans,
                onSave: { decision in
                    appState.addPurchaseDecision(decision)
                    showingNewDecisionSheet = false
                },
                onCancel: {
                    showingNewDecisionSheet = false
                }
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                appState.navigateToScreen(.dashboard)
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text(t.backToDashboard)
                        .font(AppTypography.callout)
                }
                .foregroundColor(.darkGreen)
            }
            
            Spacer()
            
            Text(t.title)
                .font(AppTypography.title)
                .foregroundColor(.darkGreen)
            
            Spacer()
            
            // Invisible button for balance
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text(t.backToDashboard)
                        .font(AppTypography.callout)
                }
                .foregroundColor(.clear)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.9))
    }
    
    private var makeNewDecisionButton: some View {
        Button(action: {
            showingNewDecisionSheet = true
        }) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 20, weight: .medium))
                Text(t.makeNewDecision)
                    .font(AppTypography.button)
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.creamWhite)
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryButtonStyle())
    }
    
    private var recentDecisionsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(t.recentDecisions)
                .font(AppTypography.title3)
                .foregroundColor(.darkGreen)
                .padding(.bottom, 8)
            
            ForEach(appState.purchaseDecisions.reversed()) { decision in
                PurchaseDecisionCard(decision: decision, texts: t, userData: userData)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 64, weight: .light))
                .foregroundColor(.mediumGreen.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(t.noDecisions)
                    .font(AppTypography.title3)
                    .foregroundColor(.darkGreen)
                
                Text(t.createFirstDecision)
                    .font(AppTypography.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct PurchaseDecisionCard: View {
    let decision: PurchaseDecision
    let texts: PurchaseDecisionScreen.DecisionTexts
    let userData: UserData
    
    private var decisionColor: Color {
        switch decision.decision.lowercased() {
        case "recommended", "yes":
            return .green
        case "not recommended", "no":
            return .red
        case "wait", "reconsider":
            return .orange
        default:
            return .gray
        }
    }
    
    private var decisionIcon: String {
        switch decision.decision.lowercased() {
        case "recommended", "yes":
            return "checkmark.circle.fill"
        case "not recommended", "no":
            return "xmark.circle.fill"
        case "wait", "reconsider":
            return "clock.circle.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(decision.item)
                        .font(AppTypography.title3)
                        .foregroundColor(.darkGreen)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(CurrencyFormatter.format(decision.price, currency: userData.currency))
                        .font(AppTypography.callout)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                }
                
                Spacer(minLength: 12)
                
                HStack(spacing: 10) {
                    Image(systemName: decisionIcon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(decisionColor)
                    
                    Text(decision.decision)
                        .font(AppTypography.callout)
                        .foregroundColor(decisionColor)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            .frame(minHeight: 50)
            
            // Status
            if decision.purchased {
                HStack {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.green)
                    Text(texts.purchased)
                        .font(AppTypography.caption)
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                }
            }
            
            // Reasoning
            if let firstReason = decision.reasoning.values.first, !firstReason.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text(texts.reasoning)
                        .font(AppTypography.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                    Text(firstReason)
                        .font(AppTypography.caption)
                        .foregroundColor(.darkGreen)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Date
            HStack {
                Spacer()
                Text(decision.createdAt, style: .date)
                    .font(AppTypography.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Purchase Decision Enums
enum PurchaseFeeling: String, CaseIterable {
    case reallyExcited = "really_excited"
    case prettyHappy = "pretty_happy"
    case itsOkay = "its_okay"
    case unsure = "unsure"
    
    var emoji: String {
        switch self {
        case .reallyExcited: return "🤩"
        case .prettyHappy: return "🙂"
        case .itsOkay: return "😐"
        case .unsure: return "🤔"
        }
    }
    
    var text: String {
        switch self {
        case .reallyExcited: return "Really Excited!"
        case .prettyHappy: return "Pretty Happy"
        case .itsOkay: return "It's Okay"
        case .unsure: return "Unsure..."
        }
    }
}

enum PurchaseUrgency: String, CaseIterable {
    case rightNow = "right_now"
    case thisMonth = "this_month"
    case sometimeSoon = "sometime_soon"
    case noRush = "no_rush"
    
    var emoji: String {
        switch self {
        case .rightNow: return "⚡️"
        case .thisMonth: return "📅"
        case .sometimeSoon: return "⏳"
        case .noRush: return "🌱"
        }
    }
    
    var text: String {
        switch self {
        case .rightNow: return "Right now!"
        case .thisMonth: return "This month"
        case .sometimeSoon: return "Sometime soon"
        case .noRush: return "No rush"
        }
    }
}

enum PurchaseHelpType: String, CaseIterable {
    case essentialForWork = "essential_for_work"
    case improvesLife = "improves_life"
    case niceToHave = "nice_to_have"
    case justWantIt = "just_want_it"
    
    var emoji: String {
        switch self {
        case .essentialForWork: return "🧳"
        case .improvesLife: return "🌟"
        case .niceToHave: return "👍"
        case .justWantIt: return "👍"
        }
    }
    
    var text: String {
        switch self {
        case .essentialForWork: return "Essential for work/study"
        case .improvesLife: return "Improves my life"
        case .niceToHave: return "Nice to have"
        case .justWantIt: return "Just want it"
        }
    }
}

struct NewPurchaseDecisionView: View {
    let userData: UserData
    let savingsPlans: [SavingsPlan]
    let onSave: (PurchaseDecision) -> Void
    let onCancel: () -> Void
    
    @State private var itemName = ""
    @State private var price = ""
    @State private var feeling: PurchaseFeeling = .reallyExcited
    @State private var urgency: PurchaseUrgency = .thisMonth
    @State private var helpType: PurchaseHelpType = .essentialForWork
    @State private var currentStep = 1
    
    private var totalSteps = 4
    
    // Explicit initializer
    init(userData: UserData, savingsPlans: [SavingsPlan], onSave: @escaping (PurchaseDecision) -> Void, onCancel: @escaping () -> Void) {
        self.userData = userData
        self.savingsPlans = savingsPlans
        self.onSave = onSave
        self.onCancel = onCancel
    }
    
    private var isStep1Valid: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        Double(price) ?? 0 > 0
    }
    
    private var currentBalance: Double {
        userData.currentBalance
    }
    
    private var afterObligationsAndSavings: Double {
        let totalSavings = savingsPlans.filter { !$0.isCompleted }.reduce(0) { $0 + $1.monthlyAmount }
        return currentBalance - userData.monthlyObligations - totalSavings
    }
    
    private var afterPurchase: Double {
        afterObligationsAndSavings - (Double(price) ?? 0)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress Bar
                progressBar
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        switch currentStep {
                        case 1:
                            purchaseDetailsStep
                        case 2:
                            financialImpactStep
                        case 3:
                            decisionCheckStep
                        case 4:
                            recommendationStep
                        default:
                            purchaseDetailsStep
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                
                // Navigation Buttons
                navigationButtons
            }
            .navigationTitle("Smart Purchase Decision")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
            }
        }
    }
    
    private var progressBar: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                Rectangle()
                    .fill(step <= currentStep ? Color.mediumGreen : Color.gray.opacity(0.3))
                    .frame(height: 4)
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private var purchaseDetailsStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Purchase Details")
                .font(AppTypography.largeTitle)
                .foregroundColor(.darkGreen)
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("What do you want to buy?")
                        .font(AppTypography.callout)
                        .foregroundColor(.darkGreen)
                        .fontWeight(.medium)
                    TextField("Enter item name", text: $itemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 50)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("How much does it cost?")
                        .font(AppTypography.callout)
                        .foregroundColor(.darkGreen)
                        .fontWeight(.medium)
                    TextField("Enter price", text: $price)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .frame(minHeight: 50)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            Spacer()
        }
    }
    
    private var financialImpactStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Financial Impact")
                .font(AppTypography.largeTitle)
                .foregroundColor(.darkGreen)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Current Financial Situation")
                    .font(AppTypography.title3)
                    .foregroundColor(.darkGreen)
                    .fontWeight(.semibold)
                    .padding(.bottom, 8)
                
                VStack(spacing: 16) {
                    InfoRow(label: "Current Balance", value: CurrencyFormatter.format(currentBalance, currency: userData.currency))
                    InfoRow(label: "After Obligations & Savings", value: CurrencyFormatter.format(afterObligationsAndSavings, currency: userData.currency))
                    InfoRow(label: "After This Purchase", value: CurrencyFormatter.format(afterPurchase, currency: userData.currency))
                }
                
                // Warning if balance goes negative
                if afterPurchase < 0 {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Warning: This purchase would exceed your available funds!")
                            .font(AppTypography.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(16)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            Spacer()
        }
    }
    
    private var decisionCheckStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Decision Check")
                .font(AppTypography.largeTitle)
                .foregroundColor(.darkGreen)
            
            VStack(alignment: .leading, spacing: 24) {
                // Feeling Question
                VStack(alignment: .leading, spacing: 12) {
                    Text("How do you feel about this purchase?")
                        .font(AppTypography.title3)
                        .foregroundColor(.darkGreen)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(PurchaseFeeling.allCases, id: \.self) { feelingOption in
                            Button(action: {
                                feeling = feelingOption
                            }) {
                                HStack {
                                    Text(feelingOption.emoji)
                                        .font(.title2)
                                    Text(feelingOption.text)
                                        .font(AppTypography.callout)
                                    Spacer()
                                }
                                .padding(12)
                                .background(feeling == feelingOption ? Color.mediumGreen.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(feeling == feelingOption ? Color.mediumGreen : Color.clear, lineWidth: 2)
                                )
                            }
                            .foregroundColor(.darkGreen)
                        }
                    }
                }
                
                // Urgency Question
                VStack(alignment: .leading, spacing: 12) {
                    Text("When do you need this?")
                        .font(AppTypography.title3)
                        .foregroundColor(.darkGreen)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(PurchaseUrgency.allCases, id: \.self) { urgencyOption in
                            Button(action: {
                                urgency = urgencyOption
                            }) {
                                HStack {
                                    Text(urgencyOption.emoji)
                                        .font(.title2)
                                    Text(urgencyOption.text)
                                        .font(AppTypography.callout)
                                    Spacer()
                                }
                                .padding(12)
                                .background(urgency == urgencyOption ? Color.mediumGreen.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(urgency == urgencyOption ? Color.mediumGreen : Color.clear, lineWidth: 2)
                                )
                            }
                            .foregroundColor(.darkGreen)
                        }
                    }
                }
                
                // Help Type Question
                VStack(alignment: .leading, spacing: 12) {
                    Text("How will this help you?")
                        .font(AppTypography.title3)
                        .foregroundColor(.darkGreen)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(PurchaseHelpType.allCases, id: \.self) { helpOption in
                            Button(action: {
                                helpType = helpOption
                            }) {
                                HStack {
                                    Text(helpOption.emoji)
                                        .font(.title2)
                                    Text(helpOption.text)
                                        .font(AppTypography.callout)
                                    Spacer()
                                }
                                .padding(12)
                                .background(helpType == helpOption ? Color.mediumGreen.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(helpType == helpOption ? Color.mediumGreen : Color.clear, lineWidth: 2)
                                )
                            }
                            .foregroundColor(.darkGreen)
                        }
                    }
                }
            }
            .modifier(AppCardStyle())
            
            Spacer()
        }
    }
    
    private var recommendationStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Our Recommendation")
                .font(AppTypography.largeTitle)
                .foregroundColor(.darkGreen)
            
            VStack(spacing: 20) {
                // Decision Result
                decisionResultCard
                
                // Analysis Cards
                analysisCards
            }
            
            Spacer()
        }
    }
    
    private var decisionResultCard: some View {
        let decision = calculateDecision()
        
        return VStack(spacing: 16) {
            HStack {
                Text(decision.icon)
                    .font(.system(size: 48))
                VStack(alignment: .leading, spacing: 4) {
                    Text(decision.title)
                        .font(AppTypography.title)
                        .foregroundColor(decision.color)
                        .fontWeight(.bold)
                    Text(decision.message)
                        .font(AppTypography.body)
                        .foregroundColor(.darkGreen)
                }
                Spacer()
            }
        }
        .padding(20)
        .background(decision.color.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(decision.color.opacity(0.3), lineWidth: 2)
        )
    }
    
    private var analysisCards: some View {
        let analysis = analyzeDecision()
        
        return VStack(spacing: 12) {
            ForEach(Array(analysis.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top, spacing: 12) {
                    Text(item.icon)
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(AppTypography.callout)
                            .foregroundColor(.darkGreen)
                            .fontWeight(.medium)
                        Text(item.description)
                            .font(AppTypography.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
        }
    }
    
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if currentStep > 1 {
                Button("Previous") {
                    withAnimation {
                        currentStep -= 1
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            
            Spacer()
            
            if currentStep < totalSteps {
                Button("Next") {
                    withAnimation {
                        currentStep += 1
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(currentStep == 1 && !isStep1Valid)
            } else {
                Button("Save Decision") {
                    saveDecision()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private func calculateDecision() -> (icon: String, title: String, message: String, color: Color) {
        let priceValue = Double(price) ?? 0
        
        // Negative factors
        var negativeScore = 0
        
        // Financial impact
        if afterPurchase < 0 {
            negativeScore += 3 // Major issue
        } else if afterPurchase < currentBalance * 0.1 {
            negativeScore += 2 // Risky
        }
        
        // Emotional factors
        if feeling == .unsure {
            negativeScore += 2
        } else if feeling == .itsOkay {
            negativeScore += 1
        }
        
        // Urgency factors
        if urgency == .rightNow {
            negativeScore += 1 // Rushed decisions are risky
        }
        
        // Need vs want
        if helpType == .justWantIt {
            negativeScore += 2
        } else if helpType == .niceToHave {
            negativeScore += 1
        }
        
        // High price relative to income
        if priceValue > userData.monthlyIncome * 0.5 {
            negativeScore += 2
        }
        
        // Make decision
        if negativeScore >= 4 {
            return ("❌", "Not Recommended", "This purchase might not be the best choice right now.", .red)
        } else if negativeScore >= 2 {
            return ("⚠️", "Wait or Reconsider", "Consider waiting or looking for alternatives.", .orange)
        } else {
            return ("✅", "Go Ahead", "This seems like a reasonable purchase!", .green)
        }
    }
    
    private func analyzeDecision() -> [(icon: String, title: String, description: String)] {
        var analysis: [(icon: String, title: String, description: String)] = []
        
        // Financial Analysis
        if afterPurchase >= 0 {
            analysis.append(("💰", "Financial Impact", "Your remaining balance will be \(CurrencyFormatter.format(afterPurchase, currency: userData.currency))."))
        } else {
            analysis.append(("⚠️", "Financial Risk", "This purchase exceeds your available funds."))
        }
        
        // Emotional Analysis
        let emotionalAnalysis: String
        switch feeling {
        case .reallyExcited:
            emotionalAnalysis = "You're very excited about this purchase, which is positive."
        case .prettyHappy:
            emotionalAnalysis = "You feel good about this purchase."
        case .itsOkay:
            emotionalAnalysis = "You seem neutral about this purchase."
        case .unsure:
            emotionalAnalysis = "Your uncertainty suggests you might want to wait."
        }
        analysis.append(("🎭", "Emotional Check", emotionalAnalysis))
        
        // Need Analysis
        let needAnalysis: String
        switch helpType {
        case .essentialForWork:
            needAnalysis = "This appears to be essential for your work or studies."
        case .improvesLife:
            needAnalysis = "This could meaningfully improve your quality of life."
        case .niceToHave:
            needAnalysis = "This is nice to have but not essential."
        case .justWantIt:
            needAnalysis = "This is primarily based on wanting rather than needing."
        }
        analysis.append(("🎯", "Need Assessment", needAnalysis))
        
        // Timing Analysis
        let timingAnalysis: String
        switch urgency {
        case .rightNow:
            timingAnalysis = "Immediate purchases can sometimes be rushed decisions."
        case .thisMonth:
            timingAnalysis = "A month timeframe allows for some consideration."
        case .sometimeSoon:
            timingAnalysis = "No immediate rush gives you time to plan."
        case .noRush:
            timingAnalysis = "No urgency means you can wait for the right time."
        }
        analysis.append(("⏰", "Timing Factor", timingAnalysis))
        
        return analysis
    }
    
    private func saveDecision() {
        let decisionResult = calculateDecision()
        let analysis = analyzeDecision()
        
        let reasoning = analysis.reduce(into: [String: String]()) { result, item in
            result[item.title] = item.description
        }
        
        let answers = [
            "feeling": feeling.rawValue,
            "urgency": urgency.rawValue,
            "helpType": helpType.rawValue
        ]
        
        let decision = PurchaseDecision(
            item: itemName.trimmingCharacters(in: .whitespacesAndNewlines),
            price: Double(price) ?? 0,
            decision: decisionResult.title,
            reasoning: reasoning,
            answers: answers,
            purchased: false
        )
        
        onSave(decision)
    }
}

// MARK: - New Decision Helper Flow

struct NewDecisionHelperFlow: View {
    let userData: UserData
    let savingsPlans: [SavingsPlan]
    let onSave: (PurchaseDecision) -> Void
    let onCancel: () -> Void
    
    @State private var currentStep = 1
    @State private var decision = PurchaseDecision(item: "", price: 0)
    
    var body: some View {
        NavigationView {
            VStack {
                // Progress indicator
                ProgressView(value: Double(currentStep), total: 4.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .mediumGreen))
                    .padding(.horizontal)
                
                Text("Step \(currentStep) of 4")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                // Step content
                Group {
                    switch currentStep {
                    case 1:
                        ItemPriceStep(decision: $decision)
                    case 2:
                        QuestionnaireStep(decision: $decision)
                    case 3:
                        EmojiStep(decision: $decision)
                    case 4:
                        ResultStep(decision: $decision, userData: userData, savingsPlans: savingsPlans)
                    default:
                        EmptyView()
                    }
                }
                
                Spacer()
                
                // Navigation buttons
                HStack {
                    if currentStep > 1 {
                        Button("Back") {
                            currentStep -= 1
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    
                    Spacer()
                    
                    if currentStep < 4 {
                        Button("Next") {
                            if currentStep == 3 {
                                // Evaluate decision before showing results
                                DecisionEngine.evaluate(decision: &decision, userData: userData, savingsPlans: savingsPlans)
                            }
                            currentStep += 1
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(!canProceed)
                    } else {
                        Button("Save Decision") {
                            onSave(decision)
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Decision Helper")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
            }
        }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 1:
            return !decision.item.isEmpty && decision.price > 0
        case 2:
            return !decision.whyReason.isEmpty && !decision.wantedSince.isEmpty && !decision.urgency.isEmpty
        case 3:
            return !decision.emojiFeel.isEmpty && !decision.emojiWhen.isEmpty && !decision.emojiHelp.isEmpty
        default:
            return true
        }
    }
}

// MARK: - Step Views

struct ItemPriceStep: View {
    @Binding var decision: PurchaseDecision
    
    var body: some View {
        VStack(spacing: 24) {
            Text("What do you want to buy?")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("🏷️ Item")
                        .font(.headline)
                    TextField("e.g., laptop, headphones, jacket", text: $decision.item)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("💵 Price")
                        .font(.headline)
                    TextField("0", value: $decision.price, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
            }
        }
        .padding()
    }
}

struct QuestionnaireStep: View {
    @Binding var decision: PurchaseDecision
    
    private let whyOptions = [
        "For work", "For study", "For a project", 
        "For fun or entertainment", "For collection or emotional value"
    ]
    
    private let wantedSinceOptions = [
        "For a long time (months+)", "For a few weeks", "Just recently"
    ]
    
    private let urgencyOptions = [
        "Very urgent — I need it now", 
        "Medium — would be helpful soon", 
        "Not urgent — I can wait"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Need Analysis")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // Q1: Why do you want this?
                QuestionCard(
                    question: "❓ Why do you want this item?",
                    options: whyOptions,
                    selection: $decision.whyReason
                )
                
                // Q2: Do you own something similar?
                QuestionCard(
                    question: "❓ Do you already own something similar?",
                    options: ["Yes — and it's working", "Yes — but it's limited or broken", "No, this is my first of this type"],
                    selection: Binding(
                        get: { decision.hasDuplicate ? "Yes — and it's working" : "No, this is my first of this type" },
                        set: { decision.hasDuplicate = $0.contains("Yes") }
                    )
                )
                
                // Q3: How long have you wanted this?
                QuestionCard(
                    question: "❓ How long have you wanted this?",
                    options: wantedSinceOptions,
                    selection: $decision.wantedSince
                )
                
                // Q4: How urgent is this purchase?
                QuestionCard(
                    question: "❓ How urgent is this purchase?",
                    options: urgencyOptions,
                    selection: $decision.urgency
                )
            }
            .padding()
        }
    }
}

struct QuestionCard: View {
    let question: String
    let options: [String]
    @Binding var selection: String
    @State private var customAnswer = ""
    @State private var showCustom = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(question)
                .font(.headline)
                .foregroundColor(.darkGreen)
            
            VStack(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selection = option
                        showCustom = false
                    }) {
                        HStack {
                            Text(option)
                                .foregroundColor(.darkGreen)
                            Spacer()
                            if selection == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.mediumGreen)
                            }
                        }
                        .padding()
                        .background(selection == option ? Color.mediumGreen.opacity(0.1) : Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selection == option ? Color.mediumGreen : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                
                // Custom answer option
                Button(action: {
                    showCustom.toggle()
                }) {
                    HStack {
                        Text("Other (write)")
                            .foregroundColor(.darkGreen)
                        Spacer()
                        Image(systemName: showCustom ? "chevron.up" : "chevron.down")
                            .foregroundColor(.mediumGreen)
                    }
                    .padding()
                    .background(showCustom ? Color.mediumGreen.opacity(0.1) : Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(showCustom ? Color.mediumGreen : Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
                
                if showCustom {
                    TextField("Enter your answer", text: $customAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: customAnswer) { _, newValue in
                            if !newValue.isEmpty {
                                selection = newValue
                            }
                        }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct EmojiStep: View {
    @Binding var decision: PurchaseDecision
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("DecisionCheck")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // How do you feel?
                EmojiQuestionCard(
                    question: "How do you feel about this purchase?",
                    options: [
                        ("🤩", "Really Excited!"),
                        ("🙂", "Pretty happy"),
                        ("😐", "It's okay"),
                        ("🤔", "Unsure...")
                    ],
                    selection: $decision.emojiFeel
                )
                
                // When do you need this?
                EmojiQuestionCard(
                    question: "When do you need this?",
                    options: [
                        ("⚡️", "Right now!"),
                        ("📅", "This month"),
                        ("⏳", "Sometime soon"),
                        ("🌱", "No rush")
                    ],
                    selection: $decision.emojiWhen
                )
                
                // How will this help you?
                EmojiQuestionCard(
                    question: "How will this help you?",
                    options: [
                        ("🧳", "Essential for work/study"),
                        ("🌟", "Improves my life"),
                        ("👍", "Nice to have"),
                        ("💭", "Just want it")
                    ],
                    selection: $decision.emojiHelp
                )
            }
            .padding()
        }
    }
}

struct EmojiQuestionCard: View {
    let question: String
    let options: [(String, String)] // (emoji, text)
    @Binding var selection: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(question)
                .font(.headline)
                .foregroundColor(.darkGreen)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(options, id: \.0) { emoji, text in
                    Button(action: {
                        selection = emoji
                    }) {
                        VStack(spacing: 8) {
                            Text(emoji)
                                .font(.system(size: 32))
                            Text(text)
                                .font(.caption)
                                .foregroundColor(.darkGreen)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selection == emoji ? Color.mediumGreen.opacity(0.2) : Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selection == emoji ? Color.mediumGreen : Color.gray.opacity(0.3), lineWidth: 2)
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct ResultStep: View {
    @Binding var decision: PurchaseDecision
    let userData: UserData
    let savingsPlans: [SavingsPlan]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Final verdict
                VStack(spacing: 12) {
                    Text(decision.finalVerdict.emoji)
                        .font(.system(size: 64))
                    
                    Text(decision.finalVerdict.displayText)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.darkGreen)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.mediumGreen.opacity(0.1))
                .cornerRadius(16)
                
                // Insight cards
                VStack(spacing: 16) {
                    Text("Decision Analysis")
                        .font(.headline)
                        .foregroundColor(.darkGreen)
                    
                    InsightCard(
                        title: "💰 Wasting Money",
                        content: decision.insightCards["wastingMoney"] ?? ""
                    )
                    
                    InsightCard(
                        title: "🔮 Needing Money Later",
                        content: decision.insightCards["needingMoneyLater"] ?? ""
                    )
                    
                    InsightCard(
                        title: "🤷‍♂️ Realizing You Didn't Need It",
                        content: decision.insightCards["realizingDidntNeed"] ?? ""
                    )
                    
                    InsightCard(
                        title: "😰 Feeling Guilty or Rushed",
                        content: decision.insightCards["feelingGuiltyRushed"] ?? ""
                    )
                }
            }
            .padding()
        }
    }
}

struct InsightCard: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.darkGreen)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// SecondaryButtonStyle is defined in DesignSystem.swift

#Preview {
    PurchaseDecisionScreen()
        .environmentObject(AppState())
} 
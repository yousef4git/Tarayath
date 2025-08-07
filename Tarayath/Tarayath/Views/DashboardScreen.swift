import SwiftUI

struct DashboardScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var showHistory = false
    
    private var userData: UserData {
        appState.userData ?? UserData()
    }
    
    private var texts: [AppLanguage: DashboardTexts] = [
        .english: DashboardTexts(
            welcome: { name in "Hi \(name.components(separatedBy: " ").first ?? "")!" },
            subtitle: "Your financial overview",
            monthlyIncome: "Monthly Income",
            monthlyObligations: "Monthly Obligations",
            currentBalance: "Current Balance",
            totalSaved: "Total in Savings Plans",
            netAvailable: "Net Available",
            activePlans: "Active Plans",
            startSavingPlan: "Start Saving Plan",
            decisionHelper: "Decision Helper",
            recommendations: "Recommendations",
            soonFeature: "Soon feature",
            budgetAllocation: "Budget Allocation",
            needs: "Needs",
            wants: "Wants",
            savings: "Savings",
            history: "History",
            profile: "Profile"
        ),
        .arabic: DashboardTexts(
            welcome: { name in "مرحباً \(name.components(separatedBy: " ").first ?? "")!" },
            subtitle: "نظرة عامة على وضعك المالي",
            monthlyIncome: "الدخل الشهري",
            monthlyObligations: "الالتزامات الشهرية",
            currentBalance: "الرصيد الحالي",
            totalSaved: "إجمالي خطط الادخار",
            netAvailable: "الصافي المتاح",
            activePlans: "الخطط النشطة",
            startSavingPlan: "ابدأ خطة ادخار",
            decisionHelper: "مساعد القرارات",
            recommendations: "التوصيات",
            soonFeature: "ميزة قريباً",
            budgetAllocation: "توزيع الميزانية",
            needs: "الاحتياجات",
            wants: "الرغبات",
            savings: "الادخار",
            history: "السجل",
            profile: "الملف الشخصي"
        )
    ]
    
    struct DashboardTexts {
        let welcome: (String) -> String
        let subtitle: String
        let monthlyIncome: String
        let monthlyObligations: String
        let currentBalance: String
        let totalSaved: String
        let netAvailable: String
        let activePlans: String
        let startSavingPlan: String
        let decisionHelper: String
        let recommendations: String
        let soonFeature: String
        let budgetAllocation: String
        let needs: String
        let wants: String
        let savings: String
        let history: String
        let profile: String
    }
    
    private var t: DashboardTexts {
        texts[userData.language] ?? texts[.english]!
    }
    
    private var activeSavingsPlans: [SavingsPlan] {
        appState.savingsPlans.filter { !$0.isCompleted }
    }
    
    private var totalPlannedSavings: Double {
        activeSavingsPlans.reduce(0) { $0 + $1.monthlyAmount }
    }
    
    private var netAvailable: Double {
        userData.currentBalance - userData.monthlyObligations - totalPlannedSavings
    }
    
    var body: some View {
        ZStack {
            // Enhanced Gradient Background
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.mediumGreen.opacity(0.7), location: 0.0),
                    .init(color: Color.lightBrown.opacity(0.5), location: 0.3),
                    .init(color: Color.creamWhite.opacity(0.8), location: 0.7),
                    .init(color: Color.mediumGreen.opacity(0.3), location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Enhanced Header
                enhancedHeaderView
                
                // Content
                ScrollView {
                    VStack(spacing: 32) {
                        // Financial Overview - Enhanced
                        enhancedFinancialOverviewSection
                            .padding(.top, 20)
                        
                        // Action Buttons - Enhanced
                        enhancedActionButtonsGrid
                        
                        // Budget Allocation - Enhanced
                        enhancedBudgetAllocationSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .sheet(isPresented: $showHistory) {
            historyPanelOverlay
        }
        .environment(\.layoutDirection, userData.language.isRTL ? .rightToLeft : .leftToRight)
        .statusBarStyle(.lightContent)
    }
    
    private var enhancedHeaderView: some View {
        VStack(spacing: 0) {
            HStack {
                // History Button - Enhanced
                Button(action: { showHistory = true }) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.creamWhite.opacity(0.9),
                                            Color.lightBrown.opacity(0.4)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: Color.darkGreen.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                
                Spacer()
                
                // Title - Enhanced
                VStack(spacing: 6) {
                    Text(t.welcome(userData.fullName))
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text(t.subtitle)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.darkGreen.opacity(0.8))
                }
                
                Spacer()
                
                // Profile Button - Enhanced
                Button(action: { appState.navigateToScreen(.profile) }) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.creamWhite.opacity(0.9),
                                            Color.lightBrown.opacity(0.4)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: Color.darkGreen.opacity(0.3), radius: 6, x: 0, y: 3)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            
            // Subtle divider
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.mediumGreen.opacity(0.3),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.creamWhite.opacity(0.8),
                    Color.lightBrown.opacity(0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private var enhancedFinancialOverviewSection: some View {
        VStack(spacing: 28) {
            // Header with Icon
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Financial Overview")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
            }
            .padding(.bottom, 8)
            
            // Top Grid - Income and Balance
            HStack(spacing: 16) {
                EnhancedFinancialStatCard(
                    title: t.monthlyIncome,
                    amount: userData.monthlyIncome,
                    currency: userData.currency,
                    icon: "dollarsign.circle.fill",
                    gradientColors: [Color.darkGreen, Color.mediumGreen]
                )
                
                EnhancedFinancialStatCard(
                    title: t.currentBalance,
                    amount: userData.currentBalance,
                    currency: userData.currency,
                    icon: "creditcard.fill",
                    gradientColors: [Color.mediumGreen, Color.lightBrown]
                )
            }
            
            // Financial Breakdown
            VStack(spacing: 16) {
                EnhancedFinancialRowItem(
                    title: t.monthlyObligations,
                    amount: userData.monthlyObligations,
                    currency: userData.currency,
                    icon: "list.bullet.circle.fill",
                    gradientColors: [Color.lightBrown.opacity(0.8), Color.creamWhite]
                )
                
                EnhancedFinancialRowItem(
                    title: t.totalSaved,
                    amount: totalPlannedSavings,
                    currency: userData.currency,
                    icon: "star.circle.fill",
                    gradientColors: [Color.mediumGreen.opacity(0.7), Color.lightBrown.opacity(0.5)]
                )
                
                EnhancedFinancialRowItem(
                    title: t.netAvailable,
                    amount: netAvailable,
                    currency: userData.currency,
                    icon: "banknote.fill",
                    isHighlighted: true,
                    amountColor: netAvailable >= 0 ? .mediumGreen : .red,
                    gradientColors: [Color.creamWhite.opacity(0.9), Color.mediumGreen.opacity(0.3)]
                )
            }
            
            // Active Plans Summary
            if !activeSavingsPlans.isEmpty {
                enhancedActivePlansSection
            }
        }
        .padding(.horizontal, 6)
    }
    
    private var enhancedActivePlansSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "target")
                    .font(.system(size: 18))
                    .foregroundColor(Color.darkGreen)
                
                Text("\(t.activePlans) (\(activeSavingsPlans.count))")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.darkGreen)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(activeSavingsPlans.prefix(2)) { plan in
                    HStack {
                        Circle()
                            .fill(Color.mediumGreen)
                            .frame(width: 8, height: 8)
                        
                        Text(plan.goal)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.darkGreen)
                        
                        Spacer()
                        
                        Text("\(CurrencyFormatter.format(plan.monthlyAmount, currency: userData.currency))/month")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color.mediumGreen)
                    }
                    .padding(.horizontal, 4)
                }
                
                if activeSavingsPlans.count > 2 {
                    HStack {
                        Circle()
                            .fill(Color.lightBrown)
                            .frame(width: 6, height: 6)
                        
                        Text("+\(activeSavingsPlans.count - 2) more plans")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color.darkGreen.opacity(0.7))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.creamWhite.opacity(0.6),
                            Color.lightBrown.opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.mediumGreen.opacity(0.4), Color.lightBrown.opacity(0.6)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: Color.darkGreen.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    private var enhancedActionButtonsGrid: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Quick Actions")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
            }
            .padding(.bottom, 4)
            
            HStack(spacing: 16) {
                // Start Savings Plan
                EnhancedActionButton(
                    title: t.startSavingPlan,
                    icon: "star.fill",
                    gradientColors: [Color.mediumGreen, Color.darkGreen],
                    style: .primary
                ) {
                    appState.navigateToScreen(.savingsPlan)
                }
                
                // Decision Helper
                EnhancedActionButton(
                    title: t.decisionHelper,
                    icon: "checkmark.circle.fill",
                    gradientColors: [Color.lightBrown, Color.mediumGreen.opacity(0.8)],
                    style: .secondary
                ) {
                    appState.navigateToScreen(.purchaseDecision)
                }
            }
            
            // Recommendations (Disabled)
            EnhancedActionButton(
                title: t.recommendations,
                subtitle: t.soonFeature,
                icon: "arrow.right.circle.fill",
                gradientColors: [Color.lightBrown.opacity(0.3), Color.creamWhite.opacity(0.6)],
                style: .disabled
            ) {
                // Coming soon
            }
        }
    }
    
    private var enhancedBudgetAllocationSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text(t.budgetAllocation)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
            }
            .padding(.bottom, 8)
            
            VStack(spacing: 28) {
                // Needs
                EnhancedBudgetCategoryRow(
                    title: t.needs,
                    percentage: appState.budgetBuckets.needs,
                    amount: (userData.monthlyIncome * Double(appState.budgetBuckets.needs)) / 100,
                    currency: userData.currency,
                    color: .darkGreen,
                    icon: "house.fill"
                ) { newPercentage in
                    updateBudgetCategory(.needs, newPercentage: newPercentage)
                } onAmountChange: { newAmount in
                    updateBudgetCategory(.needs, newAmount: newAmount)
                }
                
                // Wants
                EnhancedBudgetCategoryRow(
                    title: t.wants,
                    percentage: appState.budgetBuckets.wants,
                    amount: (userData.monthlyIncome * Double(appState.budgetBuckets.wants)) / 100,
                    currency: userData.currency,
                    color: .lightBrown,
                    icon: "gift.fill"
                ) { newPercentage in
                    updateBudgetCategory(.wants, newPercentage: newPercentage)
                } onAmountChange: { newAmount in
                    updateBudgetCategory(.wants, newAmount: newAmount)
                }
                
                // Savings
                EnhancedBudgetCategoryRow(
                    title: t.savings,
                    percentage: appState.budgetBuckets.savings,
                    amount: (userData.monthlyIncome * Double(appState.budgetBuckets.savings)) / 100,
                    currency: userData.currency,
                    color: .mediumGreen,
                    icon: "banknote.fill"
                ) { newPercentage in
                    updateBudgetCategory(.savings, newPercentage: newPercentage)
                } onAmountChange: { newAmount in
                    updateBudgetCategory(.savings, newAmount: newAmount)
                }
            }
        }
        .padding(.horizontal, 6)
    }
    
    private var historyPanelOverlay: some View {
        HistoryPanel(isPresented: $showHistory)
            .transition(.move(edge: userData.language.isRTL ? .leading : .trailing))
    }
    
    enum BudgetCategory {
        case needs, wants, savings
    }
    
    private func updateBudgetCategory(_ category: BudgetCategory, newPercentage: Int) {
        var buckets = appState.budgetBuckets
        
        switch category {
        case .needs:
            buckets.needs = newPercentage
            let remaining = 100 - newPercentage
            let wantsRatio = Double(buckets.wants) / Double(buckets.wants + buckets.savings)
            buckets.wants = Int(Double(remaining) * wantsRatio)
            buckets.savings = 100 - buckets.needs - buckets.wants
        case .wants:
            buckets.wants = newPercentage
            let remaining = 100 - newPercentage
            let needsRatio = Double(buckets.needs) / Double(buckets.needs + buckets.savings)
            buckets.needs = Int(Double(remaining) * needsRatio)
            buckets.savings = 100 - buckets.needs - buckets.wants
        case .savings:
            buckets.savings = newPercentage
            let remaining = 100 - newPercentage
            let needsRatio = Double(buckets.needs) / Double(buckets.needs + buckets.wants)
            buckets.needs = Int(Double(remaining) * needsRatio)
            buckets.wants = 100 - buckets.needs - buckets.savings
        }
        
        appState.updateBudgetBuckets(buckets)
    }
    
    private func updateBudgetCategory(_ category: BudgetCategory, newAmount: Double) {
        let newPercentage = Int((newAmount / userData.monthlyIncome) * 100)
        updateBudgetCategory(category, newPercentage: newPercentage)
    }
    
    private func getPercentage(for category: BudgetCategory, from buckets: BudgetBuckets) -> Int {
        switch category {
        case .needs: return buckets.needs
        case .wants: return buckets.wants
        case .savings: return buckets.savings
        }
    }
}

// MARK: - Enhanced Supporting Views

struct EnhancedFinancialStatCard: View {
    let title: String
    let amount: Double
    let currency: Currency
    let icon: String
    let gradientColors: [Color]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.darkGreen.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text(CurrencyFormatter.format(amount, currency: currency))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.creamWhite.opacity(0.8),
                            Color.lightBrown.opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors.map { $0.opacity(0.4) }),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: gradientColors.first?.opacity(0.3) ?? Color.clear, radius: 8, x: 0, y: 4)
    }
}

struct EnhancedFinancialRowItem: View {
    let title: String
    let amount: Double
    let currency: Currency
    let icon: String
    var isHighlighted: Bool = false
    var amountColor: Color = .primaryText
    let gradientColors: [Color]
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color.darkGreen)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.darkGreen)
                    .lineLimit(1)
                
                if isHighlighted {
                    Text(amount >= 0 ? "Available" : "Deficit")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(amount >= 0 ? Color.mediumGreen : Color.red)
                }
            }
            
            Spacer()
            
            Text(CurrencyFormatter.format(amount, currency: currency))
                .font(.system(size: isHighlighted ? 18 : 16, weight: .bold, design: .rounded))
                .foregroundColor(amountColor == .primaryText ? Color.darkGreen : amountColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isHighlighted 
                        ? LinearGradient(
                            gradient: Gradient(colors: [Color.mediumGreen.opacity(0.6), Color.darkGreen.opacity(0.4)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            gradient: Gradient(colors: [Color.clear]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                    lineWidth: isHighlighted ? 2 : 0
                )
        )
        .shadow(color: Color.darkGreen.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct EnhancedActionButton: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    let gradientColors: [Color]
    let style: ButtonStyleType
    let action: () -> Void
    
    enum ButtonStyleType {
        case primary, secondary, disabled
    }
    
    var body: some View {
        Button(action: style == .disabled ? {} : action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(foregroundColor)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(iconBackgroundGradient)
                    )
                    .shadow(color: shadowColor, radius: 6, x: 0, y: 3)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(foregroundColor)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(foregroundColor.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(backgroundGradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(borderGradient, lineWidth: style == .disabled ? 1 : 0)
            )
            .shadow(color: shadowColor, radius: style == .disabled ? 2 : 8, x: 0, y: style == .disabled ? 1 : 4)
        }
        .disabled(style == .disabled)
        .scaleEffect(style == .disabled ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: style)
    }
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: style == .disabled ? [Color.lightBrown.opacity(0.2), Color.creamWhite.opacity(0.5)] : gradientColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var iconBackgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                foregroundColor.opacity(0.2),
                foregroundColor.opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var borderGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.mediumGreen.opacity(0.3), Color.lightBrown.opacity(0.3)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary: return Color.creamWhite
        case .secondary: return Color.darkGreen
        case .disabled: return Color.darkGreen.opacity(0.5)
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .primary: return gradientColors.first?.opacity(0.4) ?? Color.clear
        case .secondary: return gradientColors.first?.opacity(0.3) ?? Color.clear
        case .disabled: return Color.darkGreen.opacity(0.1)
        }
    }
}

struct EnhancedBudgetCategoryRow: View {
    let title: String
    let percentage: Int
    let amount: Double
    let currency: Currency
    let color: Color
    let icon: String
    let onPercentageChange: (Int) -> Void
    let onAmountChange: (Double) -> Void
    
    @State private var tempAmount: String = ""
    @State private var isEditingAmount = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Title and Amount Input
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 28)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.darkGreen)
                    
                    Text("\(percentage)% of income")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(color.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    TextField("", text: $tempAmount)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.darkGreen)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 100)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.creamWhite.opacity(0.9),
                                            Color.lightBrown.opacity(0.3)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(color.opacity(0.4), lineWidth: 1.5)
                        )
                        .keyboardType(.decimalPad)
                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { _ in
                            isEditingAmount = true
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification)) { _ in
                            if let amount = Double(tempAmount) {
                                onAmountChange(amount)
                            }
                            isEditingAmount = false
                        }
                }
            }
            
            // Enhanced Slider
            EnhancedCustomSlider(
                value: Double(percentage),
                in: 0...100,
                step: 1,
                color: color
            ) { newValue in
                onPercentageChange(Int(newValue))
            }
            .frame(height: 32)
            
            // Enhanced Progress Bar
            EnhancedProgressBar(
                value: Double(percentage),
                total: 100,
                color: color
            )
            .frame(height: 12)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.creamWhite.opacity(0.7),
                            color.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [color.opacity(0.4), color.opacity(0.2)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: color.opacity(0.2), radius: 6, x: 0, y: 3)
        .onAppear {
            tempAmount = String(format: "%.0f", amount)
        }
        .onChange(of: amount) { _, newAmount in
            if !isEditingAmount {
                tempAmount = String(format: "%.0f", newAmount)
            }
        }
    }
}

struct EnhancedCustomSlider: View {
    let value: Double
    let range: ClosedRange<Double>
    let step: Double
    let color: Color
    let onValueChanged: (Double) -> Void
    
    init(value: Double, in range: ClosedRange<Double>, step: Double = 1, color: Color, onValueChanged: @escaping (Double) -> Void) {
        self.value = value
        self.range = range
        self.step = step
        self.color = color
        self.onValueChanged = onValueChanged
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.lightBrown.opacity(0.3),
                                Color.creamWhite.opacity(0.6)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 16)
                
                // Progress
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: progressWidth(geometry: geometry), height: 16)
                
                // Thumb
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.creamWhite, color.opacity(0.3)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 26, height: 26)
                    .overlay(
                        Circle()
                            .stroke(color, lineWidth: 3)
                    )
                    .shadow(color: color.opacity(0.4), radius: 4, x: 0, y: 2)
                    .offset(x: thumbOffset(geometry: geometry))
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { dragValue in
                        let percent = dragValue.location.x / geometry.size.width
                        let newValue = range.lowerBound + (range.upperBound - range.lowerBound) * percent
                        let steppedValue = round(newValue / step) * step
                        let clampedValue = min(max(steppedValue, range.lowerBound), range.upperBound)
                        onValueChanged(clampedValue)
                    }
            )
        }
        .frame(height: 26)
    }
    
    private func progressWidth(geometry: GeometryProxy) -> CGFloat {
        let percent = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return geometry.size.width * CGFloat(percent)
    }
    
    private func thumbOffset(geometry: GeometryProxy) -> CGFloat {
        let percent = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return (geometry.size.width - 26) * CGFloat(percent)
    }
}

struct EnhancedProgressBar: View {
    let value: Double
    let total: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.lightBrown.opacity(0.2),
                                Color.creamWhite.opacity(0.4)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 12)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(value / total), height: 12)
                    .shadow(color: color.opacity(0.3), radius: 2, x: 0, y: 1)
            }
        }
        .frame(height: 12)
    }
}

#Preview {
    DashboardScreen()
        .environmentObject(AppState())
}
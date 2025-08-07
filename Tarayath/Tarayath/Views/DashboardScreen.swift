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
            // Background - Updated
            AppGradients.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Content
                ScrollView {
                    VStack(spacing: 28) {
                        // Financial Overview
                        financialOverviewCard
                            .padding(.top, 16)
                        
                        // Action Buttons
                        actionButtonsGrid
                        
                        // Budget Allocation
                        budgetAllocationCard
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .sheet(isPresented: $showHistory) {
            historyPanelOverlay
        }
        .environment(\.layoutDirection, userData.language.isRTL ? .rightToLeft : .leftToRight)
        .statusBarStyle(.lightContent)
    }
    
    private var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                // History Button
                Button(action: { showHistory = true }) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.primaryText)
                        .frame(width: 40, height: 40)
                        .background(Color.primaryBackground.opacity(0.1))
                        .cornerRadius(20)
                }
                
                Spacer()
                
                // Title
                VStack(spacing: 4) {
                    Text(t.welcome(userData.fullName))
                        .font(AppTypography.title2)
                        .foregroundColor(Color.primaryText)
                    
                    Text(t.subtitle)
                        .font(AppTypography.callout)
                        .foregroundColor(Color.secondaryText)
                }
                
                Spacer()
                
                // Profile Button
                Button(action: { appState.navigateToScreen(.profile) }) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.primaryText)
                        .frame(width: 40, height: 40)
                        .background(Color.primaryBackground.opacity(0.1))
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            
            Rectangle()
                .fill(Color.primaryBackground.opacity(0.1))
                .frame(height: 1)
        }
        .background(Color.cardBackground.opacity(0.95))
    }
    
    private var financialOverviewCard: some View {
        VStack(spacing: 24) {
            // Top Grid - Income and Balance
            HStack(spacing: 16) {
                FinancialStatCard(
                    title: t.monthlyIncome,
                    amount: userData.monthlyIncome,
                    currency: userData.currency,
                    color: .darkGreen
                )
                
                FinancialStatCard(
                    title: t.currentBalance,
                    amount: userData.currentBalance,
                    currency: userData.currency,
                    color: .mediumGreen
                )
            }
            .frame(minHeight: 100)
            
            // Financial Breakdown
            VStack(spacing: 16) {
                FinancialRowItem(
                    title: t.monthlyObligations,
                    amount: userData.monthlyObligations,
                    currency: userData.currency,
                    backgroundColor: Color.primaryBackground.opacity(0.05)
                )
                
                FinancialRowItem(
                    title: t.totalSaved,
                    amount: totalPlannedSavings,
                    currency: userData.currency,
                    backgroundColor: Color.lightBrown.opacity(0.1)
                )
                
                FinancialRowItem(
                    title: t.netAvailable,
                    amount: netAvailable,
                    currency: userData.currency,
                    backgroundColor: Color.darkGreen.opacity(0.05),
                    isHighlighted: true,
                    amountColor: netAvailable >= 0 ? .mediumGreen : .red
                )
            }
            
            // Active Plans Summary
            if !activeSavingsPlans.isEmpty {
                activePlansSection
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .appCardStyle()
    }
    
    private var activePlansSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(t.activePlans) (\(activeSavingsPlans.count))")
                    .font(AppTypography.caption1)
                    .foregroundColor(.darkGreen.opacity(0.6))
                Spacer()
            }
            
            VStack(spacing: 8) {
                ForEach(activeSavingsPlans.prefix(2)) { plan in
                    HStack {
                        Text(plan.goal)
                            .font(AppTypography.caption1)
                            .foregroundColor(.darkGreen.opacity(0.7))
                        
                        Spacer()
                        
                        Text("\(CurrencyFormatter.format(plan.monthlyAmount, currency: userData.currency))/month")
                            .font(AppTypography.caption1)
                            .foregroundColor(.darkGreen)
                    }
                }
                
                if activeSavingsPlans.count > 2 {
                    HStack {
                        Text("+\(activeSavingsPlans.count - 2) more plans")
                            .font(AppTypography.caption2)
                            .foregroundColor(.darkGreen.opacity(0.5))
                        Spacer()
                    }
                }
            }
        }
        .padding(.top, 8)
    }
    
    private var actionButtonsGrid: some View {
        HStack(spacing: 12) {
            // Start Savings Plan
            ActionButton(
                title: t.startSavingPlan,
                icon: "star.fill",
                style: .primary
            ) {
                appState.navigateToScreen(.savingsPlan)
            }
            
            // Decision Helper
            ActionButton(
                title: t.decisionHelper,
                icon: "checkmark.circle.fill",
                style: .secondary
            ) {
                appState.navigateToScreen(.purchaseDecision)
            }
            
            // Recommendations (Disabled)
            ActionButton(
                title: t.recommendations,
                subtitle: t.soonFeature,
                icon: "arrow.right.circle.fill",
                style: .disabled
            ) {
                // Coming soon
            }
        }
    }
    
    private var budgetAllocationCard: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(t.budgetAllocation)
                .font(AppTypography.title3)
                .foregroundColor(.darkGreen)
            
            VStack(spacing: 24) {
                // Needs
                BudgetCategoryRow(
                    title: t.needs,
                    percentage: appState.budgetBuckets.needs,
                    amount: (userData.monthlyIncome * Double(appState.budgetBuckets.needs)) / 100,
                    currency: userData.currency,
                    color: .darkGreen
                ) { newPercentage in
                    updateBudgetCategory(.needs, newPercentage: newPercentage)
                } onAmountChange: { newAmount in
                    updateBudgetCategory(.needs, newAmount: newAmount)
                }
                
                // Wants
                BudgetCategoryRow(
                    title: t.wants,
                    percentage: appState.budgetBuckets.wants,
                    amount: (userData.monthlyIncome * Double(appState.budgetBuckets.wants)) / 100,
                    currency: userData.currency,
                    color: .lightBrown
                ) { newPercentage in
                    updateBudgetCategory(.wants, newPercentage: newPercentage)
                } onAmountChange: { newAmount in
                    updateBudgetCategory(.wants, newAmount: newAmount)
                }
                
                // Savings
                BudgetCategoryRow(
                    title: t.savings,
                    percentage: appState.budgetBuckets.savings,
                    amount: (userData.monthlyIncome * Double(appState.budgetBuckets.savings)) / 100,
                    currency: userData.currency,
                    color: .mediumGreen
                ) { newPercentage in
                    updateBudgetCategory(.savings, newPercentage: newPercentage)
                } onAmountChange: { newAmount in
                    updateBudgetCategory(.savings, newAmount: newAmount)
                }
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var historyPanelOverlay: some View {

            // History Panel
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

// MARK: - Supporting Views

struct FinancialStatCard: View {
    let title: String
    let amount: Double
    let currency: Currency
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(AppTypography.callout)
                .foregroundColor(Color.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer(minLength: 8)
            
            Text(CurrencyFormatter.format(amount, currency: currency))
                .font(AppTypography.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.primaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 90)
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
    }
}

struct FinancialRowItem: View {
    let title: String
    let amount: Double
    let currency: Currency
    let backgroundColor: Color
    var isHighlighted: Bool = false
    var amountColor: Color = .primaryText
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(AppTypography.callout)
                .foregroundColor(Color.secondaryText)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer(minLength: 8)
            
            Text(CurrencyFormatter.format(amount, currency: currency))
                .font(isHighlighted ? AppTypography.title3 : AppTypography.callout)
                .fontWeight(isHighlighted ? .bold : .semibold)
                .foregroundColor(amountColor == .primaryText ? Color.primaryText : amountColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.trailing)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(minHeight: 60)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(backgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isHighlighted ? Color.primaryBackground.opacity(0.2) : Color.clear, lineWidth: 2)
        )
    }
}

struct ActionButton: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    let style: ButtonStyleType
    let action: () -> Void
    
    enum ButtonStyleType {
        case primary, secondary, disabled
    }
    
    var body: some View {
        Button(action: style == .disabled ? {} : action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(foregroundColor)
                    .frame(width: 40, height: 40)
                    .background(iconBackgroundColor)
                    .cornerRadius(12)
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(AppTypography.caption1)
                        .fontWeight(.medium)
                        .foregroundColor(foregroundColor)
                        .multilineTextAlignment(.center)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(foregroundColor.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(backgroundColor)
            .cornerRadius(16)
        }
        .disabled(style == .disabled)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary: return Color.mediumGreen
        case .secondary: return Color.lightBrown
        case .disabled: return Color.darkGreen.opacity(0.05)
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary: return Color.creamWhite
        case .secondary: return Color.darkGreen
        case .disabled: return Color.darkGreen.opacity(0.4)
        }
    }
    
    private var iconBackgroundColor: Color {
        switch style {
        case .primary: return Color.creamWhite.opacity(0.2)
        case .secondary: return Color.darkGreen.opacity(0.1)
        case .disabled: return Color.darkGreen.opacity(0.05)
        }
    }
}

struct BudgetCategoryRow: View {
    let title: String
    let percentage: Int
    let amount: Double
    let currency: Currency
    let color: Color
    let onPercentageChange: (Int) -> Void
    let onAmountChange: (Double) -> Void
    
    @State private var tempAmount: String = ""
    @State private var isEditingAmount = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Title and Amount Input
            HStack(alignment: .center) {
                Text(title)
                    .font(AppTypography.callout)
                    .foregroundColor(.darkGreen.opacity(0.8))
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer(minLength: 12)
                
                HStack(spacing: 10) {
                    TextField("", text: $tempAmount)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(AppTypography.callout)
                        .foregroundColor(.darkGreen)
                        .frame(width: 100)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.mediumGreen.opacity(0.4), lineWidth: 1.5)
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
                    
                    Text("(\(percentage)%)")
                        .font(AppTypography.callout)
                        .foregroundColor(.darkGreen.opacity(0.6))
                        .fontWeight(.medium)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .frame(minHeight: 50)
            
            // Interactive Slider
            CustomSlider(
                value: Double(percentage),
                in: 0...100,
                step: 1,
                color: color
            ) { newValue in
                onPercentageChange(Int(newValue))
            }
            .frame(height: 24)
            
            // Progress Bar
            ProgressView(value: Double(percentage), total: 100)
                .progressViewStyle(CustomProgressViewStyle(color: color))
                .frame(height: 10)
        }
        .padding(.vertical, 8)
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

struct CustomSlider: View {
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
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                // Progress
                Rectangle()
                    .fill(color)
                    .frame(width: progressWidth(geometry: geometry), height: 8)
                    .cornerRadius(4)
                
                // Thumb
                Circle()
                    .fill(color)
                    .frame(width: 20, height: 20)
                    .offset(x: thumbOffset(geometry: geometry))
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
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
        .frame(height: 20)
    }
    
    private func progressWidth(geometry: GeometryProxy) -> CGFloat {
        let percent = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return geometry.size.width * CGFloat(percent)
    }
    
    private func thumbOffset(geometry: GeometryProxy) -> CGFloat {
        let percent = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return (geometry.size.width - 20) * CGFloat(percent)
    }
}

struct CustomProgressViewStyle: ProgressViewStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 12)
                    .cornerRadius(6)
                
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0), height: 12)
                    .cornerRadius(6)
            }
        }
        .frame(height: 12)
    }
}

#Preview {
    DashboardScreen()
        .environmentObject(AppState())
}
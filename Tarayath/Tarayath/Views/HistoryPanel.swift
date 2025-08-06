import SwiftUI

struct HistoryPanel: View {
    @EnvironmentObject var appState: AppState
    @Binding var isPresented: Bool
    @State private var selectedTab = 0
    
    // Explicit initializer
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    private var userData: UserData {
        appState.userData ?? UserData()
    }
    
    private var texts: [AppLanguage: HistoryTexts] = [
        .english: HistoryTexts(
            title: "History",
            savingsPlans: "Savings Plans",
            purchaseDecisions: "Purchase Decisions",
            noSavingsPlans: "No savings plans yet",
            noPurchaseDecisions: "No purchase decisions yet",
            createFirstPlan: "Create your first savings plan to get started",
            makeFirstDecision: "Make your first purchase decision",
            completed: "Completed",
            active: "Active",
            recommended: "Recommended",
            notRecommended: "Not Recommended",
            wait: "Wait",
            purchased: "Purchased",
            declined: "Declined",
            monthlyAmount: "Monthly Amount",
            totalAmount: "Total Amount",
            duration: "Duration",
            months: "months",
            createdAt: "Created",
            price: "Price",
            decision: "Decision"
        ),
        .arabic: HistoryTexts(
            title: "السجل",
            savingsPlans: "خطط الادخار",
            purchaseDecisions: "قرارات الشراء",
            noSavingsPlans: "لا توجد خطط ادخار بعد",
            noPurchaseDecisions: "لا توجد قرارات شراء بعد",
            createFirstPlan: "أنشئ خطة الادخار الأولى للبدء",
            makeFirstDecision: "اتخذ قرار الشراء الأول",
            completed: "مكتمل",
            active: "نشط",
            recommended: "موصى به",
            notRecommended: "غير موصى به",
            wait: "انتظر",
            purchased: "تم الشراء",
            declined: "تم الرفض",
            monthlyAmount: "المبلغ الشهري",
            totalAmount: "المبلغ الإجمالي",
            duration: "المدة",
            months: "شهر",
            createdAt: "تاريخ الإنشاء",
            price: "السعر",
            decision: "القرار"
        )
    ]
    
    struct HistoryTexts {
        let title: String
        let savingsPlans: String
        let purchaseDecisions: String
        let noSavingsPlans: String
        let noPurchaseDecisions: String
        let createFirstPlan: String
        let makeFirstDecision: String
        let completed: String
        let active: String
        let recommended: String
        let notRecommended: String
        let wait: String
        let purchased: String
        let declined: String
        let monthlyAmount: String
        let totalAmount: String
        let duration: String
        let months: String
        let createdAt: String
        let price: String
        let decision: String
    }
    
    private var t: HistoryTexts {
        texts[userData.language] ?? texts[.english]!
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                if !userData.language.isRTL {
                    Spacer()
                }
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // Tab Selection
                    tabSelectionView
                    
                    // Content
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            if selectedTab == 0 {
                                savingsPlansContent
                            } else {
                                purchaseDecisionsContent
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 32)
                    }
                }
                .frame(width: min(geometry.size.width * 0.85, 350))
                .background(Color.white)
                .cornerRadius(16, corners: userData.language.isRTL ? [.topRight, .bottomRight] : [.topLeft, .bottomLeft])
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                
                if userData.language.isRTL {
                    Spacer()
                }
            }
        }
        .background(Color.clear)
        .environment(\.layoutDirection, userData.language.isRTL ? .rightToLeft : .leftToRight)
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                withAnimation {
                    isPresented = false
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.darkGreen)
                    .frame(width: 32, height: 32)
                    .background(Color.mediumGreen.opacity(0.1))
                    .cornerRadius(16)
            }
            
            Spacer()
            
            Text(t.title)
                .font(AppTypography.title)
                .foregroundColor(.darkGreen)
            
            Spacer()
            
            // Invisible spacer for centering
            Color.clear
                .frame(width: 32, height: 32)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(Color.white)
    }
    
    private var tabSelectionView: some View {
        HStack(spacing: 0) {
            TabButton(
                title: t.savingsPlans,
                isSelected: selectedTab == 0
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = 0
                }
            }
            
            TabButton(
                title: t.purchaseDecisions,
                isSelected: selectedTab == 1
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = 1
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
        .background(Color.white)
    }
    
    private var savingsPlansContent: some View {
        Group {
            if appState.savingsPlans.isEmpty {
                EmptyStateView(
                    icon: "star.circle",
                    title: t.noSavingsPlans,
                    subtitle: t.createFirstPlan
                )
            } else {
                ForEach(appState.savingsPlans.sorted(by: { $0.createdAt > $1.createdAt })) { plan in
                    HistorySavingsPlanCard(plan: plan, texts: t, currency: userData.currency)
                }
            }
        }
        .padding(.top, 16)
    }
    
    private var purchaseDecisionsContent: some View {
        Group {
            if appState.purchaseDecisions.isEmpty {
                EmptyStateView(
                    icon: "checkmark.circle",
                    title: t.noPurchaseDecisions,
                    subtitle: t.makeFirstDecision
                )
            } else {
                ForEach(appState.purchaseDecisions.sorted(by: { $0.createdAt > $1.createdAt })) { decision in
                    HistoryPurchaseDecisionCard(decision: decision, texts: t, currency: userData.currency)
                }
            }
        }
        .padding(.top, 16)
    }
}

// MARK: - Supporting Views

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(AppTypography.callout)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(isSelected ? .mediumGreen : .darkGreen.opacity(0.6))
                    .multilineTextAlignment(.center)
                
                Rectangle()
                    .fill(isSelected ? Color.mediumGreen : Color.clear)
                    .frame(height: 2)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.mediumGreen.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(AppTypography.title3)
                    .foregroundColor(.darkGreen)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(AppTypography.callout)
                    .foregroundColor(.darkGreen.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
    }
}

// History-specific card components (simplified versions to avoid conflicts)
struct HistorySavingsPlanCard: View {
    let plan: SavingsPlan
    let texts: HistoryPanel.HistoryTexts
    let currency: Currency
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.goal)
                        .font(AppTypography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.darkGreen)
                    
                    Text(formatDate(plan.createdAt))
                        .font(AppTypography.caption)
                        .foregroundColor(.darkGreen.opacity(0.6))
                }
                
                Spacer()
                
                HistoryStatusBadge(
                    text: plan.isCompleted ? texts.completed : texts.active,
                    color: plan.isCompleted ? .mediumGreen : .lightBrown
                )
            }
            
            // Details
            VStack(spacing: 8) {
                HistoryDetailRow(
                    title: texts.totalAmount,
                    value: CurrencyFormatter.format(plan.targetAmount, currency: currency)
                )
                
                HistoryDetailRow(
                    title: texts.monthlyAmount,
                    value: CurrencyFormatter.format(plan.monthlyAmount, currency: currency)
                )
                
                HistoryDetailRow(
                    title: texts.duration,
                    value: "\(plan.duration) \(texts.months)"
                )
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct HistoryPurchaseDecisionCard: View {
    let decision: PurchaseDecision
    let texts: HistoryPanel.HistoryTexts
    let currency: Currency
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(decision.item)
                        .font(AppTypography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.darkGreen)
                    
                    Text(formatDate(decision.createdAt))
                        .font(AppTypography.caption)
                        .foregroundColor(.darkGreen.opacity(0.6))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HistoryStatusBadge(
                        text: decision.purchased ? texts.purchased : texts.declined,
                        color: decision.purchased ? .mediumGreen : .darkGreen.opacity(0.6)
                    )
                    
                    HistoryDecisionBadge(decision: decision.decision, texts: texts)
                }
            }
            
            // Details
            VStack(spacing: 8) {
                HistoryDetailRow(
                    title: texts.price,
                    value: CurrencyFormatter.format(decision.price, currency: currency)
                )
                
                if decision.purchased, let purchaseDate = decision.purchasedDate {
                    HistoryDetailRow(
                        title: texts.purchased,
                        value: formatDate(purchaseDate)
                    )
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct HistoryStatusBadge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(AppTypography.caption)
            .fontWeight(.medium)
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .cornerRadius(6)
    }
}

struct HistoryDecisionBadge: View {
    let decision: String
    let texts: HistoryPanel.HistoryTexts
    
    var body: some View {
        let (text, color) = decisionDisplay
        
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.1))
            .cornerRadius(4)
    }
    
    private var decisionDisplay: (String, Color) {
        switch decision {
        case "recommended":
            return (texts.recommended, .mediumGreen)
        case "not-recommended":
            return (texts.notRecommended, .red)
        case "wait":
            return (texts.wait, .orange)
        default:
            return (decision, .darkGreen)
        }
    }
}

struct HistoryDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(.darkGreen.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(AppTypography.caption)
                .fontWeight(.medium)
                .foregroundColor(.darkGreen)
        }
    }
}

// MARK: - Corner Radius Extension

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    HistoryPanel(isPresented: .constant(true))
        .environmentObject(AppState())
} 
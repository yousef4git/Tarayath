import SwiftUI

struct SavingsPlanScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var showingNewPlanSheet = false
    
    private var userData: UserData {
        appState.userData ?? UserData()
    }
    
    private var texts: [AppLanguage: SavingsTexts] = [
        .english: SavingsTexts(
            title: "Savings Plans",
            backToDashboard: "",
            createNewPlan: "Create New Plan",
            activePlans: "Active Plans",
            completedPlans: "Completed Plans",
            noActivePlans: "No active savings plans",
            noCompletedPlans: "No completed plans yet",
            createFirstPlan: "Create your first savings plan to start building your financial future!",
            planProgress: "Progress",
            monthlyAmount: "Monthly Amount",
            targetAmount: "Target Amount",
            duration: "Duration",
            months: "months",
            completed: "Completed",
            onTrack: "On Track",
            behindSchedule: "Behind Schedule"
        ),
        .arabic: SavingsTexts(
            title: "خطط الادخار",
            backToDashboard: "",
            createNewPlan: "إنشاء خطة جديدة",
            activePlans: "الخطط النشطة",
            completedPlans: "الخطط المكتملة",
            noActivePlans: "لا توجد خطط ادخار نشطة",
            noCompletedPlans: "لا توجد خطط مكتملة بعد",
            createFirstPlan: "أنشئ خطة الادخار الأولى لبناء مستقبلك المالي!",
            planProgress: "التقدم",
            monthlyAmount: "المبلغ الشهري",
            targetAmount: "المبلغ المستهدف",
            duration: "المدة",
            months: "شهر",
            completed: "مكتمل",
            onTrack: "في المسار الصحيح",
            behindSchedule: "متأخر عن الجدول"
        )
    ]
    
    struct SavingsTexts {
        let title: String
        let backToDashboard: String
        let createNewPlan: String
        let activePlans: String
        let completedPlans: String
        let noActivePlans: String
        let noCompletedPlans: String
        let createFirstPlan: String
        let planProgress: String
        let monthlyAmount: String
        let targetAmount: String
        let duration: String
        let months: String
        let completed: String
        let onTrack: String
        let behindSchedule: String
    }
    
    private var t: SavingsTexts {
        texts[userData.language] ?? texts[.english]!
    }
    
    private var activePlans: [SavingsPlan] {
        appState.savingsPlans.filter { !$0.isCompleted }
    }
    
    private var completedPlans: [SavingsPlan] {
        appState.savingsPlans.filter { $0.isCompleted }
    }
    
    var body: some View {
        ZStack {
            // Enhanced Gradient Background
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.mediumGreen.opacity(0.6), location: 0.0),
                    .init(color: Color.lightBrown.opacity(0.4), location: 0.3),
                    .init(color: Color.creamWhite.opacity(0.7), location: 0.7),
                    .init(color: Color.mediumGreen.opacity(0.2), location: 1.0)
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
                        // Create New Plan Button - Enhanced
                        enhancedCreateNewPlanButton
                            .padding(.top, 20)
                        
                        // Active Plans Section - Enhanced
                        if !activePlans.isEmpty {
                            enhancedActivePlansSection
                        }
                        
                        // Completed Plans Section - Enhanced
                        if !completedPlans.isEmpty {
                            enhancedCompletedPlansSection
                        }
                        
                        // Empty State - Enhanced
                        if activePlans.isEmpty && completedPlans.isEmpty {
                            enhancedEmptyStateView
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .sheet(isPresented: $showingNewPlanSheet) {
            NewSavingsPlanView(
                userData: userData,
                onSave: { plan in
                    appState.addSavingsPlan(plan)
                    showingNewPlanSheet = false
                },
                onCancel: {
                    showingNewPlanSheet = false
                }
            )
        }
        .environment(\.layoutDirection, userData.language.isRTL ? .rightToLeft : .leftToRight)
    }
    
    private var enhancedHeaderView: some View {
        HStack {
            Button(action: {
                appState.navigateToScreen(.dashboard)
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text(t.backToDashboard)
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
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
                .shadow(color: Color.darkGreen.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            
            Spacer()
            
            Text(t.title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Spacer()
            
            // Invisible spacer for balance
            Color.clear
                .frame(width: 80, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
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
    
    private var enhancedCreateNewPlanButton: some View {
        Button(action: {
            showingNewPlanSheet = true
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.creamWhite.opacity(0.3),
                                    Color.lightBrown.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(Color.creamWhite)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(t.createNewPlan)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color.creamWhite)
                    
                    Text("Start building your financial future")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.creamWhite.opacity(0.9))
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.creamWhite.opacity(0.8))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.mediumGreen, Color.darkGreen]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .shadow(color: Color.darkGreen.opacity(0.4), radius: 12, x: 0, y: 6)
        }
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showingNewPlanSheet)
    }
    
    private var enhancedActivePlansSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("\(t.activePlans) (\(activePlans.count))")
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
            
            VStack(spacing: 20) {
                ForEach(activePlans) { plan in
                    EnhancedSavingsPlanCard(
                        plan: plan,
                        texts: t,
                        userData: userData,
                        isCompleted: false
                    )
                }
            }
        }
    }
    
    private var enhancedCompletedPlansSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.mediumGreen, Color.lightBrown]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("\(t.completedPlans) (\(completedPlans.count))")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.mediumGreen, Color.lightBrown]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
            }
            .padding(.bottom, 8)
            
            VStack(spacing: 20) {
                ForEach(completedPlans) { plan in
                    EnhancedSavingsPlanCard(
                        plan: plan,
                        texts: t,
                        userData: userData,
                        isCompleted: true
                    )
                }
            }
        }
    }
    
    private var enhancedEmptyStateView: some View {
        VStack(spacing: 32) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.mediumGreen.opacity(0.3),
                                Color.lightBrown.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "star.circle")
                    .font(.system(size: 60, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 16) {
                Text(t.noActivePlans)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .multilineTextAlignment(.center)
                
                Text(t.createFirstPlan)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color.darkGreen.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .lineLimit(3)
            }
            
            Button(action: {
                showingNewPlanSheet = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                    Text("Get Started")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(Color.creamWhite)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.mediumGreen, Color.darkGreen]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color.darkGreen.opacity(0.4), radius: 8, x: 0, y: 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.creamWhite.opacity(0.6),
                            Color.lightBrown.opacity(0.2)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.mediumGreen.opacity(0.3), Color.lightBrown.opacity(0.4)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: Color.darkGreen.opacity(0.1), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Enhanced Supporting Views

struct EnhancedSavingsPlanCard: View {
    let plan: SavingsPlan
    let texts: SavingsPlanScreen.SavingsTexts
    let userData: UserData
    let isCompleted: Bool
    
    private var progressPercentage: Double {
        guard plan.targetAmount > 0 else { return 0 }
        return min(plan.currentSavings / plan.targetAmount, 1.0)
    }
    
    private var statusColor: Color {
        if plan.isCompleted { return .mediumGreen }
        if progressPercentage >= 0.8 { return .mediumGreen }
        if progressPercentage >= 0.5 { return .lightBrown }
        return .darkGreen.opacity(0.6)
    }
    
    private var statusText: String {
        if plan.isCompleted { return texts.completed }
        if progressPercentage >= 0.8 { return texts.onTrack }
        return texts.behindSchedule
    }
    
    private var cardGradient: [Color] {
        if isCompleted {
            return [Color.mediumGreen.opacity(0.2), Color.lightBrown.opacity(0.2)]
        } else {
            return [Color.creamWhite.opacity(0.8), Color.lightBrown.opacity(0.3)]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header with Icon
            HStack(alignment: .top, spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [statusColor.opacity(0.3), statusColor.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "star.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(statusColor)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(plan.goal)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.darkGreen, statusColor]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: isCompleted ? "trophy.fill" : "clock.fill")
                            .font(.system(size: 14))
                            .foregroundColor(statusColor)
                        
                        Text(statusText)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(statusColor)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(statusColor.opacity(0.15))
                    )
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(CurrencyFormatter.format(plan.currentSavings, currency: userData.currency))
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(statusColor)
                    
                    Text("of \(CurrencyFormatter.format(plan.targetAmount, currency: userData.currency))")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color.darkGreen.opacity(0.7))
                }
            }
            
            // Progress Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(texts.planProgress)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.darkGreen)
                    
                    Spacer()
                    
                    Text("\(Int(progressPercentage * 100))%")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(statusColor)
                }
                
                // Enhanced Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
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
                            .frame(height: 16)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [statusColor, statusColor.opacity(0.7)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progressPercentage, height: 16)
                            .shadow(color: statusColor.opacity(0.4), radius: 2, x: 0, y: 1)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progressPercentage)
                    }
                }
                .frame(height: 16)
            }
            
            // Details Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                EnhancedPlanDetailItem(
                    icon: "dollarsign.circle.fill",
                    title: texts.monthlyAmount,
                    value: CurrencyFormatter.format(plan.monthlyAmount, currency: userData.currency),
                    color: Color.darkGreen
                )
                
                EnhancedPlanDetailItem(
                    icon: "calendar.circle.fill",
                    title: texts.duration,
                    value: "\(plan.duration) \(texts.months)",
                    color: Color.mediumGreen
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: cardGradient),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [statusColor.opacity(0.4), statusColor.opacity(0.2)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: statusColor.opacity(0.2), radius: 12, x: 0, y: 6)
    }
}

struct EnhancedPlanDetailItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color.darkGreen.opacity(0.8))
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.08))
        )
    }
}

struct NewSavingsPlanView: View {
    let userData: UserData
    let onSave: (SavingsPlan) -> Void
    let onCancel: () -> Void
    
    @State private var planName = ""
    @State private var targetAmount = ""
    @State private var monthlyAmount = ""
    @State private var duration = ""
    @State private var formErrors = FormErrors()
    
    struct FormErrors {
        var planName = false
        var targetAmount = false
        var monthlyAmount = false
        var duration = false
    }
    
    private var isFormValid: Bool {
        !planName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        Double(targetAmount) ?? 0 > 0 &&
        Double(monthlyAmount) ?? 0 > 0 &&
        Int(duration) ?? 0 > 0
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Plan Name
                        VStack(alignment: .leading, spacing: 12) {
                            Text("What are you saving for?")
                                .font(AppTypography.callout)
                                .foregroundColor(.darkGreen)
                                .fontWeight(.medium)
                            TextField("Enter your goal (e.g., New Car, Vacation)", text: $planName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(minHeight: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(formErrors.planName ? Color.red : Color.clear, lineWidth: 1)
                                )
                        }
                    
                        // Target Amount
                        VStack(alignment: .leading, spacing: 12) {
                            Text("How much do you need?")
                                .font(AppTypography.callout)
                                .foregroundColor(.darkGreen)
                                .fontWeight(.medium)
                            TextField("Enter target amount", text: $targetAmount)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(minHeight: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(formErrors.targetAmount ? Color.red : Color.clear, lineWidth: 1)
                                )
                        }
                    
                        // Monthly Amount
                        VStack(alignment: .leading, spacing: 12) {
                            Text("How much can you save monthly?")
                                .font(AppTypography.callout)
                                .foregroundColor(.darkGreen)
                                .fontWeight(.medium)
                            TextField("Enter monthly savings amount", text: $monthlyAmount)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(minHeight: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(formErrors.monthlyAmount ? Color.red : Color.clear, lineWidth: 1)
                                )
                        }
                        
                        // Duration
                        VStack(alignment: .leading, spacing: 12) {
                            Text("When do you need it? (months)")
                                .font(AppTypography.callout)
                                .foregroundColor(.darkGreen)
                                .fontWeight(.medium)
                            TextField("Enter duration in months", text: $duration)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(minHeight: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(formErrors.duration ? Color.red : Color.clear, lineWidth: 1)
                                )
                        }
                        
                        // Plan Summary
                        if isFormValid {
                            planSummarySection
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // Save Button
                Button(action: savePlan) {
                    Text("Create Savings Plan")
                        .font(AppTypography.button)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!isFormValid)
                .opacity(isFormValid ? 1.0 : 0.6)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
            .navigationTitle("Create Savings Plan")
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
    
    private var planSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Plan Summary")
                .font(AppTypography.title3)
                .foregroundColor(.darkGreen)
                .fontWeight(.semibold)
                .padding(.bottom, 8)
            
            VStack(spacing: 12) {
                SimpleInfoRow(label: "Goal", value: planName)
                SimpleInfoRow(label: "Target Amount", value: CurrencyFormatter.format(Double(targetAmount) ?? 0, currency: userData.currency))
                SimpleInfoRow(label: "Monthly Savings", value: CurrencyFormatter.format(Double(monthlyAmount) ?? 0, currency: userData.currency))
                SimpleInfoRow(label: "Duration", value: "\(duration) months")
                
                if let targetAmt = Double(targetAmount), let monthlyAmt = Double(monthlyAmount), targetAmt > 0, monthlyAmt > 0 {
                    let calculatedMonths = Int(ceil(targetAmt / monthlyAmt))
                    SimpleInfoRow(label: "Time to Complete", value: "\(calculatedMonths) months")
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.mediumGreen.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mediumGreen.opacity(0.3), lineWidth: 1.5)
        )
    }
    
    private func savePlan() {
        validateForm()
        
        if isFormValid {
            let plan = SavingsPlan(
                goal: planName.trimmingCharacters(in: .whitespacesAndNewlines),
                targetAmount: Double(targetAmount) ?? 0,
                monthlyAmount: Double(monthlyAmount) ?? 0,
                duration: Int(duration) ?? 0
            )
            onSave(plan)
        }
    }
    
    private func validateForm() {
        formErrors.planName = planName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        formErrors.targetAmount = (Double(targetAmount) ?? 0) <= 0
        formErrors.monthlyAmount = (Double(monthlyAmount) ?? 0) <= 0
        formErrors.duration = (Int(duration) ?? 0) <= 0
    }
}

struct SimpleInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color.darkGreen.opacity(0.8))
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color.darkGreen)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    SavingsPlanScreen()
        .environmentObject(AppState())
}
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
            backToDashboard: "Back to Dashboard",
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
            backToDashboard: "العودة للوحة الرئيسية",
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
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.dynamicBackground, Color.mediumGreenFallback.opacity(0.08)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                    .padding(.top, 16)
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 24) {
                            // Create New Plan Button
                            createNewPlanButton
                            
                            // Active Plans Section
                            if !activePlans.isEmpty {
                                activePlansSection
                            }
                            
                            // Completed Plans Section
                            if !completedPlans.isEmpty {
                                completedPlansSection
                            }
                            
                            // Empty State
                            if activePlans.isEmpty && completedPlans.isEmpty {
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
    
    private var createNewPlanButton: some View {
        Button(action: {
            showingNewPlanSheet = true
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                Text(t.createNewPlan)
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
    
    private var activePlansSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(t.activePlans)
                .font(AppTypography.title3)
                .foregroundColor(.darkGreen)
                .padding(.bottom, 8)
            
            ForEach(activePlans) { plan in
                SavingsPlanCard(plan: plan, texts: t, userData: userData)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var completedPlansSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(t.completedPlans)
                .font(AppTypography.title3)
                .foregroundColor(.darkGreen)
                .padding(.bottom, 8)
            
            ForEach(completedPlans) { plan in
                SavingsPlanCard(plan: plan, texts: t, userData: userData)
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
            Image(systemName: "piggybank")
                .font(.system(size: 64, weight: .light))
                .foregroundColor(.mediumGreen.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(t.noActivePlans)
                    .font(AppTypography.title3)
                    .foregroundColor(.darkGreen)
                
                Text(t.createFirstPlan)
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

// MARK: - Supporting Views

struct SavingsPlanCard: View {
    let plan: SavingsPlan
    let texts: SavingsPlanScreen.SavingsTexts
    let userData: UserData
    
    private var progressPercentage: Double {
        guard plan.targetAmount > 0 else { return 0 }
        return min(plan.currentSavings / plan.targetAmount, 1.0)
    }
    
    private var statusColor: Color {
        if plan.isCompleted { return .green }
        if progressPercentage >= 0.8 { return .mediumGreen }
        if progressPercentage >= 0.5 { return .orange }
        return .red
    }
    
    private var statusText: String {
        if plan.isCompleted { return texts.completed }
        if progressPercentage >= 0.8 { return texts.onTrack }
        return texts.behindSchedule
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(plan.goal)
                        .font(AppTypography.title3)
                        .foregroundColor(.darkGreen)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(statusText)
                        .font(AppTypography.caption)
                        .foregroundColor(statusColor)
                        .fontWeight(.medium)
                }
                
                Spacer(minLength: 12)
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(CurrencyFormatter.format(plan.currentSavings, currency: userData.currency))
                        .font(AppTypography.callout)
                        .foregroundColor(.darkGreen)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text("of \(CurrencyFormatter.format(plan.targetAmount, currency: userData.currency))")
                        .font(AppTypography.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            .frame(minHeight: 50)
            
            // Progress Bar
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(texts.planProgress)
                        .font(AppTypography.callout)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(progressPercentage * 100))%")
                        .font(AppTypography.callout)
                        .foregroundColor(.darkGreen)
                        .fontWeight(.medium)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 10)
                            .cornerRadius(5)
                        
                        Rectangle()
                            .fill(statusColor)
                            .frame(width: geometry.size.width * progressPercentage, height: 10)
                            .cornerRadius(5)
                            .animation(.easeInOut(duration: 0.5), value: progressPercentage)
                    }
                }
                .frame(height: 10)
            }
            
            // Details
            HStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(texts.monthlyAmount)
                        .font(AppTypography.caption)
                        .foregroundColor(.secondary)
                    Text(CurrencyFormatter.format(plan.monthlyAmount, currency: userData.currency))
                        .font(AppTypography.callout)
                        .foregroundColor(.darkGreen)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(texts.duration)
                        .font(AppTypography.caption)
                        .foregroundColor(.secondary)
                    Text("\(plan.duration) \(texts.months)")
                        .font(AppTypography.callout)
                        .foregroundColor(.darkGreen)
                        .fontWeight(.medium)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
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
                InfoRow(label: "Goal", value: planName)
                InfoRow(label: "Target Amount", value: CurrencyFormatter.format(Double(targetAmount) ?? 0, currency: userData.currency))
                InfoRow(label: "Monthly Savings", value: CurrencyFormatter.format(Double(monthlyAmount) ?? 0, currency: userData.currency))
                InfoRow(label: "Duration", value: "\(duration) months")
                
                if let targetAmt = Double(targetAmount), let monthlyAmt = Double(monthlyAmount), targetAmt > 0, monthlyAmt > 0 {
                    let calculatedMonths = Int(ceil(targetAmt / monthlyAmt))
                    InfoRow(label: "Time to Complete", value: "\(calculatedMonths) months")
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

#Preview {
    SavingsPlanScreen()
        .environmentObject(AppState())
} 
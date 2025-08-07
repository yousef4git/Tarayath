import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var showingEditProfile = false
    @State private var showingResetConfirmation = false
    
    private var userData: UserData {
        appState.userData ?? UserData()
    }
    
    private var texts: [AppLanguage: ProfileTexts] = [
        .english: ProfileTexts(
            title: "Profile",
            personalInfo: "Personal Information",
            fullName: "Full Name",
            monthlyIncome: "Monthly Income",
            monthlyObligations: "Monthly Obligations",
            currentBalance: "Current Balance",
            currency: "Currency",
            language: "Language",
            financialSummary: "Financial Summary",
            totalSavingsPlans: "Total Savings Plans",
            activePlans: "Active Plans",
            completedPlans: "Completed Plans",
            totalDecisions: "Purchase Decisions Made",
            appSettings: "App Settings",
            editProfile: "Edit Profile",
            resetData: "Reset All Data",
            backToDashboard: "Back to Dashboard",
            resetConfirmation: "Are you sure you want to reset all data?",
            resetWarning: "This action cannot be undone.",
            cancel: "Cancel",
            reset: "Reset",
            english: "English",
            arabic: "Arabic"
        ),
        .arabic: ProfileTexts(
            title: "الملف الشخصي",
            personalInfo: "المعلومات الشخصية",
            fullName: "الاسم الكامل",
            monthlyIncome: "الدخل الشهري",
            monthlyObligations: "الالتزامات الشهرية",
            currentBalance: "الرصيد الحالي",
            currency: "العملة",
            language: "اللغة",
            financialSummary: "الملخص المالي",
            totalSavingsPlans: "إجمالي خطط الادخار",
            activePlans: "الخطط النشطة",
            completedPlans: "الخطط المكتملة",
            totalDecisions: "قرارات الشراء المتخذة",
            appSettings: "إعدادات التطبيق",
            editProfile: "تعديل الملف الشخصي",
            resetData: "إعادة تعيين جميع البيانات",
            backToDashboard: "العودة للوحة الرئيسية",
            resetConfirmation: "هل أنت متأكد من إعادة تعيين جميع البيانات؟",
            resetWarning: "لا يمكن التراجع عن هذا الإجراء.",
            cancel: "إلغاء",
            reset: "إعادة تعيين",
            english: "الإنجليزية",
            arabic: "العربية"
        )
    ]
    
    struct ProfileTexts {
        let title: String
        let personalInfo: String
        let fullName: String
        let monthlyIncome: String
        let monthlyObligations: String
        let currentBalance: String
        let currency: String
        let language: String
        let financialSummary: String
        let totalSavingsPlans: String
        let activePlans: String
        let completedPlans: String
        let totalDecisions: String
        let appSettings: String
        let editProfile: String
        let resetData: String
        let backToDashboard: String
        let resetConfirmation: String
        let resetWarning: String
        let cancel: String
        let reset: String
        let english: String
        let arabic: String
    }
    
    private var t: ProfileTexts {
        texts[userData.language] ?? texts[.english]!
    }
    
    private var activeSavingsPlans: Int {
        appState.savingsPlans.filter { !$0.isCompleted }.count
    }
    
    private var completedSavingsPlans: Int {
        appState.savingsPlans.filter { $0.isCompleted }.count
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
                            // Personal Information Section
                            personalInfoSection
                            
                            // Financial Summary Section
                            financialSummarySection
                            
                            // App Settings Section
                            appSettingsSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .confirmationDialog(t.resetConfirmation, isPresented: $showingResetConfirmation) {
            Button(t.reset, role: .destructive) {
                appState.resetApp()
            }
            Button(t.cancel, role: .cancel) { }
        } message: {
            Text(t.resetWarning)
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(userData: userData) { updatedUser in
                appState.updateUserData(updatedUser)
                showingEditProfile = false
            } onCancel: {
                showingEditProfile = false
            }
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
    
    private var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(t.personalInfo)
                .font(AppTypography.title3)
                .foregroundColor(.darkGreen)
                .padding(.bottom, 8)
            
            VStack(spacing: 12) {
                InfoRow(label: t.fullName, value: userData.fullName.isEmpty ? "N/A" : userData.fullName)
                InfoRow(label: t.monthlyIncome, value: CurrencyFormatter.format(userData.monthlyIncome, currency: userData.currency))
                InfoRow(label: t.monthlyObligations, value: CurrencyFormatter.format(userData.monthlyObligations, currency: userData.currency))
                InfoRow(label: t.currentBalance, value: CurrencyFormatter.format(userData.currentBalance, currency: userData.currency))
                InfoRow(label: t.currency, value: userData.currency.symbol)
                InfoRow(label: t.language, value: userData.language == .english ? t.english : t.arabic)
            }
            
            Button(action: {
                showingEditProfile = true
            }) {
                Text(t.editProfile)
                    .font(AppTypography.button)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 8)
        }
        .modifier(AppCardStyle())
    }
    
    private var financialSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(t.financialSummary)
                .font(AppTypography.title3)
                .foregroundColor(.darkGreen)
                .padding(.bottom, 8)
            
            VStack(spacing: 12) {
                InfoRow(label: t.totalSavingsPlans, value: "\(appState.savingsPlans.count)")
                InfoRow(label: t.activePlans, value: "\(activeSavingsPlans)")
                InfoRow(label: t.completedPlans, value: "\(completedSavingsPlans)")
                InfoRow(label: t.totalDecisions, value: "\(appState.purchaseDecisions.count)")
            }
        }
        .modifier(AppCardStyle())
    }
    
    private var appSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(t.appSettings)
                .font(AppTypography.title3)
                .foregroundColor(.darkGreen)
                .padding(.bottom, 8)
            
            Button(action: {
                showingResetConfirmation = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    Text(t.resetData)
                        .font(AppTypography.button)
                    Spacer()
                }
                .foregroundColor(.red)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .modifier(AppCardStyle())
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(AppTypography.callout)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(AppTypography.callout)
                .foregroundColor(.darkGreen)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

struct EditProfileView: View {
    @State private var editedUser: UserData
    let onSave: (UserData) -> Void
    let onCancel: () -> Void
    
    init(userData: UserData, onSave: @escaping (UserData) -> Void, onCancel: @escaping () -> Void) {
        self._editedUser = State(initialValue: userData)
        self.onSave = onSave
        self.onCancel = onCancel
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(AppTypography.callout)
                            .foregroundColor(.darkGreen)
                        TextField("Enter your full name", text: $editedUser.fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Monthly Income")
                            .font(AppTypography.callout)
                            .foregroundColor(.darkGreen)
                        TextField("Enter monthly income", value: $editedUser.monthlyIncome, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Monthly Obligations")
                            .font(AppTypography.callout)
                            .foregroundColor(.darkGreen)
                        TextField("Enter monthly obligations", value: $editedUser.monthlyObligations, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current Balance")
                            .font(AppTypography.callout)
                            .foregroundColor(.darkGreen)
                        TextField("Enter current balance", value: $editedUser.currentBalance, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Currency")
                            .font(AppTypography.callout)
                            .foregroundColor(.darkGreen)
                        Picker("Currency", selection: $editedUser.currency) {
                            ForEach(Currency.allCases, id: \.self) { currency in
                                Text("\(currency.rawValue) (\(currency.symbol))")
                                    .tag(currency)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Language")
                            .font(AppTypography.callout)
                            .foregroundColor(.darkGreen)
                        Picker("Language", selection: $editedUser.language) {
                            ForEach(AppLanguage.allCases, id: \.self) { lang in
                                Text(lang == .english ? "English" : "العربية")
                                    .tag(lang)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(editedUser)
                    }
                    .fontWeight(.medium)
                }
            }
        }
    }
}

#Preview {
    ProfileScreen()
        .environmentObject(AppState())
} 
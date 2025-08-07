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
            backToDashboard: "",
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
            backToDashboard: "",
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
                        // Profile Avatar Section
                        profileAvatarSection
                            .padding(.top, 20)
                        
                        // Personal Information Section - Enhanced
                        enhancedPersonalInfoSection
                        
                        // Financial Summary Section - Enhanced
                        enhancedFinancialSummarySection
                        
                        // App Settings Section - Enhanced
                        enhancedAppSettingsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
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
    
    private var profileAvatarSection: some View {
        VStack(spacing: 20) {
            // Profile Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.mediumGreen,
                                Color.darkGreen
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: Color.darkGreen.opacity(0.4), radius: 12, x: 0, y: 6)
                
                Text(userData.fullName.prefix(2).uppercased())
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(Color.creamWhite)
            }
            
            // User Name
            VStack(spacing: 8) {
                Text(userData.fullName.isEmpty ? "User" : userData.fullName)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color.mediumGreen)
                    
                    Text(userData.currency == .SAR ? "Saudi Arabia" : "International")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.darkGreen.opacity(0.8))
                }
            }
        }
    }
    
    private var enhancedPersonalInfoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text(t.personalInfo)
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
            
            VStack(spacing: 16) {
                EnhancedInfoRow(
                    icon: "person.fill",
                    label: t.fullName,
                    value: userData.fullName.isEmpty ? "N/A" : userData.fullName,
                    gradientColors: [Color.lightBrown.opacity(0.6), Color.creamWhite.opacity(0.8)]
                )
                
                EnhancedInfoRow(
                    icon: "dollarsign.circle.fill",
                    label: t.monthlyIncome,
                    value: CurrencyFormatter.format(userData.monthlyIncome, currency: userData.currency),
                    gradientColors: [Color.mediumGreen.opacity(0.5), Color.lightBrown.opacity(0.4)]
                )
                
                EnhancedInfoRow(
                    icon: "list.bullet.circle.fill",
                    label: t.monthlyObligations,
                    value: CurrencyFormatter.format(userData.monthlyObligations, currency: userData.currency),
                    gradientColors: [Color.darkGreen.opacity(0.4), Color.mediumGreen.opacity(0.3)]
                )
                
                EnhancedInfoRow(
                    icon: "creditcard.fill",
                    label: t.currentBalance,
                    value: CurrencyFormatter.format(userData.currentBalance, currency: userData.currency),
                    gradientColors: [Color.creamWhite.opacity(0.7), Color.lightBrown.opacity(0.5)]
                )
                
                EnhancedInfoRow(
                    icon: "coloncurrencysign.circle.fill",
                    label: t.currency,
                    value: userData.currency.symbol,
                    gradientColors: [Color.mediumGreen.opacity(0.4), Color.creamWhite.opacity(0.6)]
                )
                
                EnhancedInfoRow(
                    icon: "globe",
                    label: t.language,
                    value: userData.language == .english ? t.english : t.arabic,
                    gradientColors: [Color.lightBrown.opacity(0.5), Color.mediumGreen.opacity(0.3)]
                )
            }
            
            Button(action: {
                showingEditProfile = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 20))
                    Text(t.editProfile)
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(Color.creamWhite)
                .frame(maxWidth: .infinity)
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
            .padding(.top, 8)
        }
        .padding(.horizontal, 6)
    }
    
    private var enhancedFinancialSummarySection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text(t.financialSummary)
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
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                EnhancedStatCard(
                    icon: "star.circle.fill",
                    title: t.totalSavingsPlans,
                    value: "\(appState.savingsPlans.count)",
                    gradientColors: [Color.mediumGreen, Color.lightBrown]
                )
                
                EnhancedStatCard(
                    icon: "checkmark.circle.fill",
                    title: t.activePlans,
                    value: "\(activeSavingsPlans)",
                    gradientColors: [Color.darkGreen, Color.mediumGreen]
                )
                
                EnhancedStatCard(
                    icon: "trophy.circle.fill",
                    title: t.completedPlans,
                    value: "\(completedSavingsPlans)",
                    gradientColors: [Color.lightBrown, Color.creamWhite.opacity(0.8)]
                )
                
                EnhancedStatCard(
                    icon: "brain.head.profile",
                    title: t.totalDecisions,
                    value: "\(appState.purchaseDecisions.count)",
                    gradientColors: [Color.mediumGreen.opacity(0.8), Color.darkGreen.opacity(0.6)]
                )
            }
        }
        .padding(.horizontal, 6)
    }
    
    private var enhancedAppSettingsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text(t.appSettings)
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
            
            Button(action: {
                showingResetConfirmation = true
            }) {
                HStack(spacing: 16) {
                    Image(systemName: "trash.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(t.resetData)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.red)
                        
                        Text("This will delete all your data")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.red.opacity(0.6))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.red.opacity(0.1),
                                    Color.red.opacity(0.05)
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
                                gradient: Gradient(colors: [Color.red.opacity(0.3), Color.red.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: Color.red.opacity(0.2), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 6)
    }
}

// MARK: - Enhanced Supporting Views

struct EnhancedInfoRow: View {
    let icon: String
    let label: String
    let value: String
    let gradientColors: [Color]
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color.darkGreen)
                .frame(width: 24)
            
            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.darkGreen.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color.darkGreen)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.mediumGreen.opacity(0.3), Color.lightBrown.opacity(0.2)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.darkGreen.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

struct EnhancedStatCard: View {
    let icon: String
    let title: String
    let value: String
    let gradientColors: [Color]
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 6) {
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color.darkGreen.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.creamWhite.opacity(0.7),
                            gradientColors.first?.opacity(0.2) ?? Color.lightBrown.opacity(0.2)
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
                        gradient: Gradient(colors: gradientColors.map { $0.opacity(0.4) }),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: gradientColors.first?.opacity(0.2) ?? Color.clear, radius: 6, x: 0, y: 3)
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
import SwiftUI

struct CollectInfoScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var formData = UserData()
    @State private var formErrors = FormErrors()
    
    struct FormErrors {
        var fullName = false
        var monthlyIncome = false
        var currentBalance = false
    }
    
    private var texts: [AppLanguage: ScreenTexts] = [
        .english: ScreenTexts(
            title: "Let's get to know you",
            subtitle: "Help us create your perfect financial plan",
            fullName: "Full Name",
            fullNamePlaceholder: "Enter your full name",
            monthlyIncome: "Monthly Income",
            monthlyIncomePlaceholder: "Enter your monthly income",
            monthlyObligations: "Monthly Obligations",
            monthlyObligationsPlaceholder: "Enter monthly obligations (rent, bills, etc.)",
            monthlyObligationsOptional: "Optional",
            currentBalance: "Current Balance",
            currentBalancePlaceholder: "How much money do you have now?",
            currency: "Currency",
            getStarted: "Get Started",
            required: "This field is required",
            pleaseComplete: "Please complete all required fields"
        ),
        .arabic: ScreenTexts(
            title: "دعنا نتعرف عليك",
            subtitle: "ساعدنا في إنشاء خطتك المالية المثالية",
            fullName: "الاسم الكامل",
            fullNamePlaceholder: "أدخل اسمك الكامل",
            monthlyIncome: "الدخل الشهري",
            monthlyIncomePlaceholder: "أدخل دخلك الشهري",
            monthlyObligations: "الالتزامات الشهرية",
            monthlyObligationsPlaceholder: "أدخل التزاماتك الشهرية (إيجار، فواتير، إلخ)",
            monthlyObligationsOptional: "اختياري",
            currentBalance: "الرصيد الحالي",
            currentBalancePlaceholder: "كم المال الذي تملكه الآن؟",
            currency: "العملة",
            getStarted: "ابدأ",
            required: "هذا الحقل مطلوب",
            pleaseComplete: "يرجى إكمال جميع الحقول المطلوبة"
        )
    ]
    
    struct ScreenTexts {
        let title: String
        let subtitle: String
        let fullName: String
        let fullNamePlaceholder: String
        let monthlyIncome: String
        let monthlyIncomePlaceholder: String
        let monthlyObligations: String
        let monthlyObligationsPlaceholder: String
        let monthlyObligationsOptional: String
        let currentBalance: String
        let currentBalancePlaceholder: String
        let currency: String
        let getStarted: String
        let required: String
        let pleaseComplete: String
    }
    
    private var t: ScreenTexts {
        texts[formData.language] ?? texts[.english]!
    }
    
    private var isFormValid: Bool {
        !formData.fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        formData.monthlyIncome > 0 &&
        formData.currentBalance >= 0
    }
    
    var body: some View {
        ZStack {
            // Background Gradient - Updated
            AppGradients.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with Language Toggle
                headerView
                
                // Form Content
                ScrollView {
                    VStack(spacing: 24) {
                        // App Logo and Title
                        titleSection
                        
                        // Form Fields
                        formSection
                        
                        // Submit Button
                        submitButton
                        
                        // Error Message
                        if !isFormValid && hasErrors {
                            errorMessage
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .environment(\.layoutDirection, formData.language.isRTL ? .rightToLeft : .leftToRight)
    }
    
    private var headerView: some View {
        HStack {
            if formData.language.isRTL {
                languageToggle
                Spacer()
            } else {
                Spacer()
                languageToggle
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    private var languageToggle: some View {
        HStack(spacing: 4) {
            Button("EN") {
                formData.language = .english
            }
            .foregroundColor(formData.language == .english ? Color.creamWhite : Color.primaryText)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(formData.language == .english ? Color.primaryBackground : Color.clear)
            .cornerRadius(8)
            
            Button("AR") {
                formData.language = .arabic
            }
            .foregroundColor(formData.language == .arabic ? Color.creamWhite : Color.primaryText)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(formData.language == .arabic ? Color.primaryBackground : Color.clear)
            .cornerRadius(8)
        }
        .padding(4)
        .background(Color.cardBackground.opacity(0.9))
        .cornerRadius(12)
        .shadow(color: Color.primaryBackground.opacity(0.2), radius: 2, x: 0, y: 1)
    }
    
    private var titleSection: some View {
        VStack(spacing: 20) {
            // App Logo
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.primaryBackground)
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            
            VStack(spacing: 8) {
                Text(t.title)
                    .font(AppTypography.largeTitle)
                    .foregroundColor(Color.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(t.subtitle)
                    .font(AppTypography.callout)
                    .foregroundColor(Color.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var formSection: some View {
        VStack(spacing: 24) {
            // Full Name
            FormField(
                title: t.fullName,
                placeholder: t.fullNamePlaceholder,
                text: $formData.fullName,
                isRequired: true,
                hasError: formErrors.fullName,
                errorMessage: t.required,
                onTextChange: { _ in
                    if formErrors.fullName {
                        formErrors.fullName = false
                    }
                }
            )
            
            // Monthly Income
            FormField(
                title: t.monthlyIncome,
                placeholder: t.monthlyIncomePlaceholder,
                value: $formData.monthlyIncome,
                currency: formData.currency,
                isRequired: true,
                hasError: formErrors.monthlyIncome,
                errorMessage: t.required,
                onValueChange: { _ in
                    if formErrors.monthlyIncome {
                        formErrors.monthlyIncome = false
                    }
                }
            )
            
            // Monthly Obligations
            FormField(
                title: t.monthlyObligations,
                subtitle: t.monthlyObligationsOptional,
                placeholder: t.monthlyObligationsPlaceholder,
                value: $formData.monthlyObligations,
                currency: formData.currency,
                isRequired: false
            )
            
            // Current Balance
            FormField(
                title: t.currentBalance,
                placeholder: t.currentBalancePlaceholder,
                value: $formData.currentBalance,
                currency: formData.currency,
                isRequired: true,
                hasError: formErrors.currentBalance,
                errorMessage: t.required,
                onValueChange: { _ in
                    if formErrors.currentBalance {
                        formErrors.currentBalance = false
                    }
                }
            )
            
            // Currency Selection
            currencySelection
        }
        .appCardStyle()
        .padding(24)
    }
    
    private var currencySelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(t.currency)
                .font(AppTypography.headline)
                .foregroundColor(Color.primaryText)
                
            HStack(spacing: 12) {
                CurrencyButton(
                    title: "Saudi Riyal",
                    subtitle: "ر.س",
                    isSelected: formData.currency == .SAR
                ) {
                    formData.currency = .SAR
                }
                
                CurrencyButton(
                    title: "US Dollar",
                    subtitle: "$",
                    isSelected: formData.currency == .USD
                ) {
                    formData.currency = .USD
                }
            }
        }
    }
    
    private var submitButton: some View {
        Button(action: handleSubmit) {
            Text(t.getStarted)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1.0 : 0.6)
    }
    
    private var hasErrors: Bool {
        formErrors.fullName || formErrors.monthlyIncome || formErrors.currentBalance
    }
    
    private var errorMessage: some View {
        Text(t.pleaseComplete)
            .font(AppTypography.footnote)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
    }
    
    private func validateForm() -> Bool {
        formErrors.fullName = formData.fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        formErrors.monthlyIncome = formData.monthlyIncome <= 0
        formErrors.currentBalance = formData.currentBalance < 0
        
        return !hasErrors
    }
    
    private func handleSubmit() {
        guard validateForm() else { return }
        
        formData.fullName = formData.fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        appState.updateUserData(formData)
        appState.navigateToScreen(.dashboard)
    }
}

// MARK: - Supporting Views

struct FormField: View {
    let title: String
    var subtitle: String? = nil
    let placeholder: String
    var text: Binding<String>?
    var value: Binding<Double>?
    var currency: Currency?
    let isRequired: Bool
    var hasError: Bool = false
    var errorMessage: String = ""
    var onTextChange: ((String) -> Void)?
    var onValueChange: ((Double) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundColor(Color.primaryText)
                
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                }
                
                if let subtitle = subtitle {
                    Text("(\(subtitle))")
                        .font(AppTypography.caption1)
                        .foregroundColor(Color.secondaryText)
                }
                
                Spacer()
            }
            
            ZStack(alignment: .trailing) {
                if let textBinding = text {
                    TextField(placeholder, text: textBinding)
                        .textFieldStyle(AppTextFieldStyle(hasError: hasError))
                        .onChange(of: textBinding.wrappedValue) { _, newValue in
                            onTextChange?(newValue)
                        }
                } else if let valueBinding = value {
                    TextField(placeholder, value: valueBinding, format: .number)
                        .textFieldStyle(AppTextFieldStyle(hasError: hasError))
                        .keyboardType(.decimalPad)
                        .onChange(of: valueBinding.wrappedValue) { _, newValue in
                            onValueChange?(newValue)
                        }
                }
                
                if let currency = currency {
                    Text(currency.symbol)
                        .font(AppTypography.callout)
                        .foregroundColor(Color.secondaryText)
                        .padding(.trailing, 16)
                }
            }
            
            if hasError && !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(AppTypography.footnote)
                    .foregroundColor(.red)
            }
        }
    }
}

struct CurrencyButton: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(AppTypography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.primaryText)
                
                Text(subtitle)
                    .font(AppTypography.caption1)
                    .foregroundColor(Color.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(isSelected ? Color.primaryBackground.opacity(0.1) : Color.clear)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.primaryBackground : Color.primaryBackground.opacity(0.2), lineWidth: 2)
            )
        }
    }
}

#Preview {
    CollectInfoScreen()
        .environmentObject(AppState())
}
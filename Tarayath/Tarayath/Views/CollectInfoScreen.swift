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
            // Enhanced Gradient Background
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.mediumGreen.opacity(0.8), location: 0.0),
                    .init(color: Color.lightBrown.opacity(0.6), location: 0.4),
                    .init(color: Color.creamWhite.opacity(0.9), location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header Section
                    headerSection
                    
                    // Form Fields Section
                    formFieldsSection
                    
                    // Submit Button
                    submitButton
                    
                    // Error Message
                    if !isFormValid && hasErrors {
                        errorMessage
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 40)
            }
        }
        .environment(\.layoutDirection, formData.language.isRTL ? .rightToLeft : .leftToRight)
    }
    
    private var headerSection: some View {
        VStack(spacing: 24) {
            // Language Toggle - Moved to top right
            HStack {
                Spacer()
                languageToggle
            }
            
            // App Logo Section
            VStack(spacing: 20) {
                // Logo with enhanced styling
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.darkGreen,
                                    Color.mediumGreen
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .shadow(color: Color.darkGreen.opacity(0.4), radius: 12, x: 0, y: 6)
                    
                    Image("Screenshot 1447-02-12 at 11.03.28 AM")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
                
                // Title Section with better styling
                VStack(spacing: 12) {
                    Text(t.title)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.darkGreen, Color.mediumGreen]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .multilineTextAlignment(.center)
                    
                    Text(t.subtitle)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.darkGreen.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private var languageToggle: some View {
        HStack(spacing: 0) {
            Button("EN") {
                withAnimation(.spring()) {
                    formData.language = .english
                }
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(formData.language == .english ? Color.creamWhite : Color.darkGreen)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                formData.language == .english 
                    ? Color.darkGreen
                    : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Button("AR") {
                withAnimation(.spring()) {
                    formData.language = .arabic
                }
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(formData.language == .arabic ? Color.creamWhite : Color.darkGreen)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                formData.language == .arabic 
                    ? Color.darkGreen
                    : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.creamWhite.opacity(0.9))
                .shadow(color: Color.darkGreen.opacity(0.2), radius: 6, x: 0, y: 3)
        )
    }
    
    private var formFieldsSection: some View {
        VStack(spacing: 24) {
            // Full Name Field
            EnhancedFormField(
                title: t.fullName,
                placeholder: t.fullNamePlaceholder,
                text: $formData.fullName,
                isRequired: true,
                hasError: formErrors.fullName,
                errorMessage: t.required,
                icon: "person.fill",
                fieldType: .text,
                onTextChange: { _ in
                    if formErrors.fullName {
                        formErrors.fullName = false
                    }
                }
            )
            
            // Monthly Income Field
            EnhancedFormField(
                title: t.monthlyIncome,
                placeholder: t.monthlyIncomePlaceholder,
                value: $formData.monthlyIncome,
                currency: formData.currency,
                isRequired: true,
                hasError: formErrors.monthlyIncome,
                errorMessage: t.required,
                icon: "dollarsign.circle.fill",
                fieldType: .currency,
                onValueChange: { _ in
                    if formErrors.monthlyIncome {
                        formErrors.monthlyIncome = false
                    }
                }
            )
            
            // Monthly Obligations Field
            EnhancedFormField(
                title: t.monthlyObligations,
                subtitle: t.monthlyObligationsOptional,
                placeholder: t.monthlyObligationsPlaceholder,
                value: $formData.monthlyObligations,
                currency: formData.currency,
                isRequired: false,
                icon: "list.bullet.circle.fill",
                fieldType: .currency
            )
            
            // Current Balance Field
            EnhancedFormField(
                title: t.currentBalance,
                placeholder: t.currentBalancePlaceholder,
                value: $formData.currentBalance,
                currency: formData.currency,
                isRequired: true,
                hasError: formErrors.currentBalance,
                errorMessage: t.required,
                icon: "creditcard.fill",
                fieldType: .currency,
                onValueChange: { _ in
                    if formErrors.currentBalance {
                        formErrors.currentBalance = false
                    }
                }
            )
            
            // Currency Selection
            currencySelection
        }
    }
    
    private var currencySelection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "coloncurrencysign.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color.darkGreen)
                Text(t.currency)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.darkGreen)
                Spacer()
            }
            
            HStack(spacing: 16) {
                EnhancedCurrencyButton(
                    title: "Saudi Riyal",
                    subtitle: "ر.س",
                    isSelected: formData.currency == .SAR
                ) {
                    withAnimation(.spring()) {
                        formData.currency = .SAR
                    }
                }
                
                EnhancedCurrencyButton(
                    title: "US Dollar",
                    subtitle: "$",
                    isSelected: formData.currency == .USD
                ) {
                    withAnimation(.spring()) {
                        formData.currency = .USD
                    }
                }
            }
        }
        .padding(.top, 8)
    }
    
    private var submitButton: some View {
        Button(action: handleSubmit) {
            HStack(spacing: 12) {
                Text(t.getStarted)
                    .font(.system(size: 18, weight: .bold))
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 20))
            }
            .foregroundColor(Color.creamWhite)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.mediumGreen, Color.darkGreen]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: Color.darkGreen.opacity(0.4), radius: 12, x: 0, y: 6)
        }
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1.0 : 0.6)
        .scaleEffect(isFormValid ? 1.0 : 0.98)
        .animation(.spring(), value: isFormValid)
        .padding(.top, 16)
    }
    
    private var hasErrors: Bool {
        formErrors.fullName || formErrors.monthlyIncome || formErrors.currentBalance
    }
    
    private var errorMessage: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(t.pleaseComplete)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.red)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                )
        )
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

// MARK: - Enhanced Form Field Component

enum FieldType {
    case text
    case currency
}

struct EnhancedFormField: View {
    let title: String
    var subtitle: String? = nil
    let placeholder: String
    var text: Binding<String>?
    var value: Binding<Double>?
    var currency: Currency?
    let isRequired: Bool
    var hasError: Bool = false
    var errorMessage: String = ""
    let icon: String
    let fieldType: FieldType
    var onTextChange: ((String) -> Void)?
    var onValueChange: ((Double) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Field Title with Icon
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(Color.darkGreen)
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.darkGreen)
                
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                        .font(.system(size: 16, weight: .bold))
                }
                
                if let subtitle = subtitle {
                    Text("(\(subtitle))")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.darkGreen.opacity(0.6))
                }
                
                Spacer()
            }
            
            // Input Field
            ZStack(alignment: .trailing) {
                if fieldType == .text, let textBinding = text {
                    TextField(placeholder, text: textBinding)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color.darkGreen)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
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
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    hasError 
                                        ? Color.red
                                        : Color.mediumGreen.opacity(0.4),
                                    lineWidth: hasError ? 2 : 1.5
                                )
                        )
                        .shadow(
                            color: Color.mediumGreen.opacity(0.1),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                        .onChange(of: textBinding.wrappedValue) { _, newValue in
                            onTextChange?(newValue)
                        }
                } else if fieldType == .currency, let valueBinding = value {
                    TextField(placeholder, value: valueBinding, format: .number)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color.darkGreen)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .padding(.trailing, currency != nil ? 50 : 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
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
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    hasError 
                                        ? Color.red
                                        : Color.mediumGreen.opacity(0.4),
                                    lineWidth: hasError ? 2 : 1.5
                                )
                        )
                        .shadow(
                            color: Color.mediumGreen.opacity(0.1),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                        .keyboardType(.decimalPad)
                        .onChange(of: valueBinding.wrappedValue) { _, newValue in
                            onValueChange?(newValue)
                        }
                }
                
                // Currency Symbol
                if let currency = currency, fieldType == .currency {
                    Text(currency.symbol)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.darkGreen.opacity(0.7))
                        .padding(.trailing, 20)
                }
            }
            
            // Error Message
            if hasError && !errorMessage.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.red)
                }
            }
        }
    }
}

// MARK: - Enhanced Currency Button

struct EnhancedCurrencyButton: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(subtitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isSelected ? Color.creamWhite : Color.darkGreen)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? Color.creamWhite.opacity(0.9) : Color.darkGreen.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected 
                            ? LinearGradient(
                                gradient: Gradient(colors: [Color.mediumGreen, Color.darkGreen]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.creamWhite.opacity(0.7),
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
                        isSelected 
                            ? Color.clear
                            : Color.mediumGreen.opacity(0.4),
                        lineWidth: 1.5
                    )
            )
            .shadow(
                color: isSelected 
                    ? Color.darkGreen.opacity(0.4)
                    : Color.mediumGreen.opacity(0.1),
                radius: isSelected ? 8 : 4,
                x: 0,
                y: isSelected ? 4 : 2
            )
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    CollectInfoScreen()
        .environmentObject(AppState())
}
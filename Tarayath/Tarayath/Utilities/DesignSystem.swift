import SwiftUI

// MARK: - Color Extensions
extension Color {
    // Theme-aware colors
    static let appBackground = Color("AppBackground")
    static let appForeground = Color("AppForeground")
    static let appPrimary = Color("AppPrimary")
    static let appPrimaryForeground = Color("AppPrimaryForeground")
    static let appSecondary = Color("AppSecondary")
    static let appSecondaryForeground = Color("AppSecondaryForeground")
    static let appCard = Color("AppCard")
    static let appBorder = Color("AppBorder")
    
    // Design system colors - Updated as per requirements
    static let darkGreen = Color(hex: "#435446")      // Dark theme main color
    static let mediumGreen = Color(hex: "#819067")    // Regular theme main color
    static let creamWhite = Color(hex: "#FEFAE0")     // Text color
    static let lightBrown = Color(hex: "#B1AB86")     // Action buttons
    
    // Improved input field colors
    static let inputFieldBackground = Color(hex: "#E5E5E5")
    static let inputFieldText = Color.darkGreen
    
    // Theme-adaptive colors (simplified for compatibility)
    static var primaryBackground: Color { mediumGreen }
    static var secondaryBackground: Color { lightBrown.opacity(0.7) }
    static var primaryText: Color { darkGreen }
    static var secondaryText: Color { darkGreen.opacity(0.7) }
    static var inputBackground: Color { inputFieldBackground }
    static var inputText: Color { inputFieldText }
    static var cardBackground: Color { Color.white }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Typography System (Apple Guidelines)
struct AppTypography {
    // Apple's recommended font sizes and weights
    static let largeTitle = Font.system(size: 34, weight: .regular, design: .default)
    static let title1 = Font.system(size: 28, weight: .regular, design: .default)
    static let title2 = Font.system(size: 22, weight: .regular, design: .default)
    static let title3 = Font.system(size: 20, weight: .regular, design: .default)
    static let headline = Font.system(size: 17, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    static let caption1 = Font.system(size: 12, weight: .regular, design: .default)
    static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
    
    // Legacy support for existing code
    static let title = Font.system(size: 20, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    
    // Custom button typography
    static let button = Font.system(size: 17, weight: .semibold, design: .default)
    static let buttonSmall = Font.system(size: 15, weight: .medium, design: .default)
    
    // Arabic-optimized fonts
    static func arabicFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.system(size: size, weight: weight, design: .default)
    }
}

// MARK: - Background Gradient System
struct AppGradients {
    static var primaryGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.primaryBackground,
                Color.primaryBackground.opacity(0.1)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static var cardGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.cardBackground,
                Color.cardBackground.opacity(0.95)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static var splashGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.mediumGreen,
                Color.creamWhite
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.button)
            .foregroundColor(colorScheme == .dark ? Color.darkGreen : Color.creamWhite)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .frame(minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primaryBackground)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
            .shadow(
                color: Color.primaryBackground.opacity(0.3),
                radius: configuration.isPressed ? 2 : 4,
                x: 0,
                y: configuration.isPressed ? 1 : 2
            )
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.button)
            .foregroundColor(Color.primaryText)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .frame(minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.lightBrown.opacity(colorScheme == .dark ? 0.3 : 0.7))
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.button)
            .foregroundColor(Color.primaryText)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .frame(minHeight: 50)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primaryBackground, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Input Field Styles
struct AppTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme
    let hasError: Bool
    
    init(hasError: Bool = false) {
        self.hasError = hasError
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(AppTypography.body)
            .foregroundColor(Color.inputText)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.inputBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        hasError ? Color.red : Color.primaryBackground.opacity(0.3),
                        lineWidth: hasError ? 2 : 1
                    )
            )
            .shadow(
                color: Color.primaryBackground.opacity(0.1),
                radius: 2,
                x: 0,
                y: 1
            )
    }
}

// MARK: - Card Style
struct AppCardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color.primaryBackground.opacity(0.2),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: colorScheme == .dark 
                    ? Color.black.opacity(0.3)
                    : Color.primaryBackground.opacity(0.15),
                radius: 8,
                x: 0,
                y: 4
            )
    }
}

extension View {
    func appCardStyle() -> some View {
        modifier(AppCardStyle())
    }
}

// MARK: - Navigation Bar Styling
struct AppNavigationBarStyle: ViewModifier {
    let title: String
    let showBackButton: Bool
    let backAction: (() -> Void)?
    
    init(title: String, showBackButton: Bool = false, backAction: (() -> Void)? = nil) {
        self.title = title
        self.showBackButton = showBackButton
        self.backAction = backAction
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(showBackButton)
            .toolbar {
                if showBackButton {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: backAction ?? {}) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(AppTypography.buttonSmall)
                                    .fontWeight(.medium)
                                Text("Back")
                                    .font(AppTypography.buttonSmall)
                            }
                            .foregroundColor(Color.primaryText)
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(AppTypography.headline)
                        .foregroundColor(Color.primaryText)
                }
            }
    }
}

extension View {
    func appNavigationBar(title: String, showBackButton: Bool = false, backAction: (() -> Void)? = nil) -> some View {
        modifier(AppNavigationBarStyle(title: title, showBackButton: showBackButton, backAction: backAction))
    }
}

// MARK: - RTL Layout Support
struct RTLAwareHStack<Content: View>: View {
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content
    
    @Environment(\.layoutDirection) var layoutDirection
    
    init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        if layoutDirection == .rightToLeft {
            HStack(alignment: alignment, spacing: spacing) {
                content()
            }
            .flipsForRightToLeftLayoutDirection(true)
        } else {
            HStack(alignment: alignment, spacing: spacing) {
                content()
            }
        }
    }
}

// MARK: - Status Bar Configuration
struct StatusBarStyle: ViewModifier {
    let style: UIStatusBarStyle
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                UIApplication.shared.statusBarStyle = style
            }
    }
}

extension View {
    func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
        modifier(StatusBarStyle(style: style))
    }
}

// MARK: - Formatting Utilities
struct CurrencyFormatter {
    static func format(_ amount: Double, currency: Currency) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        guard let formattedNumber = formatter.string(from: NSNumber(value: amount)) else {
            return "\(currency.symbol)0"
        }
        
        return currency == .SAR ? "\(formattedNumber) \(currency.symbol)" : "\(currency.symbol)\(formattedNumber)"
    }
}

// MARK: - Accessibility Support
struct AccessibleText: ViewModifier {
    let accessibilityLabel: String?
    let accessibilityHint: String?
    
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(accessibilityLabel ?? "")
            .accessibilityHint(accessibilityHint ?? "")
    }
}

extension View {
    func accessibleText(label: String? = nil, hint: String? = nil) -> some View {
        modifier(AccessibleText(accessibilityLabel: label, accessibilityHint: hint))
    }
}

// MARK: - Text Localization
struct LocalizedText {
    let english: String
    let arabic: String
    
    func text(for language: AppLanguage) -> String {
        return language == .arabic ? arabic : english
    }
}

// MARK: - Animation Presets
struct AppAnimations {
    static let gentle = Animation.easeInOut(duration: 0.3)
    static let quick = Animation.easeInOut(duration: 0.15)
    static let spring = Animation.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)
    static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)
}
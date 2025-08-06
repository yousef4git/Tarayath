import SwiftUI

// MARK: - Color Extensions
extension Color {
    static let appBackground = Color("AppBackground")
    static let appForeground = Color("AppForeground")
    static let appPrimary = Color("AppPrimary")
    static let appPrimaryForeground = Color("AppPrimaryForeground")
    static let appSecondary = Color("AppSecondary")
    static let appSecondaryForeground = Color("AppSecondaryForeground")
    static let appCard = Color("AppCard")
    static let appBorder = Color("AppBorder")
    
    // Define colors directly for immediate use
    static let darkGreen = Color(hex: "#435446")
    static let mediumGreen = Color(hex: "#819067")
    static let creamWhite = Color(hex: "#FEFAE0")
    static let lightBrown = Color(hex: "#B1AB86")
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

// MARK: - Typography Styles
struct AppTypography {
    static let largeTitle = Font.system(size: 24, weight: .bold, design: .default)
    static let title = Font.system(size: 20, weight: .semibold, design: .default)
    static let title3 = Font.system(size: 18, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let callout = Font.system(size: 16, weight: .medium, design: .default)
    static let caption = Font.system(size: 14, weight: .regular, design: .default)
    static let button = Font.system(size: 17, weight: .medium, design: .default)
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.button)
            .foregroundColor(.creamWhite)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color.mediumGreen)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.button)
            .foregroundColor(.darkGreen)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color.lightBrown)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.button)
            .foregroundColor(.darkGreen)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.mediumGreen.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Card Style
struct AppCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.mediumGreen.opacity(0.1), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.mediumGreen.opacity(0.1), lineWidth: 1)
            )
    }
}

extension View {
    func appCardStyle() -> some View {
        modifier(AppCardStyle())
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

// MARK: - Text Localization
struct LocalizedText {
    let english: String
    let arabic: String
    
    func text(for language: AppLanguage) -> String {
        return language == .arabic ? arabic : english
    }
}
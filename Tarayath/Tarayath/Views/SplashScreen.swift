import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var showContent = false
    @State private var navigateAutomatically = false
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.mediumGreen, Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                // App Logo
                VStack(spacing: 24) {
                    Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .scaleEffect(showContent ? 1.0 : 0.8)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: showContent)
                    
                    // App Name
                    VStack(spacing: 8) {
                        Text("Tarayath")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.darkGreen)
                        
                        Text("تريّث")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.darkGreen.opacity(0.8))
                    }
                    .opacity(showContent ? 1.0 : 0.0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.3), value: showContent)
                    
                    // Tagline
                    VStack(spacing: 4) {
                        Text("Your Personal Finance Planner")
                            .font(AppTypography.callout)
                            .foregroundColor(.darkGreen.opacity(0.8))
                        
                        Text("مخطط أموالك الشخصي")
                            .font(AppTypography.caption)
                            .foregroundColor(.darkGreen.opacity(0.6))
                    }
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1.0 : 0.0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.6), value: showContent)
                }
                
                Spacer()
                
                // Get Started Button
                Button(action: handleGetStarted) {
                    HStack(spacing: 12) {
                        Text("Get Started")
                            .fontWeight(.medium)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .opacity(showContent ? 1.0 : 0.0)
                .offset(y: showContent ? 0 : 30)
                .animation(.easeOut(duration: 0.6).delay(0.9), value: showContent)
                
                // Progress Indicator
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(Color.mediumGreen.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(showContent && index == 0 ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.5).delay(Double(index) * 0.2), value: showContent)
                    }
                }
                .padding(.bottom, 40)
                .opacity(showContent ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6).delay(1.2), value: showContent)
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation {
                showContent = true
            }
            
            // Auto-navigate after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if !navigateAutomatically {
                    handleGetStarted()
                }
            }
        }
        .onTapGesture {
            if showContent {
                handleGetStarted()
            }
        }
    }
    
    private func handleGetStarted() {
        navigateAutomatically = true
        
        if appState.userData != nil {
            appState.navigateToScreen(.dashboard)
        } else {
            appState.navigateToScreen(.collectInfo)
        }
    }
}

#Preview {
    SplashScreen()
        .environmentObject(AppState())
} 
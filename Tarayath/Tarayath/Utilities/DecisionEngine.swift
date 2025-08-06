import Foundation

// MARK: - Decision Engine

struct DecisionEngine {
    
    // MARK: - Main Evaluation Function
    
    static func evaluate(decision: inout PurchaseDecision, userData: UserData, savingsPlans: [SavingsPlan]) {
        let context = EvaluationContext(
            userData: userData,
            savingsPlans: savingsPlans,
            decision: decision
        )
        
        // Calculate insight cards
        let wastingMoney = evaluateWastingMoney(context: context)
        let needingMoneyLater = evaluateNeedingMoneyLater(context: context)
        let realizingDidntNeed = evaluateRealizingDidntNeed(context: context)
        let feelingGuiltyRushed = evaluateFeelingGuiltyRushed(context: context)
        
        // Store insight cards
        decision.insightCards = [
            "wastingMoney": wastingMoney,
            "needingMoneyLater": needingMoneyLater,
            "realizingDidntNeed": realizingDidntNeed,
            "feelingGuiltyRushed": feelingGuiltyRushed
        ]
        
        // Calculate final verdict
        decision.finalVerdict = calculateFinalVerdict(context: context, insights: decision.insightCards)
        
        // Update legacy decision field for backward compatibility
        decision.decision = decision.finalVerdict.displayText
    }
    
    // MARK: - Insight Card Evaluations
    
    private static func evaluateWastingMoney(context: EvaluationContext) -> String {
        let isWorkStudyProject = context.decision.whyReason.lowercased().contains("work") ||
                                context.decision.whyReason.lowercased().contains("study") ||
                                context.decision.whyReason.lowercased().contains("project")
        
        let isHighCost = context.decision.price > (context.userData.monthlyIncome * 0.3)
        
        if isWorkStudyProject {
            return "Based on your reasons (work/study/project), this item is a useful investment."
        } else if isHighCost {
            return "This item is mostly emotional or fun-based. At this cost, it may not bring long-term value."
        } else {
            return "This purchase seems reasonable for personal enjoyment within your budget."
        }
    }
    
    private static func evaluateNeedingMoneyLater(context: EvaluationContext) -> String {
        let balanceAfterPurchase = context.userData.currentBalance - context.decision.price
        let safeBuffer = context.userData.monthlyIncome * 3
        
        let hasUrgentGoals = context.savingsPlans.contains { plan in
            !plan.isCompleted && plan.duration <= 3
        }
        
        if balanceAfterPurchase >= safeBuffer {
            return "After buying, your savings will remain above a safe buffer. You're secure."
        } else if hasUrgentGoals {
            return "This purchase will impact your urgent savings goals. Consider the timing."
        } else {
            return "This purchase will reduce your savings below a safe level. It could impact future goals."
        }
    }
    
    private static func evaluateRealizingDidntNeed(context: EvaluationContext) -> String {
        let isFirstTime = !context.decision.hasDuplicate
        let isHighCost = context.decision.price > (context.userData.monthlyIncome * 0.5)
        let isEmotional = context.decision.emojiFeel == "🤩"
        
        if isFirstTime && !isEmotional {
            return "You don't own anything like this, and your answers show it will fill a real need."
        } else if isFirstTime && isHighCost && isEmotional {
            return "This seems like a first-time, high-cost purchase driven by emotion — regret is possible."
        } else if context.decision.hasDuplicate {
            return "You already own something similar. Consider if this upgrade is truly necessary."
        } else {
            return "Based on your answers, this purchase seems well-considered."
        }
    }
    
    private static func evaluateFeelingGuiltyRushed(context: EvaluationContext) -> String {
        let isRushed = context.decision.emojiWhen == "⚡️"
        let isRecentWant = context.decision.wantedSince.lowercased().contains("recent")
        let isLongTermWant = context.decision.wantedSince.lowercased().contains("months")
        
        if isLongTermWant && !isRushed {
            return "You've wanted this for a while and answered thoughtfully. This isn't a rushed decision."
        } else if isRecentWant || isRushed {
            return "It seems like a recent want, and somewhat urgent. Guilt or second thoughts may follow."
        } else {
            return "Your timing seems reasonable. You've given this appropriate consideration."
        }
    }
    
    // MARK: - Final Verdict Calculation
    
    private static func calculateFinalVerdict(context: EvaluationContext, insights: [String: String]) -> PurchaseVerdict {
        var score = 0
        
        // Positive factors
        let isWorkStudyProject = context.decision.whyReason.lowercased().contains("work") ||
                                context.decision.whyReason.lowercased().contains("study") ||
                                context.decision.whyReason.lowercased().contains("project")
        if isWorkStudyProject { score += 2 }
        
        let balanceAfterPurchase = context.userData.currentBalance - context.decision.price
        let safeBuffer = context.userData.monthlyIncome * 3
        if balanceAfterPurchase >= safeBuffer { score += 2 }
        
        let isLongTermWant = context.decision.wantedSince.lowercased().contains("months")
        if isLongTermWant { score += 1 }
        
        let isNotRushed = context.decision.emojiWhen != "⚡️"
        if isNotRushed { score += 1 }
        
        // Negative factors
        let isHighCost = context.decision.price > (context.userData.monthlyIncome * 0.5)
        if isHighCost { score -= 2 }
        
        let hasUrgentGoals = context.savingsPlans.contains { plan in
            !plan.isCompleted && plan.duration <= 3
        }
        if hasUrgentGoals { score -= 1 }
        
        let isRushed = context.decision.emojiWhen == "⚡️"
        if isRushed { score -= 1 }
        
        let isRecentWant = context.decision.wantedSince.lowercased().contains("recent")
        if isRecentWant { score -= 1 }
        
        // Determine verdict based on score
        if score >= 3 {
            return .yes
        } else if score >= 0 {
            return .wait
        } else {
            return .no
        }
    }
}

// MARK: - Supporting Types

private struct EvaluationContext {
    let userData: UserData
    let savingsPlans: [SavingsPlan]
    let decision: PurchaseDecision
}
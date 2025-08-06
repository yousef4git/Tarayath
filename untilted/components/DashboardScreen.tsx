import React, { useState } from 'react';
import { type UserData, type SavingsPlan, type BudgetBuckets, type PurchaseDecision, formatCurrency } from '../utils/localStorage';
import { HistoryPanel } from './HistoryPanel';

interface DashboardScreenProps {
  userData: UserData | null;
  savingsPlans: SavingsPlan[];
  purchaseDecisions: PurchaseDecision[];
  budgetBuckets: BudgetBuckets;
  onNavigate: (screen: string) => void;
  onUpdateBudgetBuckets: (buckets: BudgetBuckets) => void;
  onResetApp: () => void;
}

export function DashboardScreen({ 
  userData, 
  savingsPlans, 
  purchaseDecisions,
  budgetBuckets, 
  onNavigate, 
  onUpdateBudgetBuckets,
  onResetApp 
}: DashboardScreenProps) {
  const [showHistory, setShowHistory] = useState(false);

  if (!userData) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <h2>No user data found</h2>
          <button
            onClick={() => onNavigate('collect-info')}
            className="mt-4 bg-primary text-primary-foreground px-6 py-2 rounded-lg"
          >
            Set up profile
          </button>
        </div>
      </div>
    );
  }

  const totalSavings = userData.monthlyIncome - userData.monthlyObligations;
  const activeSavingsPlans = savingsPlans.filter(plan => !plan.isCompleted);
  const totalPlannedSavings = activeSavingsPlans.reduce((sum, plan) => sum + plan.monthlyAmount, 0);
  const availableSavings = Math.max(0, totalSavings - totalPlannedSavings);
  
  // Calculate actual money amounts for budget buckets
  const needsAmount = (userData.monthlyIncome * budgetBuckets.needs) / 100;
  const wantsAmount = (userData.monthlyIncome * budgetBuckets.wants) / 100;
  const savingsAmount = (userData.monthlyIncome * budgetBuckets.savings) / 100;
  
  // Calculate net available balance (current balance - obligations - saving plans)
  const netAvailable = userData.currentBalance - userData.monthlyObligations - totalPlannedSavings;

  const texts = {
    en: {
      welcome: `Hi ${userData.fullName.split(' ')[0]}!`,
      subtitle: 'Your financial overview',
      monthlyIncome: 'Monthly Income',
      monthlyObligations: 'Monthly Obligations',
      currentBalance: 'Current Balance',
      totalSaved: 'Total in Savings Plans',
      netAvailable: 'Net Available',
      activePlans: 'Active Plans',
      startSavingPlan: 'Start Saving Plan',
      decisionHelper: 'Decision Helper',
      recommendations: 'Recommendations',
      soonFeature: 'Soon feature',
      budgetAllocation: 'Budget Allocation',
      needs: 'Needs',
      wants: 'Wants',
      savings: 'Savings',
      history: 'History',
      profile: 'Profile'
    },
    ar: {
      welcome: `مرحباً ${userData.fullName.split(' ')[0]}!`,
      subtitle: 'نظرة عامة على وضعك المالي',
      monthlyIncome: 'الدخل الشهري',
      monthlyObligations: 'الالتزامات الشهرية',
      currentBalance: 'الرصيد الحالي',
      totalSaved: 'إجمالي خطط الادخار',
      netAvailable: 'الصافي المتاح',
      activePlans: 'الخطط النشطة',
      startSavingPlan: 'ابدأ خطة ادخار',
      decisionHelper: 'مساعد القرارات',
      recommendations: 'التوصيات',
      soonFeature: 'ميزة قريباً',
      budgetAllocation: 'توزيع الميزانية',
      needs: 'الاحتياجات',
      wants: 'الرغبات',
      savings: 'الادخار',
      history: 'السجل',
      profile: 'الملف الشخصي'
    }
  };

  const t = texts[userData.language || 'en'];

  const handleAmountChange = (category: 'needs' | 'wants' | 'savings', amount: number) => {
    // Calculate new percentage for the changed category
    const newPercentage = Math.round((amount / userData.monthlyIncome) * 100);
    
    // Calculate remaining amount for other categories
    const remainingAmount = userData.monthlyIncome - amount;
    
    if (category === 'needs') {
      const wantsSavingsTotal = budgetBuckets.wants + budgetBuckets.savings;
      const wantsRatio = wantsSavingsTotal > 0 ? budgetBuckets.wants / wantsSavingsTotal : 0.5;
      const newWantsPercentage = Math.round(((100 - newPercentage) * wantsRatio));
      const newSavingsPercentage = 100 - newPercentage - newWantsPercentage;
      
      onUpdateBudgetBuckets({
        needs: newPercentage,
        wants: newWantsPercentage,
        savings: newSavingsPercentage
      });
    } else if (category === 'wants') {
      const needsSavingsTotal = budgetBuckets.needs + budgetBuckets.savings;
      const needsRatio = needsSavingsTotal > 0 ? budgetBuckets.needs / needsSavingsTotal : 0.5;
      const newNeedsPercentage = Math.round(((100 - newPercentage) * needsRatio));
      const newSavingsPercentage = 100 - newPercentage - newNeedsPercentage;
      
      onUpdateBudgetBuckets({
        needs: newNeedsPercentage,
        wants: newPercentage,
        savings: newSavingsPercentage
      });
    } else { // savings
      const needsWantsTotal = budgetBuckets.needs + budgetBuckets.wants;
      const needsRatio = needsWantsTotal > 0 ? budgetBuckets.needs / needsWantsTotal : 0.5;
      const newNeedsPercentage = Math.round(((100 - newPercentage) * needsRatio));
      const newWantsPercentage = 100 - newPercentage - newNeedsPercentage;
      
      onUpdateBudgetBuckets({
        needs: newNeedsPercentage,
        wants: newWantsPercentage,
        savings: newPercentage
      });
    }
  };

  const handlePercentageChange = (category: 'needs' | 'wants' | 'savings', percentage: number) => {
    if (category === 'needs') {
      const wantsSavingsTotal = budgetBuckets.wants + budgetBuckets.savings;
      const wantsRatio = wantsSavingsTotal > 0 ? budgetBuckets.wants / wantsSavingsTotal : 0.5;
      const newWantsPercentage = Math.round(((100 - percentage) * wantsRatio));
      const newSavingsPercentage = 100 - percentage - newWantsPercentage;
      
      onUpdateBudgetBuckets({
        needs: percentage,
        wants: newWantsPercentage,
        savings: newSavingsPercentage
      });
    } else if (category === 'wants') {
      const needsSavingsTotal = budgetBuckets.needs + budgetBuckets.savings;
      const needsRatio = needsSavingsTotal > 0 ? budgetBuckets.needs / needsSavingsTotal : 0.5;
      const newNeedsPercentage = Math.round(((100 - percentage) * needsRatio));
      const newSavingsPercentage = 100 - percentage - newNeedsPercentage;
      
      onUpdateBudgetBuckets({
        needs: newNeedsPercentage,
        wants: percentage,
        savings: newSavingsPercentage
      });
    } else { // savings
      const needsWantsTotal = budgetBuckets.needs + budgetBuckets.wants;
      const needsRatio = needsWantsTotal > 0 ? budgetBuckets.needs / needsWantsTotal : 0.5;
      const newNeedsPercentage = Math.round(((100 - percentage) * needsRatio));
      const newWantsPercentage = 100 - percentage - newNeedsPercentage;
      
      onUpdateBudgetBuckets({
        needs: newNeedsPercentage,
        wants: newWantsPercentage,
        savings: percentage
      });
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-white to-[#819067]/5 safe-area-top safe-area-bottom" dir={userData.language === 'ar' ? 'rtl' : 'ltr'}>
      {/* Header */}
      <div className="bg-white border-b border-[#819067]/10">
        <div className="px-6 py-6">
          <div className="flex items-center justify-between">
            {/* History Icon (Top Left) */}
            <button
              onClick={() => setShowHistory(true)}
              className="w-10 h-10 bg-[#819067]/10 rounded-full flex items-center justify-center hover:bg-[#819067]/20 transition-colors"
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                <path d="M3 3H21V7H3V3ZM3 11H21V15H3V11ZM3 19H21V23H3V19Z" fill="#435446"/>
              </svg>
            </button>

            <div className="text-center">
              <h1 className="text-2xl font-bold text-[#435446]">{t.welcome}</h1>
              <p className="text-[#435446]/70">{t.subtitle}</p>
            </div>

            {/* Profile Icon (Top Right) */}
            <button
              onClick={() => onNavigate('profile')}
              className="w-10 h-10 bg-[#819067]/10 rounded-full flex items-center justify-center hover:bg-[#819067]/20 transition-colors"
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                <path
                  d="M20 21V19C20 17.9391 19.5786 16.9217 18.8284 16.1716C18.0783 15.4214 17.0609 15 16 15H8C6.93913 15 5.92172 15.4214 5.17157 16.1716C4.42143 16.9217 4 17.9391 4 19V21"
                  stroke="#435446"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
                <circle
                  cx="12"
                  cy="7"
                  r="4"
                  stroke="#435446"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </button>
          </div>
        </div>
      </div>

      <div className="px-6 py-6 space-y-6">
        {/* Financial Overview with Quick Stats */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10">
          <div className="grid grid-cols-2 gap-4 mb-6">
            <div className="text-center">
              <p className="text-sm text-[#435446]/60 mb-1">{t.monthlyIncome}</p>
              <p className="text-lg font-semibold text-[#435446]">
                {formatCurrency(userData.monthlyIncome, userData.currency)}
              </p>
            </div>
            <div className="text-center">
              <p className="text-sm text-[#435446]/60 mb-1">{t.currentBalance}</p>
              <p className="text-lg font-semibold text-[#819067]">
                {formatCurrency(userData.currentBalance, userData.currency)}
              </p>
            </div>
          </div>

          <div className="space-y-4">
            <div className="flex justify-between items-center p-4 bg-[#819067]/5 rounded-xl">
              <span className="text-[#435446]/80">{t.monthlyObligations}</span>
              <span className="font-semibold text-[#435446]">
                {formatCurrency(userData.monthlyObligations, userData.currency)}
              </span>
            </div>
            
            <div className="flex justify-between items-center p-4 bg-[#B1AB86]/10 rounded-xl">
              <span className="text-[#435446]/80">{t.totalSaved}</span>
              <span className="font-semibold text-[#819067]">
                {formatCurrency(totalPlannedSavings, userData.currency)}
              </span>
            </div>

            <div className="flex justify-between items-center p-4 bg-[#435446]/5 rounded-xl border-2 border-[#435446]/10">
              <span className="text-[#435446]/80 font-medium">{t.netAvailable}</span>
              <span className={`font-bold text-lg ${
                netAvailable >= 0 ? 'text-[#819067]' : 'text-red-500'
              }`}>
                {formatCurrency(netAvailable, userData.currency)}
              </span>
            </div>

            {activeSavingsPlans.length > 0 && (
              <div className="pt-2">
                <p className="text-sm text-[#435446]/60 mb-2">{t.activePlans} ({activeSavingsPlans.length})</p>
                <div className="space-y-2">
                  {activeSavingsPlans.slice(0, 2).map((plan) => (
                    <div key={plan.id} className="flex justify-between items-center text-sm">
                      <span className="text-[#435446]/70">{plan.goal}</span>
                      <span className="text-[#435446]">
                        {formatCurrency(plan.monthlyAmount, userData.currency)}/month
                      </span>
                    </div>
                  ))}
                  {activeSavingsPlans.length > 2 && (
                    <p className="text-xs text-[#435446]/50">
                      +{activeSavingsPlans.length - 2} more plans
                    </p>
                  )}
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Financial Tools (Icons Only) */}
        <div className="grid grid-cols-3 gap-3">
          <button
            onClick={() => onNavigate('savings-plan')}
            className="bg-[#819067] text-[#FEFAE0] p-4 rounded-2xl shadow-sm hover:bg-[#819067]/90 transition-all interactive-scale"
          >
            <div className="flex flex-col items-center space-y-2">
              <div className="w-10 h-10 bg-[#FEFAE0]/20 rounded-xl flex items-center justify-center">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                  <path
                    d="M12 2L15.09 8.26L22 9L17 14L18.18 21L12 17.77L5.82 21L7 14L2 9L8.91 8.26L12 2Z"
                    fill="#FEFAE0"
                  />
                </svg>
              </div>
              <span className="font-medium text-center text-sm">{t.startSavingPlan}</span>
            </div>
          </button>

          <button
            onClick={() => onNavigate('purchase-decision')}
            className="bg-[#B1AB86] text-[#435446] p-4 rounded-2xl shadow-sm hover:bg-[#B1AB86]/90 transition-all interactive-scale"
          >
            <div className="flex flex-col items-center space-y-2">
              <div className="w-10 h-10 bg-[#435446]/10 rounded-xl flex items-center justify-center">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                  <path
                    d="M9 12L11 14L15 10M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z"
                    stroke="#435446"
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  />
                </svg>
              </div>
              <span className="font-medium text-center text-sm">{t.decisionHelper}</span>
            </div>
          </button>

          <div className="bg-[#435446]/5 text-[#435446]/40 p-4 rounded-2xl shadow-sm cursor-not-allowed">
            <div className="flex flex-col items-center space-y-2">
              <div className="w-10 h-10 bg-[#435446]/5 rounded-xl flex items-center justify-center">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                  <path
                    d="M9.663 17H4.5A2.5 2.5 0 0 1 2 14.5V9A2.5 2.5 0 0 1 4.5 6.5H9.663M12 6.5L16 10.5L12 14.5M14 10.5H2"
                    stroke="currentColor"
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  />
                </svg>
              </div>
              <div className="text-center">
                <span className="font-medium text-sm block">{t.recommendations}</span>
                <span className="text-xs opacity-60">{t.soonFeature}</span>
              </div>
            </div>
          </div>
        </div>

        {/* Budget Allocation with Manual Money Inputs */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10">
          <h3 className="font-semibold text-[#435446] mb-6">{t.budgetAllocation}</h3>
          
          <div className="space-y-6">
            {/* Needs */}
            <div>
              <div className="flex justify-between items-center mb-3">
                <span className="text-[#435446]/80">{t.needs}</span>
                <div className="flex items-center space-x-2">
                  <input
                    type="number"
                    value={Math.round(needsAmount)}
                    onChange={(e) => handleAmountChange('needs', parseFloat(e.target.value) || 0)}
                    className="w-20 text-sm text-center border border-[#819067]/20 rounded px-2 py-1 bg-white"
                    min="0"
                    max={userData.monthlyIncome}
                  />
                  <span className="text-sm text-[#435446]/60">
                    ({budgetBuckets.needs}%)
                  </span>
                </div>
              </div>
              
              {/* Interactive Slider */}
              <div className="mb-2">
                <input
                  type="range"
                  min="0"
                  max="100"
                  value={budgetBuckets.needs}
                  onChange={(e) => handlePercentageChange('needs', parseInt(e.target.value))}
                  className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer slider-needs"
                  style={{
                    background: `linear-gradient(to right, #435446 0%, #435446 ${budgetBuckets.needs}%, #e5e7eb ${budgetBuckets.needs}%, #e5e7eb 100%)`
                  }}
                />
              </div>
              
              {/* Progress Bar */}
              <div className="h-3 bg-gray-200 rounded-full overflow-hidden">
                <div
                  className="h-full bg-[#435446] transition-all duration-300"
                  style={{ width: `${budgetBuckets.needs}%` }}
                />
              </div>
            </div>

            {/* Wants */}
            <div>
              <div className="flex justify-between items-center mb-3">
                <span className="text-[#435446]/80">{t.wants}</span>
                <div className="flex items-center space-x-2">
                  <input
                    type="number"
                    value={Math.round(wantsAmount)}
                    onChange={(e) => handleAmountChange('wants', parseFloat(e.target.value) || 0)}
                    className="w-20 text-sm text-center border border-[#819067]/20 rounded px-2 py-1 bg-white"
                    min="0"
                    max={userData.monthlyIncome}
                  />
                  <span className="text-sm text-[#435446]/60">
                    ({budgetBuckets.wants}%)
                  </span>
                </div>
              </div>
              
              {/* Interactive Slider */}
              <div className="mb-2">
                <input
                  type="range"
                  min="0"
                  max="100"
                  value={budgetBuckets.wants}
                  onChange={(e) => handlePercentageChange('wants', parseInt(e.target.value))}
                  className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer slider-wants"
                  style={{
                    background: `linear-gradient(to right, #B1AB86 0%, #B1AB86 ${budgetBuckets.wants}%, #e5e7eb ${budgetBuckets.wants}%, #e5e7eb 100%)`
                  }}
                />
              </div>
              
              {/* Progress Bar */}
              <div className="h-3 bg-gray-200 rounded-full overflow-hidden">
                <div
                  className="h-full bg-[#B1AB86] transition-all duration-300"
                  style={{ width: `${budgetBuckets.wants}%` }}
                />
              </div>
            </div>

            {/* Savings */}
            <div>
              <div className="flex justify-between items-center mb-3">
                <span className="text-[#435446]/80">{t.savings}</span>
                <div className="flex items-center space-x-2">
                  <input
                    type="number"
                    value={Math.round(savingsAmount)}
                    onChange={(e) => handleAmountChange('savings', parseFloat(e.target.value) || 0)}
                    className="w-20 text-sm text-center border border-[#819067]/20 rounded px-2 py-1 bg-white"
                    min="0"
                    max={userData.monthlyIncome}
                  />
                  <span className="text-sm text-[#435446]/60">
                    ({budgetBuckets.savings}%)
                  </span>
                </div>
              </div>
              
              {/* Interactive Slider */}
              <div className="mb-2">
                <input
                  type="range"
                  min="0"
                  max="100"
                  value={budgetBuckets.savings}
                  onChange={(e) => handlePercentageChange('savings', parseInt(e.target.value))}
                  className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer slider-savings"
                  style={{
                    background: `linear-gradient(to right, #819067 0%, #819067 ${budgetBuckets.savings}%, #e5e7eb ${budgetBuckets.savings}%, #e5e7eb 100%)`
                  }}
                />
              </div>
              
              {/* Progress Bar */}
              <div className="h-3 bg-gray-200 rounded-full overflow-hidden">
                <div
                  className="h-full bg-[#819067] transition-all duration-300"
                  style={{ width: `${budgetBuckets.savings}%` }}
                />
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* History Panel */}
      {showHistory && (
        <HistoryPanel
          userData={userData}
          savingsPlans={savingsPlans}
          purchaseDecisions={purchaseDecisions}
          onClose={() => setShowHistory(false)}
        />
      )}
    </div>
  );
}
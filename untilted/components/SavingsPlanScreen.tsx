import React, { useState, useEffect } from 'react';
import { type UserData, type BudgetBuckets, type SavingsPlan, formatCurrency } from '../utils/localStorage';

interface SavingsPlanScreenProps {
  userData: UserData | null;
  budgetBuckets: BudgetBuckets;
  existingPlans?: SavingsPlan[];
  onComplete: (plan: SavingsPlan) => void;
  onBack: () => void;
}

export function SavingsPlanScreen({ 
  userData, 
  budgetBuckets, 
  existingPlans = [],
  onComplete, 
  onBack 
}: SavingsPlanScreenProps) {
  const [formData, setFormData] = useState({
    goal: '',
    targetAmount: '',
    timeframe: '12'
  });
  const [isTimeInvalid, setIsTimeInvalid] = useState(false);
  const [validationMessage, setValidationMessage] = useState('');
  const [formErrors, setFormErrors] = useState({
    goal: false,
    targetAmount: false
  });

  if (!userData) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <h2>No user data found</h2>
          <button onClick={onBack} className="mt-4 bg-primary text-primary-foreground px-6 py-2 rounded-lg">
            Go Back
          </button>
        </div>
      </div>
    );
  }

  const texts = {
    en: {
      title: 'Create Saving Plan',
      subtitle: 'Build your financial future in one place',
      goalTitle: 'What are you saving for?',
      goalPlaceholder: 'e.g., Emergency fund, New car, Vacation',
      targetTitle: 'How much do you need?',
      targetPlaceholder: 'Enter target amount',
      timeTitle: 'When do you need it?',
      timeMonths: 'months',
      reviewTitle: 'Plan Summary',
      goalLabel: 'Goal',
      targetLabel: 'Target Amount',
      timeframeLabel: 'Timeframe',
      monthlyLabel: 'Monthly Saving Required',
      availableLabel: 'Available for Savings',
      remainingLabel: 'Remaining after this plan',
      impossible: 'Impossible with current budget',
      risky: 'Risky - exceeds available budget',
      warning: 'This goal needs more than your available savings',
      back: 'Back',
      createPlan: 'Create Savings Plan',
      months: 'months',
      required: 'This field is required',
      planDetails: 'Plan Details',
      budgetImpact: 'Budget Impact'
    },
    ar: {
      title: 'إنشاء خطة ادخار',
      subtitle: 'ابنِ مستقبلك المالي في مكان واحد',
      goalTitle: 'ما هدفك من الادخار؟',
      goalPlaceholder: 'مثل: صندوق الطوارئ، سيارة جديدة، إجازة',
      targetTitle: 'كم تحتاج؟',
      targetPlaceholder: 'أدخل المبلغ المطلوب',
      timeTitle: 'متى تحتاجه؟',
      timeMonths: 'شهر',
      reviewTitle: 'ملخص الخطة',
      goalLabel: 'الهدف',
      targetLabel: 'المبلغ المطلوب',
      timeframeLabel: 'المدة الزمنية',
      monthlyLabel: 'الادخار الشهري المطلوب',
      availableLabel: 'المتاح للادخار',
      remainingLabel: 'المتبقي بعد هذه الخطة',
      impossible: 'مستحيل مع الميزانية الحالية',
      risky: 'محفوف بالمخاطر - يتجاوز الميزانية المتاحة',
      warning: 'هذا الهدف يحتاج أكثر من المدخرات المتاحة',
      back: 'السابق',
      createPlan: 'إنشاء خطة الادخار',
      months: 'شهر',
      required: 'هذا الحقل مطلوب',
      planDetails: 'تفاصيل الخطة',
      budgetImpact: 'تأثير الميزانية'
    }
  };

  const t = texts[userData.language || 'en'];

  // Calculate available savings capacity
  const savingsPercentage = budgetBuckets.savings;
  const monthlySavingsCapacity = (userData.monthlyIncome * savingsPercentage) / 100;
  
  // Calculate existing plan allocations
  const existingMonthlyAllocations = existingPlans
    .filter(plan => !plan.isCompleted)
    .reduce((sum, plan) => sum + plan.monthlyAmount, 0);
  
  const availableForNewPlan = monthlySavingsCapacity - existingMonthlyAllocations;
  
  // Calculate monthly amount needed for this plan
  const targetAmount = parseFloat(formData.targetAmount) || 0;
  const timeframe = parseInt(formData.timeframe) || 1;
  const monthlyAmountNeeded = targetAmount / timeframe;

  // Validation logic
  const isGoalRealistic = monthlyAmountNeeded <= availableForNewPlan;
  const isVeryRisky = monthlyAmountNeeded > availableForNewPlan * 1.5;
  
  const timeOptions = Array.from({ length: 60 }, (_, i) => i + 1);

  const validateTimeframe = (months: number) => {
    const requiredMonthly = targetAmount / months;
    let isInvalid = false;
    let message = '';
    
    if (requiredMonthly > availableForNewPlan * 1.5) {
      isInvalid = true;
      message = t.impossible;
    } else if (requiredMonthly > availableForNewPlan) {
      isInvalid = true;
      message = t.risky;
    }
    
    setIsTimeInvalid(isInvalid);
    setValidationMessage(message);
    return !isInvalid;
  };

  const handleTimeframeChange = (value: string) => {
    const months = parseInt(value);
    setFormData(prev => ({ ...prev, timeframe: value }));
    if (targetAmount > 0) {
      validateTimeframe(months);
    }
  };

  const handleTargetAmountChange = (value: string) => {
    setFormData(prev => ({ ...prev, targetAmount: value }));
    const amount = parseFloat(value);
    
    // Clear target amount error when user starts typing
    if (formErrors.targetAmount && value) {
      setFormErrors(prev => ({ ...prev, targetAmount: false }));
    }
    
    if (amount > 0) {
      validateTimeframe(parseInt(formData.timeframe));
    } else {
      setIsTimeInvalid(false);
      setValidationMessage('');
    }
  };

  const handleGoalChange = (value: string) => {
    setFormData(prev => ({ ...prev, goal: value }));
    
    // Clear goal error when user starts typing
    if (formErrors.goal && value.trim()) {
      setFormErrors(prev => ({ ...prev, goal: false }));
    }
  };

  const validateForm = () => {
    const newErrors = {
      goal: !formData.goal.trim(),
      targetAmount: !targetAmount || targetAmount <= 0
    };

    setFormErrors(newErrors);
    return !Object.values(newErrors).some(error => error) && !isTimeInvalid;
  };

  const handleCreatePlan = () => {
    if (!validateForm()) {
      return;
    }

    const newPlan: SavingsPlan = {
      id: Date.now().toString(),
      goal: formData.goal.trim(),
      targetAmount: targetAmount,
      monthlyAmount: monthlyAmountNeeded,
      duration: timeframe,
      currentSavings: 0,
      isCompleted: false,
      createdAt: new Date().toISOString()
    };
    
    onComplete(newPlan);
    onBack();
  };

  const isFormValid = formData.goal.trim() && 
                     targetAmount > 0 && 
                     !isTimeInvalid;

  return (
    <div className="min-h-screen bg-gradient-to-b from-white to-[#819067]/5 safe-area-top safe-area-bottom" dir={userData.language === 'ar' ? 'rtl' : 'ltr'}>
      {/* Header */}
      <div className="bg-white border-b border-[#819067]/10">
        <div className="px-6 py-6">
          <div className="flex items-center space-x-4">
            <button onClick={onBack} className="p-2 hover:bg-[#819067]/10 rounded-lg transition-colors">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" className={userData.language === 'ar' ? 'rotate-180' : ''}>
                <path d="M19 12H5M12 19L5 12L12 5" stroke="#435446" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            </button>
            <div>
              <h1 className="text-xl font-bold text-[#435446]">{t.title}</h1>
              <p className="text-sm text-[#435446]/70">{t.subtitle}</p>
            </div>
          </div>
        </div>
      </div>

      <div className="px-6 py-6 space-y-6">
        {/* Goal Section */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10">
          <h3 className="text-lg font-semibold text-[#435446] mb-4">{t.goalTitle}</h3>
          <input
            type="text"
            value={formData.goal}
            onChange={(e) => handleGoalChange(e.target.value)}
            placeholder={t.goalPlaceholder}
            className={`w-full p-4 border rounded-xl bg-[#819067]/5 text-[#435446] placeholder-[#435446]/50 focus:outline-none focus:ring-2 transition-all ${
              formErrors.goal 
                ? 'border-red-500 focus:ring-red-500/30' 
                : 'border-[#819067]/20 focus:ring-[#819067]/30'
            }`}
          />
          {formErrors.goal && (
            <p className="text-red-500 text-sm mt-2">{t.required}</p>
          )}
        </div>

        {/* Target Amount & Timeframe Section */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10 space-y-6">
          <h3 className="text-lg font-semibold text-[#435446]">{t.planDetails}</h3>
          
          {/* Target Amount */}
          <div>
            <label className="block text-sm font-medium text-[#435446] mb-2">
              {t.targetTitle} <span className="text-red-500">*</span>
            </label>
            <div className="relative">
              <input
                type="number"
                value={formData.targetAmount}
                onChange={(e) => handleTargetAmountChange(e.target.value)}
                placeholder={t.targetPlaceholder}
                className={`w-full p-4 border rounded-xl bg-[#819067]/5 text-[#435446] placeholder-[#435446]/50 focus:outline-none focus:ring-2 transition-all pr-16 ${
                  formErrors.targetAmount 
                    ? 'border-red-500 focus:ring-red-500/30' 
                    : 'border-[#819067]/20 focus:ring-[#819067]/30'
                }`}
                min="0"
              />
              <div className={`absolute top-1/2 transform -translate-y-1/2 text-[#435446]/60 ${userData.language === 'ar' ? 'left-4' : 'right-4'}`}>
                {userData.currency === 'SAR' ? 'ر.س' : '$'}
              </div>
            </div>
            {formErrors.targetAmount && (
              <p className="text-red-500 text-sm mt-2">{t.required}</p>
            )}
          </div>

          {/* Timeframe */}
          <div>
            <label className="block text-sm font-medium text-[#435446] mb-2">
              {t.timeTitle}
            </label>
            <div className={`relative ${isTimeInvalid ? 'ring-2 ring-red-500 rounded-xl' : ''}`}>
              <select
                value={formData.timeframe}
                onChange={(e) => handleTimeframeChange(e.target.value)}
                className={`w-full p-4 border rounded-xl bg-[#819067]/5 text-[#435446] focus:outline-none focus:ring-2 focus:ring-[#819067]/30 ${
                  isTimeInvalid ? 'border-red-500 bg-red-50' : 'border-[#819067]/20'
                }`}
              >
                {timeOptions.map(month => (
                  <option key={month} value={month}>
                    {month} {t.months}
                  </option>
                ))}
              </select>
            </div>
            
            {isTimeInvalid && (
              <div className="mt-2 p-3 bg-red-50 border border-red-200 rounded-lg">
                <p className="text-red-600 font-medium">{validationMessage}</p>
                <p className="text-red-500 text-sm">{t.warning}</p>
              </div>
            )}
          </div>
        </div>

        {/* Plan Summary & Budget Impact */}
        {targetAmount > 0 && (
          <>
            {/* Monthly Amount Preview */}
            <div className="bg-[#819067]/10 rounded-2xl p-6 border border-[#819067]/20">
              <h3 className="text-lg font-semibold text-[#435446] mb-4">{t.reviewTitle}</h3>
              
              <div className="space-y-3">
                <div className="flex justify-between items-center">
                  <span className="text-[#435446]/70">{t.goalLabel}:</span>
                  <span className="font-medium text-[#435446]">{formData.goal || '---'}</span>
                </div>
                
                <div className="flex justify-between items-center">
                  <span className="text-[#435446]/70">{t.targetLabel}:</span>
                  <span className="font-medium text-[#435446]">
                    {formatCurrency(targetAmount, userData.currency)}
                  </span>
                </div>
                
                <div className="flex justify-between items-center">
                  <span className="text-[#435446]/70">{t.timeframeLabel}:</span>
                  <span className="font-medium text-[#435446]">{formData.timeframe} {t.months}</span>
                </div>
                
                <div className="border-t border-[#819067]/20 pt-3">
                  <div className="flex justify-between items-center">
                    <span className="text-[#435446]/70">{t.monthlyLabel}:</span>
                    <span className={`font-bold text-lg ${
                      isGoalRealistic ? 'text-[#819067]' : 'text-red-500'
                    }`}>
                      {formatCurrency(monthlyAmountNeeded, userData.currency)}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            {/* Budget Impact */}
            <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10">
              <h3 className="text-lg font-semibold text-[#435446] mb-4">{t.budgetImpact}</h3>
              
              <div className="space-y-3">
                <div className="flex justify-between items-center">
                  <span className="text-[#435446]/70">{t.availableLabel}:</span>
                  <span className="font-medium text-[#435446]">
                    {formatCurrency(availableForNewPlan, userData.currency)}
                  </span>
                </div>
                
                <div className="flex justify-between items-center">
                  <span className="text-[#435446]/70">{t.remainingLabel}:</span>
                  <span className={`font-medium ${
                    availableForNewPlan - monthlyAmountNeeded >= 0 ? 'text-[#819067]' : 'text-red-500'
                  }`}>
                    {formatCurrency(availableForNewPlan - monthlyAmountNeeded, userData.currency)}
                  </span>
                </div>
              </div>

              {!isGoalRealistic && (
                <div className="mt-4 bg-red-50 border border-red-200 rounded-lg p-3">
                  <p className="text-red-600 font-medium">{t.warning}</p>
                </div>
              )}
            </div>
          </>
        )}

        {/* Create Plan Button */}
        <div className="flex space-x-4">
          <button
            onClick={onBack}
            className="flex-1 py-4 px-6 border border-[#819067]/30 rounded-xl text-[#435446] hover:bg-[#819067]/5 transition-all"
          >
            {t.back}
          </button>
          
          <button
            onClick={handleCreatePlan}
            disabled={!isFormValid}
            className={`flex-1 py-4 px-6 rounded-xl font-medium transition-all interactive-scale ${
              isFormValid
                ? 'bg-[#819067] text-[#FEFAE0] hover:bg-[#819067]/90 shadow-lg'
                : 'bg-[#819067]/30 text-[#FEFAE0]/60 cursor-not-allowed'
            }`}
          >
            {t.createPlan}
          </button>
        </div>

        {!isFormValid && (Object.values(formErrors).some(error => error) || isTimeInvalid) && (
          <p className="text-red-500 text-sm text-center mt-2">
            Please complete all required fields with valid information
          </p>
        )}
      </div>
    </div>
  );
}
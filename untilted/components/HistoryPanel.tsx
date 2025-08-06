import React, { useState } from 'react';
import { type UserData, type SavingsPlan, type PurchaseDecision, formatCurrency } from '../utils/localStorage';

interface HistoryPanelProps {
  userData: UserData | null;
  savingsPlans: SavingsPlan[];
  purchaseDecisions: PurchaseDecision[];
  onClose: () => void;
}

export function HistoryPanel({ userData, savingsPlans, purchaseDecisions, onClose }: HistoryPanelProps) {
  const [activeTab, setActiveTab] = useState<'savings' | 'decisions'>('savings');

  if (!userData) return null;

  const texts = {
    en: {
      title: 'History',
      savingsTab: 'Saving Plans',
      decisionsTab: 'Purchase Decisions',
      noSavingsPlans: 'No saving plans yet',
      noDecisions: 'No purchase decisions yet',
      completed: 'Completed',
      active: 'Active',
      purchased: 'Purchased',
      recommended: 'Recommended',
      wait: 'Wait',
      notRecommended: 'Not Recommended',
      targetAmount: 'Target',
      monthlyAmount: 'Monthly',
      progress: 'Progress',
      startSaving: 'Start your first saving plan!',
      makeDecision: 'Make your first purchase decision!'
    },
    ar: {
      title: 'السجل',
      savingsTab: 'خطط الادخار',
      decisionsTab: 'قرارات الشراء',
      noSavingsPlans: 'لا توجد خطط ادخار بعد',
      noDecisions: 'لا توجد قرارات شراء بعد',
      completed: 'مكتملة',
      active: 'نشطة',
      purchased: 'تم الشراء',
      recommended: 'موصى به',
      wait: 'انتظر',
      notRecommended: 'غير موصى به',
      targetAmount: 'الهدف',
      monthlyAmount: 'شهرياً',
      progress: 'التقدم',
      startSaving: 'ابدأ خطة الادخار الأولى!',
      makeDecision: 'اتخذ قرار الشراء الأول!'
    }
  };

  const t = texts[userData.language || 'en'];

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString(userData.language === 'ar' ? 'ar-SA' : 'en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric'
    });
  };

  const getDecisionColor = (decision: string) => {
    switch (decision) {
      case 'recommended':
        return 'text-[#819067] bg-[#819067]/10';
      case 'wait':
        return 'text-orange-600 bg-orange-50';
      case 'not-recommended':
        return 'text-red-600 bg-red-50';
      default:
        return 'text-[#435446] bg-[#435446]/10';
    }
  };

  const getDecisionText = (decision: string) => {
    switch (decision) {
      case 'recommended':
        return t.recommended;
      case 'wait':
        return t.wait;
      case 'not-recommended':
        return t.notRecommended;
      default:
        return decision;
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex" dir={userData.language === 'ar' ? 'rtl' : 'ltr'}>
      {/* Dashboard Background (clickable to close) */}
      <div 
        className="flex-1 bg-black/20 backdrop-blur-sm cursor-pointer"
        onClick={onClose}
      />
      
      {/* History Panel (Half Screen) */}
      <div className={`w-full max-w-sm bg-white shadow-xl flex flex-col ${
        userData.language === 'ar' ? 'slide-in-left' : 'slide-in-right'
      }`}>
        {/* Header */}
        <div className="bg-white border-b border-[#819067]/10 px-6 py-4 flex-shrink-0">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-[#435446]">{t.title}</h2>
            <button
              onClick={onClose}
              className="p-2 hover:bg-[#819067]/10 rounded-lg transition-colors"
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                <path d="M18 6L6 18M6 6L18 18" stroke="#435446" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            </button>
          </div>

          {/* Tabs */}
          <div className="flex bg-[#819067]/5 rounded-lg p-1">
            <button
              onClick={() => setActiveTab('savings')}
              className={`flex-1 py-2 px-3 rounded-md text-sm font-medium transition-all ${
                activeTab === 'savings'
                  ? 'bg-white text-[#435446] shadow-sm'
                  : 'text-[#435446]/70 hover:text-[#435446]'
              }`}
            >
              {t.savingsTab}
            </button>
            <button
              onClick={() => setActiveTab('decisions')}
              className={`flex-1 py-2 px-3 rounded-md text-sm font-medium transition-all ${
                activeTab === 'decisions'
                  ? 'bg-white text-[#435446] shadow-sm'
                  : 'text-[#435446]/70 hover:text-[#435446]'
              }`}
            >
              {t.decisionsTab}
            </button>
          </div>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto">
          {/* Savings Plans Tab */}
          {activeTab === 'savings' && (
            <div className="p-6">
              {savingsPlans.length === 0 ? (
                <div className="flex items-center justify-center h-64">
                  <div className="text-center">
                    <div className="w-16 h-16 bg-[#819067]/10 rounded-full flex items-center justify-center mx-auto mb-4">
                      <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                        <path
                          d="M12 2L15.09 8.26L22 9L17 14L18.18 21L12 17.77L5.82 21L7 14L2 9L8.91 8.26L12 2Z"
                          fill="#819067"
                        />
                      </svg>
                    </div>
                    <p className="text-[#435446]/60 mb-2">{t.noSavingsPlans}</p>
                    <p className="text-sm text-[#435446]/40">{t.startSaving}</p>
                  </div>
                </div>
              ) : (
                <div className="space-y-4">
                  {savingsPlans.map((plan) => {
                    const progress = (plan.currentSavings / plan.targetAmount) * 100;
                    return (
                      <div
                        key={plan.id}
                        className="bg-white rounded-xl border border-[#819067]/10 p-4 hover:border-[#819067]/20 transition-colors"
                      >
                        <div className="flex items-start justify-between mb-3">
                          <div className="flex-1">
                            <h3 className="font-medium text-[#435446] mb-1">{plan.goal}</h3>
                            <p className="text-sm text-[#435446]/60">{formatDate(plan.createdAt)}</p>
                          </div>
                          <div className={`px-2 py-1 rounded-full text-xs font-medium ${
                            plan.isCompleted ? 'bg-[#819067]/20 text-[#819067]' : 'bg-[#B1AB86]/20 text-[#B1AB86]'
                          }`}>
                            {plan.isCompleted ? t.completed : t.active}
                          </div>
                        </div>

                        <div className="space-y-2 mb-3">
                          <div className="flex justify-between text-sm">
                            <span className="text-[#435446]/70">{t.targetAmount}:</span>
                            <span className="font-medium text-[#435446]">
                              {formatCurrency(plan.targetAmount, userData.currency)}
                            </span>
                          </div>
                          <div className="flex justify-between text-sm">
                            <span className="text-[#435446]/70">{t.monthlyAmount}:</span>
                            <span className="font-medium text-[#435446]">
                              {formatCurrency(plan.monthlyAmount, userData.currency)}
                            </span>
                          </div>
                        </div>

                        <div>
                          <div className="flex justify-between text-sm mb-1">
                            <span className="text-[#435446]/70">{t.progress}</span>
                            <span className="font-medium text-[#819067]">{progress.toFixed(0)}%</span>
                          </div>
                          <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
                            <div
                              className="h-full bg-[#819067] transition-all duration-300"
                              style={{ width: `${Math.min(100, progress)}%` }}
                            />
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}
            </div>
          )}

          {/* Purchase Decisions Tab */}
          {activeTab === 'decisions' && (
            <div className="p-6">
              {purchaseDecisions.length === 0 ? (
                <div className="flex items-center justify-center h-64">
                  <div className="text-center">
                    <div className="w-16 h-16 bg-[#819067]/10 rounded-full flex items-center justify-center mx-auto mb-4">
                      <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                        <path
                          d="M9 12L11 14L15 10M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z"
                          stroke="#819067"
                          strokeWidth="2"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                        />
                      </svg>
                    </div>
                    <p className="text-[#435446]/60 mb-2">{t.noDecisions}</p>
                    <p className="text-sm text-[#435446]/40">{t.makeDecision}</p>
                  </div>
                </div>
              ) : (
                <div className="space-y-4">
                  {purchaseDecisions.map((decision) => (
                    <div
                      key={decision.id}
                      className="bg-white rounded-xl border border-[#819067]/10 p-4 hover:border-[#819067]/20 transition-colors"
                    >
                      <div className="flex items-start justify-between mb-3">
                        <div className="flex-1">
                          <h3 className="font-medium text-[#435446] mb-1">{decision.item}</h3>
                          <p className="text-sm text-[#435446]/60">{formatDate(decision.createdAt)}</p>
                        </div>
                        <div className="text-right">
                          <div className="font-medium text-[#435446] mb-1">
                            {formatCurrency(decision.price, userData.currency)}
                          </div>
                          {decision.purchased && (
                            <div className="px-2 py-1 rounded-full text-xs font-medium bg-[#819067]/20 text-[#819067]">
                              {t.purchased}
                            </div>
                          )}
                        </div>
                      </div>

                      <div className={`inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${getDecisionColor(decision.decision)}`}>
                        {getDecisionText(decision.decision)}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
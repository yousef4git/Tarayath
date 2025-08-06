import React from 'react';
import { type UserData, formatCurrency } from '../utils/localStorage';

interface SpendingHistoryPanelProps {
  userData: UserData | null;
  onClose: () => void;
}

export function SpendingHistoryPanel({ userData, onClose }: SpendingHistoryPanelProps) {
  if (!userData) return null;

  // Mock spending data for demonstration
  const spendingData = [
    { date: '2025-01-25', category: 'Groceries', amount: -150, type: 'expense' },
    { date: '2025-01-24', category: 'Coffee', amount: -25, type: 'expense' },
    { date: '2025-01-23', category: 'Gas', amount: -80, type: 'expense' },
    { date: '2025-01-22', category: 'Salary', amount: userData.monthlyIncome, type: 'income' },
    { date: '2025-01-21', category: 'Dinner', amount: -120, type: 'expense' },
    { date: '2025-01-20', category: 'Books', amount: -45, type: 'expense' },
    { date: '2025-01-19', category: 'Transport', amount: -30, type: 'expense' },
    { date: '2025-01-18', category: 'Utilities', amount: -200, type: 'expense' },
  ];

  const texts = {
    en: {
      title: 'Spending History',
      noData: 'No spending data available',
      income: 'Income',
      expense: 'Expense',
      thisMonth: 'This Month',
      lastWeek: 'Last 7 Days'
    },
    ar: {
      title: 'تاريخ المصاريف',
      noData: 'لا توجد بيانات مصاريف متاحة',
      income: 'دخل',
      expense: 'مصروف',
      thisMonth: 'هذا الشهر',
      lastWeek: 'آخر 7 أيام'
    }
  };

  const t = texts[userData.language || 'en'];

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    const today = new Date();
    const diffTime = Math.abs(today.getTime() - date.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    if (diffDays === 1) {
      return userData.language === 'ar' ? 'اليوم' : 'Today';
    } else if (diffDays === 2) {
      return userData.language === 'ar' ? 'أمس' : 'Yesterday';
    } else if (diffDays <= 7) {
      return userData.language === 'ar' ? `منذ ${diffDays} أيام` : `${diffDays} days ago`;
    } else {
      return date.toLocaleDateString(userData.language === 'ar' ? 'ar-SA' : 'en-US', {
        month: 'short',
        day: 'numeric'
      });
    }
  };

  const getCategoryIcon = (category: string) => {
    const iconMap: Record<string, string> = {
      'Groceries': '🛒',
      'Coffee': '☕',
      'Gas': '⛽',
      'Salary': '💰',
      'Dinner': '🍽️',
      'Books': '📚',
      'Transport': '🚗',
      'Utilities': '⚡'
    };
    return iconMap[category] || '💳';
  };

  return (
    <div className="fixed inset-0 z-50 flex" dir={userData.language === 'ar' ? 'rtl' : 'ltr'}>
      {/* Dashboard Background (clickable to close) */}
      <div 
        className="flex-1 bg-black/20 backdrop-blur-sm cursor-pointer"
        onClick={onClose}
      />
      
      {/* Spending History Panel (Half Screen) */}
      <div className={`w-full max-w-sm bg-white shadow-xl flex flex-col spending-history-panel ${
        userData.language === 'ar' ? 'slide-in-left' : 'slide-in-right'
      }`}>
        {/* Header */}
        <div className="bg-white border-b border-[#819067]/10 px-6 py-4 flex-shrink-0">
          <div className="flex items-center justify-between">
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
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto">
          {spendingData.length === 0 ? (
            <div className="flex items-center justify-center h-full">
              <div className="text-center">
                <div className="w-16 h-16 bg-[#819067]/10 rounded-full flex items-center justify-center mx-auto mb-4">
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M9 11H15M9 15H15M17 21H7C5.89543 21 5 20.1046 5 19V5C5 3.89543 5.89543 3 7 3H12.5858C12.851 3 13.1054 3.10536 13.2929 3.29289L19.7071 9.70711C19.8946 9.89464 20 10.149 20 10.4142V19C20 20.1046 19.1046 21 18 21H17Z" stroke="#819067" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                  </svg>
                </div>
                <p className="text-[#435446]/60">{t.noData}</p>
              </div>
            </div>
          ) : (
            <div className="p-6">
              {/* Summary Cards */}
              <div className="grid grid-cols-2 gap-4 mb-6">
                <div className="bg-[#819067]/5 rounded-xl p-4 border border-[#819067]/10">
                  <p className="text-xs text-[#435446]/60 mb-1">{t.thisMonth}</p>
                  <p className="text-sm font-semibold text-[#819067]">
                    {formatCurrency(spendingData.filter(item => item.type === 'expense').reduce((sum, item) => sum + Math.abs(item.amount), 0), userData.currency)}
                  </p>
                </div>
                <div className="bg-[#B1AB86]/5 rounded-xl p-4 border border-[#B1AB86]/10">
                  <p className="text-xs text-[#435446]/60 mb-1">{t.lastWeek}</p>
                  <p className="text-sm font-semibold text-[#B1AB86]">
                    {formatCurrency(spendingData.slice(0, 7).filter(item => item.type === 'expense').reduce((sum, item) => sum + Math.abs(item.amount), 0), userData.currency)}
                  </p>
                </div>
              </div>

              {/* Transaction List */}
              <div className="space-y-3">
                {spendingData.map((transaction, index) => (
                  <div
                    key={index}
                    className="flex items-center justify-between p-4 bg-white rounded-xl border border-[#819067]/10 hover:border-[#819067]/20 transition-colors"
                  >
                    <div className="flex items-center space-x-3">
                      <div className="w-10 h-10 bg-[#819067]/10 rounded-xl flex items-center justify-center">
                        <span className="text-lg">{getCategoryIcon(transaction.category)}</span>
                      </div>
                      <div>
                        <p className="font-medium text-[#435446]">{transaction.category}</p>
                        <p className="text-xs text-[#435446]/60">{formatDate(transaction.date)}</p>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className={`font-semibold ${
                        transaction.type === 'income' ? 'text-[#819067]' : 'text-[#435446]'
                      }`}>
                        {transaction.type === 'income' ? '+' : '-'}
                        {formatCurrency(Math.abs(transaction.amount), userData.currency)}
                      </p>
                      <p className="text-xs text-[#435446]/60">
                        {transaction.type === 'income' ? t.income : t.expense}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
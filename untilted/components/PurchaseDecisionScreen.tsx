import React, { useState, useEffect } from 'react';
import { type UserData, type SavingsPlan, type BudgetBuckets, type PurchaseDecision, formatCurrency, savePurchaseDecision, updateUserBalance } from '../utils/localStorage';

interface PurchaseDecisionScreenProps {
  userData: UserData | null;
  savingsPlans: SavingsPlan[];
  budgetBuckets: BudgetBuckets;
  onBack: () => void;
}

interface QuestionAnswer {
  questionId: string;
  answer: string;
  score: number;
}

export function PurchaseDecisionScreen({ 
  userData, 
  savingsPlans, 
  budgetBuckets, 
  onBack 
}: PurchaseDecisionScreenProps) {
  const [formData, setFormData] = useState({
    itemName: '',
    itemCost: ''
  });
  const [answers, setAnswers] = useState<QuestionAnswer[]>([]);
  const [decision, setDecision] = useState<any>(null);
  const [showPurchaseConfirm, setShowPurchaseConfirm] = useState(false);
  const [formErrors, setFormErrors] = useState({
    itemName: false,
    itemCost: false
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
      title: 'Smart Purchase Decision',
      subtitle: 'Make informed buying choices in one place',
      itemDetailsTitle: 'Purchase Details',
      itemNameTitle: 'What do you want to buy?',
      itemNamePlaceholder: 'e.g., laptop, car, phone',
      itemCostTitle: 'How much does it cost?',
      itemCostPlaceholder: 'Enter the price',
      financialImpactTitle: 'Financial Impact',
      currentBalance: 'Current Balance',
      afterExpenses: 'After Fixed Expenses',
      afterSavings: 'After Saving Plans',
      finalAvailable: 'Available for Purchases',
      afterPurchase: 'After This Purchase',
      questionsTitle: 'Decision Check',
      resultTitle: 'Our Recommendation',
      back: 'Back',
      buyItem: 'Complete Purchase',
      purchased: 'Purchase Complete!',
      newBalance: 'Your New Balance',
      required: 'This field is required',
      notEnoughFunds: 'Not enough available funds',
      needMore: 'You need',
      more: 'more',
      recordedInHistory: 'This will be recorded in your purchase history',
      answersRequired: 'Please answer all questions to see recommendation',
      questions: [
        {
          id: 'feeling',
          question: 'How do you feel about this purchase?',
          options: [
            { text: 'Really excited! 🤩', score: 3, emoji: '🤩' },
            { text: 'Pretty happy 😊', score: 2, emoji: '😊' },
            { text: 'It\'s okay 😐', score: 1, emoji: '😐' },
            { text: 'Unsure... 🤔', score: 0, emoji: '🤔' }
          ]
        },
        {
          id: 'timing',
          question: 'When do you need this?',
          options: [
            { text: 'Right now! ⚡', score: 3, emoji: '⚡' },
            { text: 'This month 📅', score: 2, emoji: '📅' },
            { text: 'Sometime soon ⏰', score: 1, emoji: '⏰' },
            { text: 'No rush 🌱', score: 0, emoji: '🌱' }
          ]
        },
        {
          id: 'benefit',
          question: 'How will this help you?',
          options: [
            { text: 'Essential for work/study 💼', score: 3, emoji: '💼' },
            { text: 'Improves my life 🌟', score: 2, emoji: '🌟' },
            { text: 'Nice to have 👍', score: 1, emoji: '👍' },
            { text: 'Just want it 💭', score: 0, emoji: '💭' }
          ]
        }
      ],
      recommendations: {
        excellent: {
          title: '✅ Excellent Choice!',
          message: 'This looks like a smart purchase. You have good reasons and the financial capacity.',
          action: 'Go ahead and buy it!'
        },
        good: {
          title: '👍 Good Purchase',
          message: 'This seems reasonable. You have the means and decent reasons for buying.',
          action: 'It\'s your choice - looks fine!'
        },
        okay: {
          title: '⚠️ Think It Over',
          message: 'This purchase is okay, but consider if you really need it right now.',
          action: 'Maybe wait a bit longer?'
        },
        poor: {
          title: '❌ Not Recommended',
          message: 'This doesn\'t seem like the best financial decision right now.',
          action: 'Consider waiting or saving more first'
        }
      }
    },
    ar: {
      title: 'قرار شراء ذكي',
      subtitle: 'اتخذ خيارات شراء مدروسة في مكان واحد',
      itemDetailsTitle: 'تفاصيل الشراء',
      itemNameTitle: 'ماذا تريد أن تشتري؟',
      itemNamePlaceholder: 'مثل: لابتوب، سيارة، هاتف',
      itemCostTitle: 'كم يكلف؟',
      itemCostPlaceholder: 'أدخل السعر',
      financialImpactTitle: 'التأثير المالي',
      currentBalance: 'الرصيد الحالي',
      afterExpenses: 'بعد المصاريف الثابتة',
      afterSavings: 'بعد خطط الادخار',
      finalAvailable: 'المتاح للمشتريات',
      afterPurchase: 'بعد هذا الشراء',
      questionsTitle: 'فحص القرار',
      resultTitle: 'توصيتنا',
      back: 'السابق',
      buyItem: 'إتمام الشراء',
      purchased: 'تم الشراء!',
      newBalance: 'رصيدك الجديد',
      required: 'هذا الحقل مطلوب',
      notEnoughFunds: 'لا توجد أموال كافية متاحة',
      needMore: 'تحتاج',
      more: 'أكثر',
      recordedInHistory: 'سيتم تسجيل هذا في سجل مشترياتك',
      answersRequired: 'يرجى الإجابة على جميع الأسئلة لرؤية التوصية',
      questions: [
        {
          id: 'feeling',
          question: 'كيف تشعر حيال هذا الشراء؟',
          options: [
            { text: 'متحمس جداً! 🤩', score: 3, emoji: '🤩' },
            { text: 'سعيد نوعاً ما 😊', score: 2, emoji: '😊' },
            { text: 'عادي 😐', score: 1, emoji: '😐' },
            { text: 'غير متأكد... 🤔', score: 0, emoji: '🤔' }
          ]
        },
        {
          id: 'timing',
          question: 'متى تحتاج هذا؟',
          options: [
            { text: 'الآن فوراً! ⚡', score: 3, emoji: '⚡' },
            { text: 'هذا الشهر 📅', score: 2, emoji: '📅' },
            { text: 'قريباً ⏰', score: 1, emoji: '⏰' },
            { text: 'لا أستعجل 🌱', score: 0, emoji: '🌱' }
          ]
        },
        {
          id: 'benefit',
          question: 'كيف سيساعدك هذا؟',
          options: [
            { text: 'أساسي للعمل/الدراسة 💼', score: 3, emoji: '💼' },
            { text: 'يحسن حياتي 🌟', score: 2, emoji: '🌟' },
            { text: 'شيء جميل 👍', score: 1, emoji: '👍' },
            { text: 'أريده فقط 💭', score: 0, emoji: '💭' }
          ]
        }
      ],
      recommendations: {
        excellent: {
          title: '✅ خيار ممتاز!',
          message: 'يبدو هذا شراءً ذكياً. لديك أسباب جيدة والقدرة المالية.',
          action: 'امض قدماً واشتريه!'
        },
        good: {
          title: '👍 شراء جيد',
          message: 'يبدو هذا معقولاً. لديك الوسائل وأسباب لائقة للشراء.',
          action: 'الخيار لك - يبدو جيداً!'
        },
        okay: {
          title: '⚠️ فكر فيه',
          message: 'هذا الشراء عادي، لكن فكر إن كنت تحتاجه حقاً الآن.',
          action: 'ربما انتظر قليلاً؟'
        },
        poor: {
          title: '❌ غير موصى به',
          message: 'لا يبدو هذا أفضل قرار مالي حالياً.',
          action: 'فكر في الانتظار أو الادخار أكثر أولاً'
        }
      }
    }
  };

  const t = texts[userData.language || 'en'];

  // Calculate financial situation
  const itemCost = parseFloat(formData.itemCost) || 0;
  const totalSavingsPlansAmount = savingsPlans
    .filter(plan => !plan.isCompleted)
    .reduce((sum, plan) => sum + plan.monthlyAmount, 0);
  
  const afterExpenses = userData.currentBalance - userData.monthlyObligations;
  const afterSavings = afterExpenses - totalSavingsPlansAmount;
  const finalAvailable = Math.max(0, afterSavings);
  
  const canAfford = finalAvailable >= itemCost;
  const safetyAfterPurchase = finalAvailable - itemCost;

  const evaluateDecision = () => {
    const totalScore = answers.reduce((sum, answer) => sum + answer.score, 0);
    const maxScore = 9; // 3 questions × 3 max score each
    const scorePercentage = (totalScore / maxScore) * 100;

    let recommendation;
    if (scorePercentage >= 75 && canAfford && safetyAfterPurchase >= userData.monthlyIncome * 0.5) {
      recommendation = t.recommendations.excellent;
    } else if (scorePercentage >= 50 && canAfford && safetyAfterPurchase >= 0) {
      recommendation = t.recommendations.good;
    } else if (scorePercentage >= 25 && canAfford) {
      recommendation = t.recommendations.okay;
    } else {
      recommendation = t.recommendations.poor;
    }

    return {
      recommendation,
      totalScore,
      maxScore,
      scorePercentage,
      canAfford,
      safetyAfterPurchase
    };
  };

  // Auto-evaluate when all questions are answered
  useEffect(() => {
    if (answers.length === t.questions.length && itemCost > 0) {
      setDecision(evaluateDecision());
    } else {
      setDecision(null);
    }
  }, [answers, itemCost, finalAvailable]);

  const handleAnswer = (questionId: string, option: any) => {
    const newAnswer: QuestionAnswer = {
      questionId,
      answer: option.text,
      score: option.score
    };

    setAnswers(prev => {
      const filtered = prev.filter(a => a.questionId !== questionId);
      return [...filtered, newAnswer];
    });
  };

  const handleItemNameChange = (value: string) => {
    setFormData(prev => ({ ...prev, itemName: value }));
    if (formErrors.itemName && value.trim()) {
      setFormErrors(prev => ({ ...prev, itemName: false }));
    }
  };

  const handleItemCostChange = (value: string) => {
    setFormData(prev => ({ ...prev, itemCost: value }));
    if (formErrors.itemCost && value) {
      setFormErrors(prev => ({ ...prev, itemCost: false }));
    }
  };

  const validateForm = () => {
    const newErrors = {
      itemName: !formData.itemName.trim(),
      itemCost: !formData.itemCost || parseFloat(formData.itemCost) <= 0
    };

    setFormErrors(newErrors);
    return !Object.values(newErrors).some(error => error);
  };

  const handlePurchase = () => {
    if (!validateForm() || !decision || !canAfford) return;

    // Create purchase decision record
    const purchaseDecision: PurchaseDecision = {
      id: Date.now().toString(),
      item: formData.itemName.trim(),
      price: itemCost,
      decision: decision.scorePercentage >= 75 ? 'recommended' : 
               decision.scorePercentage >= 50 ? 'wait' : 'not-recommended',
      reasoning: {
        wastingMoney: `Score: ${decision.totalScore}/${decision.maxScore}`,
        needingMoney: `Available: ${formatCurrency(finalAvailable, userData.currency)}`,
        realizing: decision.recommendation.message,
        guilty: decision.recommendation.action
      },
      answers: answers.reduce((acc, answer) => {
        acc[answer.questionId] = answer.answer;
        return acc;
      }, {} as Record<string, string>),
      purchased: true,
      purchasedDate: new Date().toISOString(),
      createdAt: new Date().toISOString()
    };

    savePurchaseDecision(purchaseDecision);
    updateUserBalance(userData.currentBalance - itemCost);
    setShowPurchaseConfirm(true);
  };

  const getFinancialStatusColor = () => {
    if (finalAvailable >= itemCost * 2) return 'text-green-600';
    if (finalAvailable >= itemCost) return 'text-[#819067]';
    return 'text-red-500';
  };

  const isFormValid = formData.itemName.trim() && 
                     itemCost > 0 && 
                     answers.length === t.questions.length;

  if (showPurchaseConfirm) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-white to-[#819067]/5 safe-area-top safe-area-bottom flex items-center justify-center" dir={userData.language === 'ar' ? 'rtl' : 'ltr'}>
        <div className="px-6 py-8 text-center">
          <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none">
              <path d="M9 12L11 14L15 10" stroke="#059669" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/>
              <circle cx="12" cy="12" r="10" stroke="#059669" strokeWidth="2"/>
            </svg>
          </div>
          
          <h2 className="text-2xl font-bold text-[#435446] mb-2">{t.purchased}</h2>
          <p className="text-lg text-[#435446] mb-6">{formData.itemName}</p>
          
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10 mb-8">
            <div className="space-y-3">
              <div className="flex justify-between">
                <span className="text-[#435446]/70">Cost:</span>
                <span className="font-medium text-[#435446]">
                  {formatCurrency(itemCost, userData.currency)}
                </span>
              </div>
              <div className="flex justify-between border-t border-[#819067]/20 pt-3">
                <span className="text-[#435446]/70">{t.newBalance}:</span>
                <span className="font-semibold text-[#819067]">
                  {formatCurrency(userData.currentBalance - itemCost, userData.currency)}
                </span>
              </div>
            </div>
          </div>
          
          <button
            onClick={onBack}
            className="w-full py-4 px-6 bg-[#819067] text-[#FEFAE0] rounded-xl font-medium hover:bg-[#819067]/90 transition-all interactive-scale"
          >
            {t.back}
          </button>
        </div>
      </div>
    );
  }

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
        {/* Purchase Details Section */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10 space-y-6">
          <h3 className="text-lg font-semibold text-[#435446]">{t.itemDetailsTitle}</h3>
          
          <div>
            <label className="block text-sm font-medium text-[#435446] mb-2">
              {t.itemNameTitle} <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              value={formData.itemName}
              onChange={(e) => handleItemNameChange(e.target.value)}
              placeholder={t.itemNamePlaceholder}
              className={`w-full p-4 border rounded-xl bg-[#819067]/5 text-[#435446] placeholder-[#435446]/50 focus:outline-none focus:ring-2 transition-all ${
                formErrors.itemName 
                  ? 'border-red-500 focus:ring-red-500/30' 
                  : 'border-[#819067]/20 focus:ring-[#819067]/30'
              }`}
            />
            {formErrors.itemName && (
              <p className="text-red-500 text-sm mt-2">{t.required}</p>
            )}
          </div>

          <div>
            <label className="block text-sm font-medium text-[#435446] mb-2">
              {t.itemCostTitle} <span className="text-red-500">*</span>
            </label>
            <div className="relative">
              <input
                type="number"
                value={formData.itemCost}
                onChange={(e) => handleItemCostChange(e.target.value)}
                placeholder={t.itemCostPlaceholder}
                className={`w-full p-4 border rounded-xl bg-[#819067]/5 text-[#435446] placeholder-[#435446]/50 focus:outline-none focus:ring-2 transition-all pr-16 ${
                  formErrors.itemCost 
                    ? 'border-red-500 focus:ring-red-500/30' 
                    : 'border-[#819067]/20 focus:ring-[#819067]/30'
                }`}
                min="0"
              />
              <div className={`absolute top-1/2 transform -translate-y-1/2 text-[#435446]/60 ${userData.language === 'ar' ? 'left-4' : 'right-4'}`}>
                {userData.currency === 'SAR' ? 'ر.س' : '$'}
              </div>
            </div>
            {formErrors.itemCost && (
              <p className="text-red-500 text-sm mt-2">{t.required}</p>
            )}
          </div>
        </div>

        {/* Financial Impact Section */}
        {itemCost > 0 && (
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10">
            <h3 className="text-lg font-semibold text-[#435446] mb-4">{t.financialImpactTitle}</h3>
            
            <div className="space-y-3">
              <div className="flex justify-between items-center">
                <span className="text-[#435446]/70">{t.currentBalance}:</span>
                <span className="font-medium text-[#435446]">
                  {formatCurrency(userData.currentBalance, userData.currency)}
                </span>
              </div>
              
              <div className="flex justify-between items-center">
                <span className="text-[#435446]/70">{t.afterExpenses}:</span>
                <span className="font-medium text-[#435446]">
                  {formatCurrency(afterExpenses, userData.currency)}
                </span>
              </div>
              
              <div className="flex justify-between items-center">
                <span className="text-[#435446]/70">{t.afterSavings}:</span>
                <span className="font-medium text-[#435446]">
                  {formatCurrency(afterSavings, userData.currency)}
                </span>
              </div>
              
              <div className="border-t border-[#819067]/20 pt-3">
                <div className="flex justify-between items-center">
                  <span className="font-medium text-[#435446]">{t.finalAvailable}:</span>
                  <span className={`font-bold text-lg ${getFinancialStatusColor()}`}>
                    {formatCurrency(finalAvailable, userData.currency)}
                  </span>
                </div>
              </div>

              <div className="mt-4 p-4 bg-[#819067]/5 rounded-lg">
                <div className="flex justify-between items-center">
                  <span className="text-[#435446]/70">{t.afterPurchase}:</span>
                  <span className={`font-semibold ${safetyAfterPurchase >= 0 ? 'text-[#819067]' : 'text-red-500'}`}>
                    {formatCurrency(safetyAfterPurchase, userData.currency)}
                  </span>
                </div>
              </div>

              {!canAfford && (
                <div className="bg-red-50 border border-red-200 rounded-lg p-3">
                  <p className="text-red-600 font-medium text-sm">{t.notEnoughFunds}</p>
                  <p className="text-red-500 text-sm">
                    {t.needMore} {formatCurrency(itemCost - finalAvailable, userData.currency)} {t.more}
                  </p>
                </div>
              )}
            </div>
          </div>
        )}

        {/* Questions Section */}
        {itemCost > 0 && (
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10">
            <h3 className="text-lg font-semibold text-[#435446] mb-6">{t.questionsTitle}</h3>
            
            <div className="space-y-6">
              {t.questions.map((question, questionIndex) => {
                const currentAnswer = answers.find(a => a.questionId === question.id);
                
                return (
                  <div key={question.id}>
                    <h4 className="font-medium text-[#435446] mb-4">{question.question}</h4>
                    
                    <div className="grid grid-cols-2 gap-3">
                      {question.options.map((option, optionIndex) => {
                        const isSelected = currentAnswer?.answer === option.text;
                        
                        return (
                          <button
                            key={optionIndex}
                            onClick={() => handleAnswer(question.id, option)}
                            className={`p-4 rounded-xl border-2 transition-all ${
                              isSelected
                                ? 'border-[#819067] bg-[#819067]/10 text-[#435446]'
                                : 'border-[#819067]/20 bg-white hover:border-[#819067]/40 text-[#435446] hover:scale-105'
                            }`}
                          >
                            <div className="text-2xl mb-2">{option.emoji}</div>
                            <div className="text-sm font-medium">{option.text}</div>
                          </button>
                        );
                      })}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* Recommendation Section */}
        {decision && (
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10">
            <h3 className="text-lg font-semibold text-[#435446] mb-4">{t.resultTitle}</h3>
            
            <div className="text-center mb-6">
              <div className="text-4xl mb-4">
                {decision.recommendation.title.includes('✅') ? '✅' :
                 decision.recommendation.title.includes('👍') ? '👍' :
                 decision.recommendation.title.includes('⚠️') ? '⚠️' : '❌'}
              </div>
              
              <h4 className="text-lg font-bold text-[#435446] mb-3">
                {decision.recommendation.title}
              </h4>
              
              <p className="text-[#435446]/80 mb-4">
                {decision.recommendation.message}
              </p>
              
              <div className="text-sm font-medium text-[#819067]">
                {decision.recommendation.action}
              </div>
            </div>

            {/* Purchase Button */}
            {canAfford && (
              <div className="space-y-3">
                <button
                  onClick={handlePurchase}
                  disabled={!isFormValid}
                  className={`w-full py-4 px-6 rounded-xl font-medium transition-all interactive-scale ${
                    isFormValid
                      ? 'bg-[#819067] text-[#FEFAE0] hover:bg-[#819067]/90 shadow-lg'
                      : 'bg-[#819067]/30 text-[#FEFAE0]/60 cursor-not-allowed'
                  }`}
                >
                  💳 {t.buyItem}
                </button>
                
                <p className="text-xs text-center text-[#435446]/60">
                  {t.recordedInHistory}
                </p>
              </div>
            )}
          </div>
        )}

        {/* Incomplete Form Message */}
        {itemCost > 0 && answers.length < t.questions.length && (
          <div className="bg-[#819067]/5 rounded-2xl p-4 border border-[#819067]/20 text-center">
            <p className="text-[#435446]/70 text-sm">{t.answersRequired}</p>
          </div>
        )}

        {/* Back Button */}
        <button
          onClick={onBack}
          className="w-full py-4 px-6 border border-[#819067]/30 rounded-xl text-[#435446] hover:bg-[#819067]/5 transition-all"
        >
          {t.back}
        </button>
      </div>
    </div>
  );
}
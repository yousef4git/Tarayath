import React, { useState } from 'react';
import { type UserData } from '../utils/localStorage';

interface CollectInfoScreenProps {
  onComplete: (userData: UserData) => void;
}

export function CollectInfoScreen({ onComplete }: CollectInfoScreenProps) {
  const [language, setLanguage] = useState<'en' | 'ar'>('en');
  const [formData, setFormData] = useState({
    fullName: '',
    monthlyIncome: '',
    monthlyObligations: '',
    currentBalance: '',
    currency: 'SAR' as 'SAR' | 'USD'
  });
  const [errors, setErrors] = useState({
    fullName: false,
    monthlyIncome: false,
    currentBalance: false
  });

  const texts = {
    en: {
      title: 'Let\'s get to know you',
      subtitle: 'Help us create your perfect financial plan',
      fullName: 'Full Name',
      fullNamePlaceholder: 'Enter your full name',
      monthlyIncome: 'Monthly Income',
      monthlyIncomePlaceholder: 'Enter your monthly income',
      monthlyObligations: 'Monthly Obligations',
      monthlyObligationsPlaceholder: 'Enter monthly obligations (rent, bills, etc.)',
      monthlyObligationsOptional: 'Optional',
      currentBalance: 'Current Balance',
      currentBalancePlaceholder: 'How much money do you have now?',
      currency: 'Currency',
      getStarted: 'Get Started',
      required: 'This field is required',
      pleaseComplete: 'Please complete all required fields'
    },
    ar: {
      title: 'دعنا نتعرف عليك',
      subtitle: 'ساعدنا في إنشاء خطتك المالية المثالية',
      fullName: 'الاسم الكامل',
      fullNamePlaceholder: 'أدخل اسمك الكامل',
      monthlyIncome: 'الدخل الشهري',
      monthlyIncomePlaceholder: 'أدخل دخلك الشهري',
      monthlyObligations: 'الالتزامات الشهرية',
      monthlyObligationsPlaceholder: 'أدخل التزاماتك الشهرية (إيجار، فواتير، إلخ)',
      monthlyObligationsOptional: 'اختياري',
      currentBalance: 'الرصيد الحالي',
      currentBalancePlaceholder: 'كم المال الذي تملكه الآن؟',
      currency: 'العملة',
      getStarted: 'ابدأ',
      required: 'هذا الحقل مطلوب',
      pleaseComplete: 'يرجى إكمال جميع الحقول المطلوبة'
    }
  };

  const t = texts[language];

  const handleInputChange = (field: string, value: string) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
    }));
    
    // Clear error when user starts typing
    if (errors[field as keyof typeof errors]) {
      setErrors(prev => ({
        ...prev,
        [field]: false
      }));
    }
  };

  const validateForm = () => {
    const newErrors = {
      fullName: !formData.fullName.trim(),
      monthlyIncome: !formData.monthlyIncome || parseFloat(formData.monthlyIncome) <= 0,
      currentBalance: !formData.currentBalance || parseFloat(formData.currentBalance) < 0
    };

    setErrors(newErrors);
    return !Object.values(newErrors).some(error => error);
  };

  const handleSubmit = () => {
    if (!validateForm()) {
      return;
    }

    const userData: UserData = {
      fullName: formData.fullName.trim(),
      monthlyIncome: parseFloat(formData.monthlyIncome) || 0,
      monthlyObligations: parseFloat(formData.monthlyObligations) || 0,
      currentBalance: parseFloat(formData.currentBalance) || 0,
      currency: formData.currency,
      language
    };
    
    onComplete(userData);
  };

  const isFormValid = formData.fullName.trim() && 
                     formData.monthlyIncome && 
                     parseFloat(formData.monthlyIncome) > 0 && 
                     formData.currentBalance && 
                     parseFloat(formData.currentBalance) >= 0;

  return (
    <div className="min-h-screen bg-gradient-to-b from-white to-[#819067]/5 safe-area-top safe-area-bottom" dir={language === 'ar' ? 'rtl' : 'ltr'}>
      {/* Language Toggle */}
      <div className={`absolute top-4 z-10 safe-area-top ${language === 'ar' ? 'left-4' : 'right-4'}`}>
        <div className="flex bg-white/90 backdrop-blur-sm rounded-xl p-1 shadow-sm border border-[#819067]/20">
          <button
            onClick={() => setLanguage('en')}
            className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-all duration-200 ${
              language === 'en'
                ? 'bg-[#819067] text-[#FEFAE0] shadow-sm'
                : 'text-[#435446] hover:bg-[#819067]/10'
            }`}
          >
            EN
          </button>
          <button
            onClick={() => setLanguage('ar')}
            className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-all duration-200 ${
              language === 'ar'
                ? 'bg-[#819067] text-[#FEFAE0] shadow-sm'
                : 'text-[#435446] hover:bg-[#819067]/10'
            }`}
          >
            AR
          </button>
        </div>
      </div>

      <div className="flex flex-col min-h-screen px-6 py-8">
        {/* Header */}
        <div className="text-center mb-8 mt-8">
          <div className="w-20 h-20 bg-[#819067] rounded-2xl flex items-center justify-center mx-auto mb-6 shadow-lg">
            <span className="text-[#FEFAE0] text-2xl font-bold">T</span>
          </div>
          <h1 className="text-2xl font-bold text-[#435446] mb-2">{t.title}</h1>
          <p className="text-[#435446]/70">{t.subtitle}</p>
        </div>

        {/* Form Container */}
        <div className="flex-1 bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10 mb-6">
          <div className="space-y-6">
            {/* Full Name */}
            <div>
              <label className="block text-[#435446] font-medium mb-2">
                {t.fullName} <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.fullName}
                onChange={(e) => handleInputChange('fullName', e.target.value)}
                placeholder={t.fullNamePlaceholder}
                className={`w-full p-4 border rounded-xl bg-[#819067]/5 text-[#435446] placeholder-[#435446]/50 focus:outline-none focus:ring-2 transition-all ${
                  errors.fullName 
                    ? 'border-red-500 focus:ring-red-500/30' 
                    : 'border-[#819067]/20 focus:ring-[#819067]/30'
                }`}
              />
              {errors.fullName && (
                <p className="text-red-500 text-sm mt-1">{t.required}</p>
              )}
            </div>

            {/* Monthly Income */}
            <div>
              <label className="block text-[#435446] font-medium mb-2">
                {t.monthlyIncome} <span className="text-red-500">*</span>
              </label>
              <div className="relative">
                <input
                  type="number"
                  value={formData.monthlyIncome}
                  onChange={(e) => handleInputChange('monthlyIncome', e.target.value)}
                  placeholder={t.monthlyIncomePlaceholder}
                  className={`w-full p-4 border rounded-xl bg-[#819067]/5 text-[#435446] placeholder-[#435446]/50 focus:outline-none focus:ring-2 transition-all pr-16 ${
                    errors.monthlyIncome 
                      ? 'border-red-500 focus:ring-red-500/30' 
                      : 'border-[#819067]/20 focus:ring-[#819067]/30'
                  }`}
                  min="0"
                />
                <div className={`absolute top-1/2 transform -translate-y-1/2 text-[#435446]/60 ${language === 'ar' ? 'left-4' : 'right-4'}`}>
                  {formData.currency === 'SAR' ? 'ر.س' : '$'}
                </div>
              </div>
              {errors.monthlyIncome && (
                <p className="text-red-500 text-sm mt-1">{t.required}</p>
              )}
            </div>

            {/* Monthly Obligations */}
            <div>
              <label className="block text-[#435446] font-medium mb-2">
                {t.monthlyObligations} 
                <span className="text-[#435446]/60 text-sm ml-2">({t.monthlyObligationsOptional})</span>
              </label>
              <div className="relative">
                <input
                  type="number"
                  value={formData.monthlyObligations}
                  onChange={(e) => handleInputChange('monthlyObligations', e.target.value)}
                  placeholder={t.monthlyObligationsPlaceholder}
                  className="w-full p-4 border border-[#819067]/20 rounded-xl bg-[#819067]/5 text-[#435446] placeholder-[#435446]/50 focus:outline-none focus:ring-2 focus:ring-[#819067]/30 transition-all pr-16"
                  min="0"
                />
                <div className={`absolute top-1/2 transform -translate-y-1/2 text-[#435446]/60 ${language === 'ar' ? 'left-4' : 'right-4'}`}>
                  {formData.currency === 'SAR' ? 'ر.س' : '$'}
                </div>
              </div>
            </div>

            {/* Current Balance */}
            <div>
              <label className="block text-[#435446] font-medium mb-2">
                {t.currentBalance} <span className="text-red-500">*</span>
              </label>
              <div className="relative">
                <input
                  type="number"
                  value={formData.currentBalance}
                  onChange={(e) => handleInputChange('currentBalance', e.target.value)}
                  placeholder={t.currentBalancePlaceholder}
                  className={`w-full p-4 border rounded-xl bg-[#819067]/5 text-[#435446] placeholder-[#435446]/50 focus:outline-none focus:ring-2 transition-all pr-16 ${
                    errors.currentBalance 
                      ? 'border-red-500 focus:ring-red-500/30' 
                      : 'border-[#819067]/20 focus:ring-[#819067]/30'
                  }`}
                  min="0"
                />
                <div className={`absolute top-1/2 transform -translate-y-1/2 text-[#435446]/60 ${language === 'ar' ? 'left-4' : 'right-4'}`}>
                  {formData.currency === 'SAR' ? 'ر.س' : '$'}
                </div>
              </div>
              {errors.currentBalance && (
                <p className="text-red-500 text-sm mt-1">{t.required}</p>
              )}
            </div>

            {/* Currency Selection */}
            <div>
              <label className="block text-[#435446] font-medium mb-3">
                {t.currency}
              </label>
              <div className="grid grid-cols-2 gap-3">
                <button
                  onClick={() => handleInputChange('currency', 'SAR')}
                  className={`p-4 rounded-xl border-2 transition-all text-center ${
                    formData.currency === 'SAR'
                      ? 'border-[#819067] bg-[#819067]/10 text-[#435446]'
                      : 'border-[#819067]/20 bg-white hover:border-[#819067]/40 text-[#435446]'
                  }`}
                >
                  <div className="font-medium">Saudi Riyal</div>
                  <div className="text-sm text-[#435446]/60">ر.س</div>
                </button>
                <button
                  onClick={() => handleInputChange('currency', 'USD')}
                  className={`p-4 rounded-xl border-2 transition-all text-center ${
                    formData.currency === 'USD'
                      ? 'border-[#819067] bg-[#819067]/10 text-[#435446]'
                      : 'border-[#819067]/20 bg-white hover:border-[#819067]/40 text-[#435446]'
                  }`}
                >
                  <div className="font-medium">US Dollar</div>
                  <div className="text-sm text-[#435446]/60">$</div>
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* Submit Button */}
        <button
          onClick={handleSubmit}
          disabled={!isFormValid}
          className={`w-full py-4 px-6 rounded-xl font-medium transition-all interactive-scale ${
            isFormValid
              ? 'bg-[#819067] text-[#FEFAE0] hover:bg-[#819067]/90 shadow-lg'
              : 'bg-[#819067]/30 text-[#FEFAE0]/60 cursor-not-allowed'
          }`}
        >
          {t.getStarted}
        </button>

        {!isFormValid && (Object.values(errors).some(error => error)) && (
          <p className="text-red-500 text-sm text-center mt-2">{t.pleaseComplete}</p>
        )}
      </div>
    </div>
  );
}
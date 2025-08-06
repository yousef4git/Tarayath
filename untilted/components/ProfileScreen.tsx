import React, { useState } from 'react';
import { type UserData } from '../utils/localStorage';

interface ProfileScreenProps {
  userData: UserData | null;
  onUpdateUserData: (data: UserData) => void;
  onBack: () => void;
}

export function ProfileScreen({ userData, onUpdateUserData, onBack }: ProfileScreenProps) {
  const [isEditing, setIsEditing] = useState(false);
  const [formData, setFormData] = useState(userData || {
    fullName: '',
    monthlyIncome: 0,
    monthlyObligations: 0,
    currentBalance: 0,
    currency: 'SAR' as 'SAR' | 'USD',
    language: 'en' as 'en' | 'ar'
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
      title: 'Profile',
      subtitle: 'Your account settings',
      editProfile: 'Edit Profile',
      saveChanges: 'Save Changes',
      cancel: 'Cancel',
      basicInfo: 'Basic Information',
      financialInfo: 'Financial Information',
      preferences: 'Preferences',
      fullName: 'Full Name',
      monthlyIncome: 'Monthly Income',
      monthlyObligations: 'Monthly Obligations',
      currentBalance: 'Current Balance',
      currency: 'Currency',
      language: 'Language',
      languageOptions: {
        en: 'English',
        ar: 'العربية'
      }
    },
    ar: {
      title: 'الملف الشخصي',
      subtitle: 'إعدادات حسابك',
      editProfile: 'تعديل الملف',
      saveChanges: 'حفظ التغييرات',
      cancel: 'إلغاء',
      basicInfo: 'المعلومات الأساسية',
      financialInfo: 'المعلومات المالية',
      preferences: 'التفضيلات',
      fullName: 'الاسم الكامل',
      monthlyIncome: 'الدخل الشهري',
      monthlyObligations: 'الالتزامات الشهرية',
      currentBalance: 'الرصيد الحالي',
      currency: 'العملة',
      language: 'اللغة',
      languageOptions: {
        en: 'English',
        ar: 'العربية'
      }
    }
  };

  const t = texts[userData.language || 'en'];

  const formatCurrency = (amount: number) => {
    const symbol = userData.currency === 'SAR' ? 'ر.س' : '$';
    const formattedAmount = new Intl.NumberFormat('en-US').format(amount);
    return userData.currency === 'SAR' ? `${formattedAmount} ${symbol}` : `${symbol}${formattedAmount}`;
  };

  const handleSave = () => {
    onUpdateUserData(formData);
    setIsEditing(false);
  };

  const handleCancel = () => {
    setFormData(userData);
    setIsEditing(false);
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-white to-[#819067]/5 safe-area-top safe-area-bottom" dir={userData.language === 'ar' ? 'rtl' : 'ltr'}>
      {/* Header */}
      <div className="bg-white border-b border-[#819067]/10">
        <div className="px-6 py-6">
          <div className="flex items-center justify-between">
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
            
            {!isEditing && (
              <button
                onClick={() => setIsEditing(true)}
                className="px-4 py-2 bg-[#819067] text-[#FEFAE0] rounded-lg hover:bg-[#819067]/90 transition-colors"
              >
                {t.editProfile}
              </button>
            )}
          </div>
        </div>
      </div>

      <div className="px-6 py-6 space-y-6">
        {/* Basic Information */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10">
          <h3 className="font-semibold text-[#435446] mb-6">{t.basicInfo}</h3>
          
          <div className="space-y-4">
            {/* Full Name */}
            <div>
              <label className="block text-sm font-medium text-[#435446] mb-2">
                {t.fullName}
              </label>
              {isEditing ? (
                <input
                  type="text"
                  value={formData.fullName}
                  onChange={(e) => setFormData(prev => ({ ...prev, fullName: e.target.value }))}
                  className="w-full p-3 border border-[#819067]/20 rounded-xl bg-[#819067]/5 text-[#435446] focus:outline-none focus:ring-2 focus:ring-[#819067]/30"
                />
              ) : (
                <p className="text-[#435446] p-3 bg-[#819067]/5 rounded-xl">{userData.fullName}</p>
              )}
            </div>
          </div>
        </div>

        {/* Financial Information */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10">
          <h3 className="font-semibold text-[#435446] mb-6">{t.financialInfo}</h3>
          
          <div className="space-y-4">
            {/* Monthly Income */}
            <div>
              <label className="block text-sm font-medium text-[#435446] mb-2">
                {t.monthlyIncome}
              </label>
              {isEditing ? (
                <div className="relative">
                  <input
                    type="number"
                    value={formData.monthlyIncome}
                    onChange={(e) => setFormData(prev => ({ ...prev, monthlyIncome: parseFloat(e.target.value) || 0 }))}
                    className="w-full p-3 border border-[#819067]/20 rounded-xl bg-[#819067]/5 text-[#435446] focus:outline-none focus:ring-2 focus:ring-[#819067]/30 pr-16"
                  />
                  <div className={`absolute top-1/2 transform -translate-y-1/2 text-[#435446]/60 ${userData.language === 'ar' ? 'left-4' : 'right-4'}`}>
                    {userData.currency === 'SAR' ? 'ر.س' : '$'}
                  </div>
                </div>
              ) : (
                <p className="text-[#435446] p-3 bg-[#819067]/5 rounded-xl">
                  {formatCurrency(userData.monthlyIncome)}
                </p>
              )}
            </div>

            {/* Monthly Obligations */}
            <div>
              <label className="block text-sm font-medium text-[#435446] mb-2">
                {t.monthlyObligations}
              </label>
              {isEditing ? (
                <div className="relative">
                  <input
                    type="number"
                    value={formData.monthlyObligations}
                    onChange={(e) => setFormData(prev => ({ ...prev, monthlyObligations: parseFloat(e.target.value) || 0 }))}
                    className="w-full p-3 border border-[#819067]/20 rounded-xl bg-[#819067]/5 text-[#435446] focus:outline-none focus:ring-2 focus:ring-[#819067]/30 pr-16"
                  />
                  <div className={`absolute top-1/2 transform -translate-y-1/2 text-[#435446]/60 ${userData.language === 'ar' ? 'left-4' : 'right-4'}`}>
                    {userData.currency === 'SAR' ? 'ر.س' : '$'}
                  </div>
                </div>
              ) : (
                <p className="text-[#435446] p-3 bg-[#819067]/5 rounded-xl">
                  {formatCurrency(userData.monthlyObligations)}
                </p>
              )}
            </div>

            {/* Current Balance */}
            <div>
              <label className="block text-sm font-medium text-[#435446] mb-2">
                {t.currentBalance}
              </label>
              {isEditing ? (
                <div className="relative">
                  <input
                    type="number"
                    value={formData.currentBalance}
                    onChange={(e) => setFormData(prev => ({ ...prev, currentBalance: parseFloat(e.target.value) || 0 }))}
                    className="w-full p-3 border border-[#819067]/20 rounded-xl bg-[#819067]/5 text-[#435446] focus:outline-none focus:ring-2 focus:ring-[#819067]/30 pr-16"
                  />
                  <div className={`absolute top-1/2 transform -translate-y-1/2 text-[#435446]/60 ${userData.language === 'ar' ? 'left-4' : 'right-4'}`}>
                    {userData.currency === 'SAR' ? 'ر.س' : '$'}
                  </div>
                </div>
              ) : (
                <p className="text-[#435446] p-3 bg-[#819067]/5 rounded-xl">
                  {formatCurrency(userData.currentBalance)}
                </p>
              )}
            </div>
          </div>
        </div>

        {/* Preferences */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-[#819067]/10">
          <h3 className="font-semibold text-[#435446] mb-6">{t.preferences}</h3>
          
          <div className="space-y-4">
            {/* Currency */}
            <div>
              <label className="block text-sm font-medium text-[#435446] mb-2">
                {t.currency}
              </label>
              {isEditing ? (
                <select
                  value={formData.currency}
                  onChange={(e) => setFormData(prev => ({ ...prev, currency: e.target.value as 'SAR' | 'USD' }))}
                  className="w-full p-3 border border-[#819067]/20 rounded-xl bg-[#819067]/5 text-[#435446] focus:outline-none focus:ring-2 focus:ring-[#819067]/30"
                >
                  <option value="SAR">Saudi Riyal (ر.س)</option>
                  <option value="USD">US Dollar ($)</option>
                </select>
              ) : (
                <p className="text-[#435446] p-3 bg-[#819067]/5 rounded-xl">
                  {userData.currency === 'SAR' ? 'Saudi Riyal (ر.س)' : 'US Dollar ($)'}
                </p>
              )}
            </div>

            {/* Language */}
            <div>
              <label className="block text-sm font-medium text-[#435446] mb-2">
                {t.language}
              </label>
              {isEditing ? (
                <select
                  value={formData.language}
                  onChange={(e) => setFormData(prev => ({ ...prev, language: e.target.value as 'en' | 'ar' }))}
                  className="w-full p-3 border border-[#819067]/20 rounded-xl bg-[#819067]/5 text-[#435446] focus:outline-none focus:ring-2 focus:ring-[#819067]/30"
                >
                  {Object.entries(t.languageOptions).map(([key, label]) => (
                    <option key={key} value={key}>{label}</option>
                  ))}
                </select>
              ) : (
                <p className="text-[#435446] p-3 bg-[#819067]/5 rounded-xl">
                  {t.languageOptions[userData.language || 'en']}
                </p>
              )}
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        {isEditing && (
          <div className="flex space-x-4">
            <button
              onClick={handleCancel}
              className="flex-1 py-4 px-6 border border-[#819067]/30 rounded-xl text-[#435446] hover:bg-[#819067]/5 transition-all"
            >
              {t.cancel}
            </button>
            <button
              onClick={handleSave}
              className="flex-1 py-4 px-6 bg-[#819067] text-[#FEFAE0] rounded-xl hover:bg-[#819067]/90 transition-all"
            >
              {t.saveChanges}
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
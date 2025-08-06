export interface UserData {
  fullName: string;
  monthlyIncome: number;
  monthlyObligations: number;
  currentBalance: number; // Current money in account
  currency: 'SAR' | 'USD';
  language: 'en' | 'ar';
}

export interface SavingsPlan {
  id: string;
  goal: string;
  targetAmount: number;
  monthlyAmount: number;
  duration: number;
  currentSavings: number;
  currentAmount?: number;
  timeframe?: number;
  isCompleted: boolean;
  createdAt: string;
  completedAt?: string;
}

export interface PurchaseDecision {
  id: string;
  item: string;
  price: number;
  decision: 'recommended' | 'wait' | 'not-recommended';
  reasoning: {
    wastingMoney: string;
    needingMoney: string;
    realizing: string;
    guilty: string;
  };
  answers: Record<string, string>;
  purchased: boolean;
  purchasedDate?: string;
  createdAt: string;
}

export interface BudgetBuckets {
  needs: number;
  wants: number;
  savings: number;
}

export interface AppData {
  userData: UserData | null;
  savingsPlans: SavingsPlan[];
  purchaseDecisions: PurchaseDecision[];
  budgetBuckets: BudgetBuckets;
  hasCompletedOnboarding: boolean;
}

const STORAGE_KEY = 'tarayath_app_data';

const defaultBudgetBuckets: BudgetBuckets = {
  needs: 50,
  wants: 30,
  savings: 20
};

const defaultData: AppData = {
  userData: null,
  savingsPlans: [],
  purchaseDecisions: [],
  budgetBuckets: defaultBudgetBuckets,
  hasCompletedOnboarding: false,
};

export const loadAppData = (): AppData => {
  try {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) {
      const data = JSON.parse(stored);
      return { 
        ...defaultData, 
        ...data,
        budgetBuckets: data.budgetBuckets || defaultBudgetBuckets
      };
    }
  } catch (error) {
    console.error('Error loading app data:', error);
  }
  return defaultData;
};

export const saveAppData = (data: Partial<AppData>): void => {
  try {
    const currentData = loadAppData();
    const updatedData = { ...currentData, ...data };
    localStorage.setItem(STORAGE_KEY, JSON.stringify(updatedData));
  } catch (error) {
    console.error('Error saving app data:', error);
  }
};

export const clearAppData = (): void => {
  try {
    localStorage.removeItem(STORAGE_KEY);
  } catch (error) {
    console.error('Error clearing app data:', error);
  }
};

export const saveUserData = (userData: UserData): void => {
  saveAppData({ userData });
};

export const saveSavingsPlan = (savingsPlan: SavingsPlan): void => {
  const currentData = loadAppData();
  const existingPlanIndex = currentData.savingsPlans.findIndex(p => p.id === savingsPlan.id);
  
  let savingsPlans: SavingsPlan[];
  if (existingPlanIndex !== -1) {
    savingsPlans = [...currentData.savingsPlans];
    savingsPlans[existingPlanIndex] = savingsPlan;
  } else {
    savingsPlans = [...currentData.savingsPlans, savingsPlan];
  }
  
  saveAppData({ savingsPlans });
};

export const savePurchaseDecision = (decision: PurchaseDecision): void => {
  const currentData = loadAppData();
  const existingIndex = currentData.purchaseDecisions.findIndex(d => d.id === decision.id);
  
  let purchaseDecisions: PurchaseDecision[];
  if (existingIndex !== -1) {
    purchaseDecisions = [...currentData.purchaseDecisions];
    purchaseDecisions[existingIndex] = decision;
  } else {
    purchaseDecisions = [...currentData.purchaseDecisions, decision];
  }
  
  saveAppData({ purchaseDecisions });
};

export const saveBudgetBuckets = (buckets: BudgetBuckets): void => {
  saveAppData({ budgetBuckets: buckets });
};

export const markOnboardingComplete = (): void => {
  saveAppData({ hasCompletedOnboarding: true });
};

export const updateUserBalance = (newBalance: number): void => {
  const currentData = loadAppData();
  if (currentData.userData) {
    const updatedUserData = { ...currentData.userData, currentBalance: newBalance };
    saveUserData(updatedUserData);
  }
};

// Currency formatting
export const formatCurrency = (amount: number, currency: 'SAR' | 'USD' = 'SAR'): string => {
  const symbol = currency === 'SAR' ? 'ر.س' : '$';
  const formattedAmount = new Intl.NumberFormat('en-US').format(amount);
  return currency === 'SAR' ? `${formattedAmount} ${symbol}` : `${symbol}${formattedAmount}`;
};
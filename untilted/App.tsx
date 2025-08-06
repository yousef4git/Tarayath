import React, { useState, useEffect } from 'react';
import { SplashScreen } from './components/SplashScreen';
import { CollectInfoScreen } from './components/CollectInfoScreen';
import { DashboardScreen } from './components/DashboardScreen';
import { SavingsPlanScreen } from './components/SavingsPlanScreen';
import { PurchaseDecisionScreen } from './components/PurchaseDecisionScreen';
import { ProfileScreen } from './components/ProfileScreen';
import { 
  loadAppData, 
  saveUserData, 
  saveSavingsPlan, 
  clearAppData,
  saveBudgetBuckets,
  type UserData,
  type SavingsPlan,
  type PurchaseDecision,
  type BudgetBuckets
} from './utils/localStorage';

export type Screen = 'splash' | 'collect-info' | 'dashboard' | 'savings-plan' | 'purchase-decision' | 'profile';

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>('splash');
  const [userData, setUserData] = useState<UserData | null>(null);
  const [savingsPlans, setSavingsPlans] = useState<SavingsPlan[]>([]);
  const [purchaseDecisions, setPurchaseDecisions] = useState<PurchaseDecision[]>([]);
  const [budgetBuckets, setBudgetBuckets] = useState<BudgetBuckets>({
    needs: 50,
    wants: 30,
    savings: 20
  });
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    loadInitialData();
  }, []);

  const loadInitialData = () => {
    try {
      const appData = loadAppData();
      setUserData(appData.userData);
      setSavingsPlans(appData.savingsPlans);
      setPurchaseDecisions(appData.purchaseDecisions || []);
      setBudgetBuckets(appData.budgetBuckets);
    } catch (error) {
      console.error('Error loading initial data:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const navigateToScreen = (screen: Screen) => {
    setCurrentScreen(screen);
  };

  const updateUserData = (data: UserData) => {
    setUserData(data);
    saveUserData(data);
  };

  const updateSavingsPlan = (plan: SavingsPlan) => {
    const updatedPlans = [...savingsPlans];
    const existingIndex = updatedPlans.findIndex(p => p.id === plan.id);
    
    if (existingIndex !== -1) {
      updatedPlans[existingIndex] = plan;
    } else {
      updatedPlans.push(plan);
    }
    
    setSavingsPlans(updatedPlans);
    saveSavingsPlan(plan);
  };

  const updateBudgetBuckets = (buckets: BudgetBuckets) => {
    setBudgetBuckets(buckets);
    saveBudgetBuckets(buckets);
  };

  const handleResetApp = () => {
    clearAppData();
    setUserData(null);
    setSavingsPlans([]);
    setPurchaseDecisions([]);
    setBudgetBuckets({ needs: 50, wants: 30, savings: 20 });
    setCurrentScreen('splash');
  };

  // Refresh data when returning to dashboard
  const refreshData = () => {
    loadInitialData();
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-[#819067] to-white flex items-center justify-center">
        <div className="w-32 h-32 bg-[#435446] rounded-3xl flex items-center justify-center shadow-lg animate-pulse">
          <span className="text-[#FEFAE0] text-3xl font-bold">T</span>
        </div>
      </div>
    );
  }

  const renderScreen = () => {
    switch (currentScreen) {
      case 'splash':
        return (
          <SplashScreen 
            onNext={() => {
              if (!userData) {
                navigateToScreen('collect-info');
              } else {
                navigateToScreen('dashboard');
              }
            }} 
          />
        );
      case 'collect-info':
        return (
          <CollectInfoScreen
            onComplete={(data) => {
              updateUserData(data);
              navigateToScreen('dashboard');
            }}
          />
        );
      case 'dashboard':
        return (
          <DashboardScreen
            userData={userData}
            savingsPlans={savingsPlans}
            purchaseDecisions={purchaseDecisions}
            budgetBuckets={budgetBuckets}
            onNavigate={navigateToScreen}
            onUpdateBudgetBuckets={updateBudgetBuckets}
            onResetApp={handleResetApp}
          />
        );
      case 'profile':
        return (
          <ProfileScreen
            userData={userData}
            onUpdateUserData={updateUserData}
            onBack={() => {
              refreshData();
              navigateToScreen('dashboard');
            }}
          />
        );
      case 'savings-plan':
        return (
          <SavingsPlanScreen
            userData={userData}
            budgetBuckets={budgetBuckets}
            existingPlans={savingsPlans}
            onComplete={updateSavingsPlan}
            onBack={() => {
              refreshData();
              navigateToScreen('dashboard');
            }}
          />
        );
      case 'purchase-decision':
        return (
          <PurchaseDecisionScreen
            userData={userData}
            savingsPlans={savingsPlans}
            budgetBuckets={budgetBuckets}
            onBack={() => {
              refreshData();
              navigateToScreen('dashboard');
            }}
          />
        );
      default:
        return (
          <SplashScreen 
            onNext={() => {
              if (!userData) {
                navigateToScreen('collect-info');
              } else {
                navigateToScreen('dashboard');
              }
            }} 
          />
        );
    }
  };

  return (
    <div className="min-h-screen bg-background">
      <div className="mx-auto max-w-sm min-h-screen bg-background">
        {renderScreen()}
      </div>
    </div>
  );
}
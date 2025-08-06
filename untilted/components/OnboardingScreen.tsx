import React from 'react';
import { Button } from './ui/button';
import { ArrowRight } from 'lucide-react';

interface OnboardingScreenProps {
  onNext: () => void;
}

export function OnboardingScreen({ onNext }: OnboardingScreenProps) {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen p-8 bg-gradient-to-b from-blue-50 to-white">
      <div className="flex-1 flex flex-col items-center justify-center space-y-8">
        {/* Logo */}
        <div className="w-32 h-32 bg-blue-600 rounded-3xl flex items-center justify-center shadow-lg">
          <span className="text-white text-3xl font-bold">T</span>
        </div>
        
        {/* App Name */}
        <h1 className="text-4xl font-bold text-gray-900 text-center">Tarayath</h1>
        
        {/* Tagline */}
        <p className="text-lg text-gray-600 text-center max-w-xs">
          Smart decisions start here.
        </p>
        
        {/* Additional Description */}
        <div className="text-center space-y-4 max-w-sm">
          <p className="text-gray-700">
            Take control of your finances with personalized savings plans, expense analysis, and smart purchase decisions.
          </p>
        </div>
      </div>
      
      {/* Next Button */}
      <div className="w-full">
        <Button 
          onClick={onNext}
          className="w-full h-14 bg-blue-600 hover:bg-blue-700 text-white rounded-2xl transition-all duration-200 active:scale-95"
          size="lg"
        >
          <span className="mr-2">Get Started</span>
          <ArrowRight className="w-5 h-5" />
        </Button>
      </div>
    </div>
  );
}
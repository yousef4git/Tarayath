import React, { useState, useEffect } from 'react';

interface SplashScreenProps {
  onNext: () => void;
}

export function SplashScreen({ onNext }: SplashScreenProps) {
  const [logoVisible, setLogoVisible] = useState(false);
  const [titleVisible, setTitleVisible] = useState(false);
  const [taglineVisible, setTaglineVisible] = useState(false);
  const [featuresVisible, setFeaturesVisible] = useState(false);
  const [buttonVisible, setButtonVisible] = useState(false);
  const [logoScale, setLogoScale] = useState(0.8);

  useEffect(() => {
    // Sequential animation timing
    const logoTimer = setTimeout(() => {
      setLogoVisible(true);
      setLogoScale(1);
    }, 200);

    const titleTimer = setTimeout(() => {
      setTitleVisible(true);
    }, 800);

    const taglineTimer = setTimeout(() => {
      setTaglineVisible(true);
    }, 1200);

    const featuresTimer = setTimeout(() => {
      setFeaturesVisible(true);
    }, 1600);

    const buttonTimer = setTimeout(() => {
      setButtonVisible(true);
    }, 2000);

    return () => {
      clearTimeout(logoTimer);
      clearTimeout(titleTimer);
      clearTimeout(taglineTimer);
      clearTimeout(featuresTimer);
      clearTimeout(buttonTimer);
    };
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-b from-white via-[#819067]/5 to-[#819067]/10 relative overflow-hidden safe-area-top safe-area-bottom">
      {/* Background decorations */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-gradient-to-br from-[#819067]/10 to-[#B1AB86]/5 rounded-full blur-3xl"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-gradient-to-tr from-[#435446]/5 to-[#819067]/10 rounded-full blur-3xl"></div>
        <div className="absolute top-1/4 right-1/3 w-2 h-2 bg-[#819067]/30 rounded-full"></div>
        <div className="absolute bottom-1/3 left-1/4 w-1 h-1 bg-[#B1AB86]/40 rounded-full"></div>
      </div>

      <div className="relative z-10 flex flex-col items-center justify-center min-h-screen px-8 py-16">
        {/* Logo section */}
        <div className="flex flex-col items-center mb-20">
          {/* Animated logo */}
          <div 
            className={`w-28 h-28 bg-gradient-to-br from-[#435446] via-[#819067] to-[#B1AB86] rounded-3xl flex items-center justify-center shadow-2xl transition-all duration-1000 ease-out mb-6 ${
              logoVisible ? 'opacity-100' : 'opacity-0'
            }`}
            style={{ 
              transform: `scale(${logoScale})`,
              boxShadow: '0 25px 50px -12px rgba(67, 84, 70, 0.4), 0 0 0 1px rgba(129, 144, 103, 0.1)'
            }}
          >
            <span className="text-[#FEFAE0] text-4xl font-bold tracking-tight">T</span>
          </div>

          {/* App title */}
          <div className={`text-center transition-all duration-700 ease-out ${
            titleVisible ? 'opacity-100 transform translate-y-0' : 'opacity-0 transform translate-y-4'
          }`}>
            <h1 className="text-3xl font-bold text-[#435446] tracking-tight mb-2">
              Tarayath
            </h1>
            <div className="w-16 h-1 bg-gradient-to-r from-[#819067] to-[#B1AB86] mx-auto rounded-full"></div>
          </div>
        </div>

        {/* Tagline */}
        <div className={`text-center mb-12 transition-all duration-700 ease-out delay-200 ${
          taglineVisible ? 'opacity-100 transform translate-y-0' : 'opacity-0 transform translate-y-4'
        }`}>
          <p className="text-xl text-[#435446]/80 max-w-xs leading-relaxed">
            Smart decisions start here
          </p>
        </div>

        {/* Feature preview icons */}
        <div className={`flex items-center justify-center space-x-8 mb-16 transition-all duration-700 ease-out delay-300 ${
          featuresVisible ? 'opacity-100 transform translate-y-0' : 'opacity-0 transform translate-y-6'
        }`}>
          {/* Savings Plan */}
          <div className="flex flex-col items-center">
            <div className="w-12 h-12 bg-[#819067]/10 backdrop-blur-sm rounded-2xl flex items-center justify-center mb-2 border border-[#819067]/20">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                <path
                  d="M12 2L15.09 8.26L22 9L17 14L18.18 21L12 17.77L5.82 21L7 14L2 9L8.91 8.26L12 2Z"
                  fill="#819067"
                />
              </svg>
            </div>
            <span className="text-xs text-[#435446]/70 font-medium">Save Smart</span>
          </div>

          {/* Expense Analysis */}
          <div className="flex flex-col items-center">
            <div className="w-12 h-12 bg-[#B1AB86]/10 backdrop-blur-sm rounded-2xl flex items-center justify-center mb-2 border border-[#B1AB86]/20">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                <path
                  d="M3 3V21H21M7 14L12 9L16 13L21 8"
                  stroke="#B1AB86"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </div>
            <span className="text-xs text-[#435446]/70 font-medium">Track Spending</span>
          </div>

          {/* Purchase Decisions */}
          <div className="flex flex-col items-center">
            <div className="w-12 h-12 bg-[#435446]/10 backdrop-blur-sm rounded-2xl flex items-center justify-center mb-2 border border-[#435446]/20">
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
            <span className="text-xs text-[#435446]/70 font-medium">Decide Wisely</span>
          </div>
        </div>

        {/* Get Started button */}
        <div className={`transition-all duration-700 ease-out delay-500 ${
          buttonVisible ? 'opacity-100 transform translate-y-0' : 'opacity-0 transform translate-y-6'
        }`}>
          <button
            onClick={onNext}
            className="group relative bg-[#819067] hover:bg-[#819067]/90 active:bg-[#819067]/80 text-[#FEFAE0] px-12 py-4 rounded-2xl font-semibold shadow-lg hover:shadow-xl transition-all duration-200 interactive-scale overflow-hidden"
            style={{
              boxShadow: '0 10px 25px -5px rgba(129, 144, 103, 0.3), 0 0 0 1px rgba(129, 144, 103, 0.1)'
            }}
          >
            {/* Button gradient overlay */}
            <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/5 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-1000"></div>
            
            <span className="relative flex items-center space-x-2">
              <span>Get Started</span>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" className="transition-transform group-hover:translate-x-0.5">
                <path d="M5 12H19M12 5L19 12L12 19" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            </span>
          </button>
        </div>

        {/* Subtle footer text */}
        <div className={`mt-8 transition-all duration-700 ease-out delay-700 ${
          buttonVisible ? 'opacity-100' : 'opacity-0'
        }`}>
          <p className="text-sm text-[#435446]/50 text-center">
            Your financial journey begins now
          </p>
        </div>
      </div>
    </div>
  );
}
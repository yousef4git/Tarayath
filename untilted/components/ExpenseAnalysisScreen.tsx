import React, { useState } from 'react';
import { Card } from './ui/card';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { UserData } from '../App';
import { saveExpenseAnalysis } from '../utils/localStorage';

// SF Symbols replacements
const ArrowLeftIcon = () => <span className="text-xl">←</span>;
const SendIcon = () => <span className="text-lg">↗</span>;

interface ExpenseAnalysisScreenProps {
  userData: UserData | null;
  onBack: () => void;
}

interface Message {
  id: string;
  text: string;
  isUser: boolean;
  timestamp: Date;
}

export function ExpenseAnalysisScreen({ userData, onBack }: ExpenseAnalysisScreenProps) {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: '1',
      text: "Hi! I'm your expense analysis assistant. I'll help you analyze your spending and find ways to save money. What category of expenses would you like to analyze? (e.g., groceries, dining out, transportation, entertainment, subscriptions)",
      isUser: false,
      timestamp: new Date()
    }
  ]);
  const [inputText, setInputText] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [currentStep, setCurrentStep] = useState<'category' | 'amount' | 'analysis'>('category');
  const [analysisData, setAnalysisData] = useState<{ category?: string; amount?: number }>({});

  const addMessage = (text: string, isUser: boolean = false) => {
    const newMessage: Message = {
      id: Date.now().toString(),
      text,
      isUser,
      timestamp: new Date()
    };
    setMessages(prev => [...prev, newMessage]);
  };

  const generateAnalysis = (category: string, amount: number): string => {
    const availableIncome = userData ? userData.monthlyIncome - userData.monthlyObligations : 0;
    const percentageOfIncome = availableIncome > 0 ? (amount / availableIncome) * 100 : 0;
    
    const suggestions: { [key: string]: string[] } = {
      groceries: [
        "🛒 Plan meals weekly and make a shopping list",
        "🏪 Shop at discount stores like Costco or Aldi",
        "🥫 Buy generic brands instead of name brands",
        "🍳 Cook more meals at home",
        "📱 Use apps like Ibotta or Honey for cashback"
      ],
      'dining out': [
        "🍳 Cook more meals at home - can save 60-70%",
        "🍽️ Look for restaurant deals and happy hour specials",
        "📱 Use apps like Groupon for restaurant discounts",
        "🥪 Pack lunch for work instead of buying",
        "☕ Make coffee at home instead of buying daily"
      ],
      transportation: [
        "🚗 Use public transportation when possible",
        "⛽ Use apps like GasBuddy to find cheaper gas",
        "🚶 Walk or bike for short distances",
        "🚘 Consider carpooling or ride-sharing",
        "🔧 Keep up with car maintenance to improve efficiency"
      ],
      entertainment: [
        "📺 Share streaming subscriptions with family",
        "🎬 Look for free events in your community",
        "📚 Use your local library for books and movies",
        "🏞️ Enjoy free outdoor activities like hiking",
        "🎫 Look for discounted tickets on apps like Groupon"
      ],
      subscriptions: [
        "📋 Cancel unused subscriptions immediately",
        "💰 Look for annual payment discounts",
        "👥 Share subscriptions with family/friends",
        "🆓 Use free alternatives when available",
        "📱 Set reminders to review subscriptions monthly"
      ]
    };

    const categoryKey = Object.keys(suggestions).find(key => 
      category.toLowerCase().includes(key) || key.includes(category.toLowerCase())
    ) || 'general';

    let analysis = `📊 **Expense Analysis for ${category}**\n\n`;
    analysis += `💰 Monthly spending: $${amount.toLocaleString()}\n`;
    analysis += `📈 This represents ${percentageOfIncome.toFixed(1)}% of your available income\n\n`;

    if (percentageOfIncome <= 10) {
      analysis += `✅ **Good news!** Your spending in this category is well within a healthy range.\n\n`;
    } else if (percentageOfIncome <= 20) {
      analysis += `⚠️ **Moderate spending** - There's room for optimization here.\n\n`;
    } else {
      analysis += `🚨 **High spending** - This category might benefit from significant changes.\n\n`;
    }

    analysis += `💡 **Money-saving suggestions:**\n`;
    const categorySuggestions = suggestions[categoryKey] || suggestions['general'] || [
      "Look for discounts and deals",
      "Compare prices before purchasing",
      "Consider if each purchase is necessary",
      "Set a monthly budget for this category"
    ];

    categorySuggestions.forEach(suggestion => {
      analysis += `• ${suggestion}\n`;
    });

    const potentialSavings = Math.round(amount * 0.2); // Assume 20% potential savings
    analysis += `\n💵 **Potential monthly savings: $${potentialSavings.toLocaleString()}**\n`;
    analysis += `📅 **Annual savings potential: $${(potentialSavings * 12).toLocaleString()}**`;

    // Save the analysis
    saveExpenseAnalysis({
      category,
      amount,
      suggestions: categorySuggestions,
      createdAt: new Date().toISOString()
    });

    return analysis;
  };

  const handleSendMessage = async () => {
    if (!inputText.trim()) return;

    const userMessage = inputText;
    addMessage(userMessage, true);
    setInputText('');
    setIsLoading(true);

    setTimeout(() => {
      let botResponse = '';

      if (currentStep === 'category') {
        setAnalysisData(prev => ({ ...prev, category: userMessage }));
        botResponse = `Great! Let's analyze your ${userMessage.toLowerCase()} expenses. How much do you typically spend on ${userMessage.toLowerCase()} per month?`;
        setCurrentStep('amount');
      } else if (currentStep === 'amount') {
        const amount = parseFloat(userMessage.replace(/[$,]/g, ''));
        if (!isNaN(amount) && amount > 0) {
          setAnalysisData(prev => ({ ...prev, amount }));
          botResponse = generateAnalysis(analysisData.category || '', amount);
          setCurrentStep('analysis');
          
          setTimeout(() => {
            addMessage("Would you like to analyze another category of expenses? Just let me know what category you'd like to look at next!", false);
            setCurrentStep('category');
            setAnalysisData({});
          }, 3000);
        } else {
          botResponse = "Please enter a valid amount in numbers (e.g., 300 or $300).";
        }
      } else {
        // Reset for new analysis
        setCurrentStep('category');
        setAnalysisData({});
        botResponse = "What category would you like to analyze next?";
      }

      addMessage(botResponse);
      setIsLoading(false);
    }, 1000);
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-orange-50 to-white flex flex-col">
      {/* Header */}
      <div className="flex items-center p-4 pt-12 bg-white border-b border-gray-200">
        <Button
          variant="ghost"
          size="sm"
          onClick={onBack}
          className="p-2 h-10 w-10 rounded-full mr-3"
        >
          <ArrowLeftIcon />
        </Button>
        <div>
          <h1 className="text-xl font-bold text-gray-900">Expense Analysis</h1>
          <p className="text-sm text-gray-600">Find ways to optimize your spending</p>
        </div>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {messages.map((message) => (
          <div
            key={message.id}
            className={`flex ${message.isUser ? 'justify-end' : 'justify-start'}`}
          >
            <div
              className={`max-w-[85%] p-3 rounded-2xl ${
                message.isUser
                  ? 'bg-orange-600 text-white'
                  : 'bg-white text-gray-900 border border-gray-200'
              }`}
            >
              <p className="whitespace-pre-line">{message.text}</p>
              <p className={`text-xs mt-1 ${
                message.isUser ? 'text-orange-100' : 'text-gray-500'
              }`}>
                {message.timestamp.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
              </p>
            </div>
          </div>
        ))}
        
        {isLoading && (
          <div className="flex justify-start">
            <div className="bg-white border border-gray-200 p-3 rounded-2xl">
              <div className="flex space-x-1">
                <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
                <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '0.1s' }}></div>
                <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '0.2s' }}></div>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Input Area */}
      <div className="p-4 bg-white border-t border-gray-200">
        <div className="flex space-x-2">
          <div className="flex-1">
            <Input
              value={inputText}
              onChange={(e) => setInputText(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder="Type your message..."
              className="w-full rounded-full border-gray-300 focus:border-orange-500 focus:ring-orange-500"
              disabled={isLoading}
            />
          </div>
          <Button
            onClick={handleSendMessage}
            disabled={!inputText.trim() || isLoading}
            className="w-12 h-12 rounded-full bg-orange-600 hover:bg-orange-700 disabled:opacity-50 flex items-center justify-center"
          >
            <SendIcon />
          </Button>
        </div>
      </div>
    </div>
  );
}
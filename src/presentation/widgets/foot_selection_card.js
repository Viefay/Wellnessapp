const FOOT_IMAGES = {
  left:  'https://lh3.googleusercontent.com/aida-public/AB6AXuATB0Bd_nyzRszKD-Yk6oUc7knHA3xlnyeRiNP4jS_sIBmnPTvfsAJGFkj_-4iyB7WEU8A7kQ4K5gnjWWxcfeCbZ25SplDocKAMZY7HFc6OTCeRqGK2a_pVwXVNxKQTM32oSFFxvvi9O-5mI14dX_OFvH8P9mAyoQXaxocTMcNkBH4albwyKI9T1nAzUYLBjxaoYPXzPuAwP1ocuC2YEdi_O2B7v1mo2-qh5X8MhWJobiq5du7gcNUwDd0ArylVbgwzV2G5kwK6C0U',
  right: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAhVYcVvtQ97flt-wNeMOJurt1_OHtc5ZtSZH1T3W1OfhNJtmcGjBHA3-fZKE0-VTc2ksNdJDILXWpWHZQbAyvmEJopygbviBphwuAJjr-w9WmG3TqYWm6boh4Vck1bIXuvMAtXC1YBtRk4bjt1S-Tur1GU4Q-jcZUgDkRWu3M_fFwMnRYK1LvlMAzrkmqXRGA8E5TA-l3N42iWWLQ3sR4Yw_A55Cg3c8w4RWS_QwQlYZALibFHp_ZYCSBtJY6BtHBW_ALnjN9FYqw',
};

export function footSelectionCard({ foot, selected, description }) {
  const label = foot === 'right' ? 'Right Foot' : 'Left Foot';
  const isSelected = selected === foot;

  return `
    <button
      data-foot="${foot}"
      class="group relative flex flex-col items-center p-lg rounded-lg border-2 shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] transition-all duration-300 active:scale-[0.98] text-left w-full
        ${isSelected
          ? 'bg-primary-container/10 border-primary shadow-[0_8px_24px_0_rgba(46,196,182,0.15)]'
          : 'bg-surface-container-lowest border-transparent hover:border-outline-variant'}"
    >
      <div class="w-full h-40 mb-md rounded-md overflow-hidden ${isSelected ? 'bg-white/50' : 'bg-surface-container-low'}">
        <img src="${FOOT_IMAGES[foot]}" alt="${label} illustration" class="w-full h-full object-contain p-md">
      </div>
      <div class="w-full">
        <h3 class="font-headline-sm text-headline-sm mb-xs ${isSelected ? 'text-primary' : 'text-on-surface'}">${label}</h3>
        <p class="font-label-md text-label-md ${isSelected ? 'text-on-primary-container/80' : 'text-on-surface-variant'}">${description}</p>
      </div>
      <div class="absolute top-4 right-4 w-6 h-6 rounded-full border-2 flex items-center justify-center
        ${isSelected ? 'border-primary bg-primary' : 'border-outline-variant'}">
        ${isSelected ? '<span class="material-symbols-outlined text-white text-[16px]" style="font-variation-settings: \'wght\' 700">check</span>' : '<div class="w-3 h-3 rounded-full bg-transparent"></div>'}
      </div>
    </button>
  `;
}

const SEVERITY_BADGE = {
  Moderate: 'bg-tertiary-container/20 text-on-tertiary-container',
  Mild:     'bg-primary-container/20 text-on-primary-container',
  Severe:   'bg-error-container/20 text-on-error-container',
};

export function sessionHistoryCard({ id, date, classification, severity, fmaLeScore, symmetry, opacity = '' }) {
  const badgeCls = SEVERITY_BADGE[severity] || 'bg-surface-container text-on-surface-variant';
  return `
    <div class="bg-surface-container-lowest p-md rounded-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] flex flex-col gap-md border border-outline-variant/10 ${opacity}">
      <div class="flex justify-between items-start">
        <div class="flex flex-col">
          <span class="font-headline-sm text-headline-sm text-on-surface">Gait Test - ${date}</span>
          <span class="font-label-sm text-label-sm text-on-surface-variant">Classification: ${classification}</span>
        </div>
        <span class="px-3 py-1 rounded-full font-label-sm ${badgeCls}">${severity}</span>
      </div>
      <div class="grid grid-cols-2 gap-md bg-surface-container-low p-sm rounded-md">
        <div class="flex flex-col">
          <span class="font-label-sm text-on-surface-variant">FMA-LE Score</span>
          <span class="font-display-lg text-display-lg text-primary">${fmaLeScore}</span>
        </div>
        <div class="flex flex-col">
          <span class="font-label-sm text-on-surface-variant">Symmetry</span>
          <span class="font-display-lg text-display-lg text-secondary">${symmetry}%</span>
        </div>
      </div>
      <button data-session-id="${id}" class="w-full py-3 bg-primary text-on-primary rounded-full font-label-md hover:opacity-90 active:scale-[0.98] transition-all">
        View Details
      </button>
    </div>
  `;
}

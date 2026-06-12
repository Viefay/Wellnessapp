export function instructionCard({ icon, title, description }) {
  return `
    <div class="bg-surface-container-lowest custom-shadow rounded-lg p-lg flex gap-md border border-transparent transition-all active:scale-[0.98]">
      <div class="w-12 h-12 rounded-full bg-primary-container/20 flex items-center justify-center shrink-0">
        <span class="material-symbols-outlined text-primary" style="font-variation-settings: 'wght' 600;">${icon}</span>
      </div>
      <div class="flex-grow">
        <h3 class="font-headline-sm text-headline-sm text-on-surface mb-xs">${title}</h3>
        <p class="font-body-md text-body-md text-on-surface-variant">${description}</p>
      </div>
      <div class="shrink-0 flex items-start pt-1">
        <div class="w-6 h-6 rounded-sm border-2 border-outline-variant flex items-center justify-center">
          <span class="material-symbols-outlined text-primary text-sm font-bold opacity-0">check</span>
        </div>
      </div>
    </div>
  `;
}

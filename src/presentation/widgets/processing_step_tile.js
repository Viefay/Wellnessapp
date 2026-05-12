/** status: 'pending' | 'active' | 'completed' */
export function processingStepTile({ id, label, status }) {
  const iconEl = {
    pending: `
      <div class="w-7 h-7 rounded-full bg-surface-container flex items-center justify-center border border-outline-variant">
        <div class="w-1.5 h-1.5 bg-outline-variant rounded-full"></div>
      </div>`,
    active: `
      <div class="w-7 h-7 rounded-full bg-primary-container flex items-center justify-center border-2 border-primary animate-pulse">
        <div class="w-2 h-2 bg-primary rounded-full"></div>
      </div>`,
    completed: `
      <div class="w-7 h-7 rounded-full bg-primary flex items-center justify-center">
        <span class="material-symbols-outlined text-white text-[18px]" style="font-variation-settings: 'wght' 700;">check</span>
      </div>`,
  }[status] || '';

  const textEl = {
    pending: `
      <span class="font-label-md text-label-md text-on-surface-variant">${label}</span>
      <span class="font-label-sm text-label-sm text-on-surface-variant/60">Waiting</span>`,
    active: `
      <span class="font-label-md text-label-md text-primary font-bold">${label}</span>
      <span class="font-label-sm text-label-sm text-on-surface-variant">Processing...</span>`,
    completed: `
      <span class="font-label-md text-label-md text-on-surface">${label}</span>
      <span class="font-label-sm text-label-sm text-primary">Completed</span>`,
  }[status] || '';

  return `
    <div id="step-${id}" class="flex items-start gap-md relative z-10">
      ${iconEl}
      <div class="flex flex-col">${textEl}</div>
    </div>
  `;
}

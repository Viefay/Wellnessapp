export function resultMetricCard({ title, value, subtitle, icon, color = 'text-primary' }) {
  return `
    <div class="bg-surface-container-lowest rounded-lg p-md shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] border border-outline-variant/10">
      <div class="flex items-center gap-sm mb-xs">
        <span class="material-symbols-outlined ${color}">${icon}</span>
        <span class="font-label-sm text-on-surface-variant">${title}</span>
      </div>
      <p class="font-headline-md text-headline-md ${color}">${value}</p>
      ${subtitle ? `<p class="font-label-sm text-on-surface-variant mt-xs">${subtitle}</p>` : ''}
    </div>
  `;
}

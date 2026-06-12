export function sensorStatusCard({ title, icon, status, isActive }) {
  return `
    <div class="bg-surface-container-lowest p-md rounded-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] border border-outline-variant/10">
      <div class="flex items-center gap-base mb-xs ${isActive ? 'text-primary' : 'text-on-surface-variant'}">
        <span class="material-symbols-outlined text-[20px]">${icon}</span>
        <span class="font-label-sm uppercase tracking-wider text-on-surface-variant">${title}</span>
      </div>
      <p class="font-headline-sm ${isActive ? 'text-primary' : 'text-on-surface-variant'}">${status}</p>
    </div>
  `;
}

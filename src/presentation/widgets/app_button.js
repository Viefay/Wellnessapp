/**
 * AppButton — reusable button variants.
 * variant: 'primary' | 'secondary' | 'danger'
 */
export function appButton({ label, id = '', variant = 'primary', loading = false, icon = '', extraClass = '' }) {
  const base = 'w-full py-md px-lg rounded-full font-label-md flex items-center justify-center gap-sm transition-all duration-200 active:scale-95 disabled:opacity-60';

  const variants = {
    primary:   'bg-primary text-on-primary shadow-md hover:opacity-90',
    secondary: 'bg-secondary-container text-on-secondary-container hover:opacity-90',
    danger:    'bg-error text-on-error shadow-md hover:opacity-90',
  };

  const cls = `${base} ${variants[variant] || variants.primary} ${extraClass}`;
  const btnId = id ? `id="${id}"` : '';

  return `
    <button ${btnId} class="${cls}" ${loading ? 'disabled' : ''}>
      ${loading
        ? '<span class="material-symbols-outlined animate-spin">autorenew</span>'
        : (icon ? `<span class="material-symbols-outlined">${icon}</span>` : '')}
      ${label}
    </button>
  `;
}

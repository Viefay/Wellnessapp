/** AppCard — white card with rounded corners and soft shadow */
export function appCard({ content, extraClass = '' }) {
  return `
    <div class="bg-surface-container-lowest rounded-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] p-lg border border-outline-variant/10 ${extraClass}">
      ${content}
    </div>
  `;
}

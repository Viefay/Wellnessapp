const TABS = [
  { id: 'home',    icon: 'home',               label: 'Home',    route: '/home'      },
  { id: 'record',  icon: 'fiber_manual_record', label: 'Record',  route: '/recording' },
  { id: 'history', icon: 'history',             label: 'History', route: '/history'   },
  { id: 'profile', icon: 'person',              label: 'Profile', route: '/profile'   },
];

export function bottomNavShell(activePage) {
  return `
    <nav class="fixed bottom-0 left-0 w-full z-50 glass-nav bg-surface/90 backdrop-blur-md border-t border-outline-variant/30 shadow-[0_-4px_20px_0_rgba(29,53,87,0.06)] rounded-t-lg">
      <div class="flex justify-around items-center pt-2 pb-6 px-4">
        ${TABS.map(tab => {
          const isActive = tab.id === activePage;
          return `
            <button data-nav-to="${tab.route}" class="flex flex-col items-center justify-center ${isActive ? 'bg-secondary-container text-on-secondary-container rounded-2xl px-4 py-1' : 'text-on-surface-variant hover:bg-surface-variant/50 px-4 py-1'} transition-transform duration-300 active:scale-90">
              <span class="material-symbols-outlined" ${isActive ? "style=\"font-variation-settings: 'FILL' 1;\"" : ''}>${tab.icon}</span>
              <span class="font-label-sm text-label-sm">${tab.label}</span>
            </button>
          `;
        }).join('')}
      </div>
    </nav>
  `;
}

export function mountBottomNav(navigate) {
  document.querySelectorAll('[data-nav-to]').forEach(el => {
    el.addEventListener('click', () => navigate(el.dataset.navTo));
  });
}

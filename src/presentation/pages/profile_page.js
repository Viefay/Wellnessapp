import { bottomNavShell, mountBottomNav } from '../widgets/bottom_nav_shell.js';

const PROFILE_IMG_HEADER = 'https://lh3.googleusercontent.com/aida-public/AB6AXuDB5NZ3QDWklcp5K9SVR9BygMbFDJyYWdHdXZEz-U9jaqMSq9pHmjdEhJqp-Mf2Geg-iIn_HNp04QQkjJk5oGSsNEloOy2IJVmfLP28z8TDeck2-8ANWejG9hEWRfN3X5i1QpLY5p8GNZIi4cdQ6zbwpCjCgypUfZlRxltaf7S6ZPmrd0UpEjFgA2wCyt6I04JswDowStnq3Aj4fJBQUQLIQGku-CxNkzHin44eQfZZ95oRztYBVYtdZVDAr5DWekV7XyqTKk-Ij8Y';
const PROFILE_IMG_CARD  = 'https://lh3.googleusercontent.com/aida-public/AB6AXuD3Np6ExRDlxEBlexQO9TFLQ-X1YdGe8pQXQ7coHPupzrqfqk87Ip1nNddFvy7XrlX8eOtFGGC4DmWu6d6Z9f7ebAZ6lJ0xla3x27cK31TEgsxq99zKSwnlcxtY1xEL-SsxHOuse8888Dy8W674rl2B16_zXV6ogrOXa9-D_9xBXMexIAswD48Gf-W0qqH4SfyGjs5NW10RfKzLhdklpmbDfhyTXFT2FGQhdjSCyAji002tK-blde_bfgvBd26VAKETFdQ9BpYhy8g';

const SETTINGS = [
  { icon: 'tune',        label: 'Sensor Calibration',      sub: '' },
  { icon: 'lock',        label: 'Data Privacy',            sub: '' },
  { icon: 'file_export', label: 'Export Data',             sub: '' },
  { icon: 'cloud_sync',  label: 'Backend Connection Status', sub: 'Connected' },
  { icon: 'info',        label: 'About App',               sub: '' },
];

export function render() {
  return `
    <div class="min-h-screen text-on-surface" style="background-color:#f4fbf8;">
      <!-- Top App Bar -->
      <header class="bg-surface/80 backdrop-blur-md sticky top-0 z-50 w-full h-16 flex justify-between items-center px-margin-mobile shadow-sm">
        <div class="flex items-center gap-3">
          <div class="w-10 h-10 rounded-full overflow-hidden border-2 border-primary/20">
            <img src="${PROFILE_IMG_HEADER}" alt="User Profile photo" class="w-full h-full object-cover">
          </div>
          <h1 class="font-headline-sm text-headline-sm text-primary">Gait Analysis</h1>
        </div>
        <button class="text-primary hover:opacity-80 transition-all duration-200 active:scale-95">
          <span class="material-symbols-outlined">sensors</span>
        </button>
      </header>

      <main class="px-margin-mobile pt-lg pb-xl max-w-2xl mx-auto space-y-xl">
        <!-- Profile Card -->
        <section class="bg-surface-container-lowest rounded-lg p-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] flex flex-col items-center text-center">
          <div class="relative mb-md">
            <div class="w-24 h-24 rounded-full bg-primary-container/20 flex items-center justify-center border-4 border-white shadow-sm overflow-hidden">
              <img src="${PROFILE_IMG_CARD}" alt="User profile photo" class="w-full h-full object-cover">
            </div>
            <div class="absolute bottom-0 right-0 bg-primary p-1.5 rounded-full border-2 border-white text-white">
              <span class="material-symbols-outlined text-[16px]" style="font-variation-settings: 'FILL' 1;">edit</span>
            </div>
          </div>
          <h2 class="font-headline-md text-headline-md text-on-surface">User Profile</h2>
          <div class="flex items-center gap-2 mt-1">
            <span class="font-label-md text-label-md text-on-surface-variant">John Doe, 34</span>
            <span class="w-1.5 h-1.5 rounded-full bg-outline-variant"></span>
            <span class="font-label-md text-label-md text-primary">Pro Athlete</span>
          </div>
        </section>

        <!-- Settings List -->
        <section class="space-y-md">
          <h3 class="font-label-sm text-label-sm text-on-surface-variant px-2 uppercase tracking-widest">System Settings</h3>
          <div class="bg-surface-container-lowest rounded-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] overflow-hidden">
            ${SETTINGS.map((s, i) => `
              ${i > 0 ? '<div class="mx-md border-t border-outline-variant/20"></div>' : ''}
              <button class="w-full flex items-center justify-between p-md hover:bg-surface-variant/30 transition-all active:scale-[0.98]">
                <div class="flex items-center gap-md">
                  <div class="w-10 h-10 rounded-full bg-primary-container/10 flex items-center justify-center text-primary">
                    <span class="material-symbols-outlined">${s.icon}</span>
                  </div>
                  <div class="text-left">
                    <p class="font-body-md text-body-md text-on-surface">${s.label}</p>
                    ${s.sub ? `<p class="font-label-sm text-label-sm text-primary">${s.sub}</p>` : ''}
                  </div>
                </div>
                <span class="material-symbols-outlined text-outline-variant">chevron_right</span>
              </button>
            `).join('')}
          </div>
        </section>

        <!-- App Branding -->
        <section class="flex flex-col items-center justify-center space-y-xs opacity-60 pb-xl">
          <p class="font-label-sm text-label-sm text-on-surface-variant">Wellness App v1.0</p>
          <p class="font-label-sm text-label-sm text-outline">Engineered for Human Potential</p>
        </section>
      </main>

      ${bottomNavShell('profile')}
      <div class="h-24"></div>
    </div>
  `;
}

export function mount(navigate) {
  mountBottomNav(navigate);
}

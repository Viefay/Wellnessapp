import { bottomNavShell, mountBottomNav } from '../widgets/bottom_nav_shell.js';
import { sessionHistoryCard } from '../widgets/session_history_card.js';
import { getSessions } from '../../data/services/local_storage_service.js';

const PROFILE_IMG = 'https://lh3.googleusercontent.com/aida-public/AB6AXuCcdfnt_vKGsRGvDzR419WfVXmPUwtdxPfw0Fv-PDysLgYqczcG4alftN12w443rd55i9Hpx322ScAWc5wJATstoldQ_JixhAQEf_m_2zcnG923Uq6KZFpwxXS0Xdnm1p_mL-oUPR765d29nx6fSSW77nR7CIPLVbO6CcbNL9yIvnHkQ6skxpR9XL6kFXB0ymdVK6UCCfZ--Q_IWChmrGXj1Bpe09PIaekz2eatvf8gbPURCwWkDDhnSDvNt5AYHF_rAOEk1YxU-L8';

export function render() {
  const sessions = getSessions();
  return `
    <div class="bg-background text-on-surface min-h-screen pb-24">
      <!-- Top App Bar -->
      <header class="bg-surface/80 dark:bg-surface-dim/80 backdrop-blur-md shadow-sm fixed top-0 w-full z-40 h-16 flex justify-between items-center px-margin-mobile">
        <div class="flex items-center gap-3">
          <div class="w-8 h-8 rounded-full overflow-hidden bg-surface-container-highest">
            <img src="${PROFILE_IMG}" class="w-full h-full object-cover" alt="Profile">
          </div>
          <h1 class="font-headline-sm text-headline-sm text-primary">Test History</h1>
        </div>
        <button class="text-primary hover:opacity-80 transition-all duration-200 active:scale-95">
          <span class="material-symbols-outlined">sensors</span>
        </button>
      </header>

      <main class="mt-20 px-margin-mobile">
        <!-- Search & Filter -->
        <div class="flex flex-col gap-md mb-xl">
          <div class="relative">
            <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-outline">search</span>
            <input
              type="text"
              placeholder="Search sessions..."
              class="w-full pl-12 pr-4 py-3 bg-surface-container-lowest border border-outline-variant/30 rounded-xl font-body-md focus:outline-none focus:ring-2 focus:ring-primary-container transition-all"
            >
          </div>
          <div class="flex gap-sm">
            <button class="flex-1 flex items-center justify-center gap-2 py-2 px-4 bg-surface-container-high rounded-full font-label-md text-on-surface-variant hover:bg-surface-variant transition-colors">
              <span class="material-symbols-outlined text-[20px]">calendar_today</span> Date
            </button>
            <button class="flex-1 flex items-center justify-center gap-2 py-2 px-4 bg-surface-container-high rounded-full font-label-md text-on-surface-variant hover:bg-surface-variant transition-colors">
              <span class="material-symbols-outlined text-[20px]">tune</span> Severity
            </button>
          </div>
        </div>

        <!-- Session List -->
        <div class="flex flex-col gap-lg">
          ${sessions.map((s, i) => sessionHistoryCard({ ...s, opacity: i === 2 ? 'opacity-70' : '' })).join('')}

          <!-- Start New CTA -->
          <div class="flex flex-col items-center justify-center py-xl gap-md text-center">
            <div class="w-16 h-16 bg-surface-container-high rounded-full flex items-center justify-center text-outline">
              <span class="material-symbols-outlined text-[32px]">history</span>
            </div>
            <div>
              <h3 class="font-headline-sm text-on-surface">Need more data?</h3>
              <p class="font-body-md text-on-surface-variant px-lg">Keep track of your recovery progress with frequent movement assessments.</p>
            </div>
            <button id="new-test-btn" class="px-xl py-3 bg-secondary text-on-secondary rounded-full font-label-md shadow-lg shadow-secondary/20 hover:scale-105 active:scale-95 transition-all">
              Start New Test
            </button>
          </div>
        </div>
      </main>

      ${bottomNavShell('history')}
    </div>
  `;
}

export function mount(navigate) {
  mountBottomNav(navigate);
  document.getElementById('new-test-btn')?.addEventListener('click', () => navigate('/instruction'));
  document.querySelectorAll('[data-session-id]').forEach(btn => {
    btn.addEventListener('click', () => navigate('/result'));
  });
}

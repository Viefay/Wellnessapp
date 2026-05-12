import { bottomNavShell, mountBottomNav } from '../widgets/bottom_nav_shell.js';

const PROFILE_IMG = 'https://lh3.googleusercontent.com/aida-public/AB6AXuC4YzJzQwQncoyk4L9gJ_ZPPf_AzvNnnkU_o87onjrRsI8ejdwOptD7roe6wRy506s2AhU87sAETjiZw3I7NiLIRH_p9Dj4qHVNQeHXrJkitwcVmPLCBbjt1rfdlvfvC9GW6x4rrS5O-kFzPq3C4tLmwJ9aFkDn67lxlhqRjqw_SnYYYgIylDW5s5tDGI6h0xoJ12dpAqO8wuezx8FO4oFDp_yHIA62C1JNvGJUh8AeJxeFHrqWl5qQjyPfHKpfZGAfWYEblJXITOo';

export function render() {
  return `
    <div class="min-h-screen pb-32">
      <!-- Top App Bar -->
      <header class="bg-surface/80 dark:bg-surface-dim/80 sticky top-0 backdrop-blur-md shadow-sm z-40 transition-all duration-200">
        <div class="flex justify-between items-center px-margin-mobile h-16 w-full">
          <div class="flex items-center gap-md">
            <img src="${PROFILE_IMG}" alt="User Profile" class="w-10 h-10 rounded-full object-cover border-2 border-primary-container">
            <h1 class="font-headline-sm text-headline-sm text-primary">Gait Analysis</h1>
          </div>
          <button class="text-primary hover:opacity-80 active:scale-95 transition-all">
            <span class="material-symbols-outlined">sensors</span>
          </button>
        </div>
      </header>

      <main class="px-margin-mobile pt-lg space-y-xl">
        <!-- Greeting -->
        <section class="space-y-xs">
          <p class="font-body-md text-on-surface-variant">Hello, welcome back.</p>
          <h2 class="font-headline-md text-headline-md text-on-surface">Ready for your gait assessment?</h2>
        </section>

        <!-- Hero Card -->
        <section class="relative overflow-hidden bg-teal-gradient rounded-lg shadow-lg p-lg text-white">
          <div class="relative z-10 w-2/3 space-y-md">
            <h3 class="font-headline-sm text-headline-sm">Start a new gait test</h3>
            <p class="font-body-md opacity-90">Record your walking data using your phone sensors.</p>
            <button id="start-test-btn" class="bg-on-surface text-surface py-md px-lg rounded-full font-label-md hover:opacity-90 active:scale-95 transition-all">
              Start Test
            </button>
          </div>
          <div class="absolute top-0 right-0 h-full w-1/3 flex items-center justify-center opacity-40">
            <span class="material-symbols-outlined !text-[120px]" style="font-variation-settings: 'wght' 200;">directions_walk</span>
          </div>
        </section>

        <!-- Stats Bento Grid -->
        <section class="grid grid-cols-2 gap-md">
          <!-- FMA-LE Score -->
          <div class="col-span-2 bg-surface-container-lowest p-lg rounded-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] border border-outline-variant/20">
            <div class="flex justify-between items-start mb-md">
              <span class="font-label-sm text-on-surface-variant uppercase tracking-wider">Latest Score</span>
              <span class="px-sm py-1 bg-primary-container/20 text-on-primary-container text-xs rounded-full font-bold">Moderate</span>
            </div>
            <div class="flex items-end gap-base">
              <span class="font-display-lg text-display-lg text-primary">24</span>
              <span class="font-body-md text-on-surface-variant mb-1">FMA-LE</span>
            </div>
            <p class="mt-md font-body-md text-on-surface-variant text-sm">Improvement of +2 pts from last week.</p>
          </div>

          <!-- Classification -->
          <div class="bg-surface-container-lowest p-md rounded-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] border border-outline-variant/20 flex flex-col justify-between aspect-square">
            <div>
              <span class="material-symbols-outlined text-secondary" style="font-variation-settings: 'FILL' 1;">analytics</span>
              <h4 class="font-label-sm text-on-surface-variant mt-sm">Last Classification</h4>
            </div>
            <div>
              <p class="font-headline-sm text-on-surface">CVA</p>
              <p class="font-label-sm text-primary">91% confidence</p>
            </div>
          </div>

          <!-- Sessions -->
          <div class="bg-surface-container-lowest p-md rounded-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] border border-outline-variant/20 flex flex-col justify-between aspect-square">
            <div>
              <span class="material-symbols-outlined text-secondary" style="font-variation-settings: 'FILL' 1;">calendar_today</span>
              <h4 class="font-label-sm text-on-surface-variant mt-sm">Total Sessions</h4>
            </div>
            <div class="flex items-baseline gap-xs">
              <p class="font-display-lg text-display-lg text-on-surface">12</p>
              <p class="font-label-sm text-on-surface-variant">tests</p>
            </div>
          </div>
        </section>

        <!-- Recent Activity -->
        <section class="flex justify-between items-center">
          <h3 class="font-headline-sm text-headline-sm text-on-surface">Activity History</h3>
          <button data-nav-to="/history" class="text-primary font-label-md">View All</button>
        </section>

        <div class="space-y-md">
          <div class="bg-surface-container-lowest p-md rounded-lg flex items-center gap-md border border-outline-variant/10">
            <div class="w-12 h-12 bg-surface-container-highest rounded-2xl flex items-center justify-center text-primary">
              <span class="material-symbols-outlined">directions_walk</span>
            </div>
            <div class="flex-1">
              <p class="font-label-md text-on-surface">Gait Test #012</p>
              <p class="font-label-sm text-on-surface-variant">Yesterday, 4:30 PM</p>
            </div>
            <div class="text-right">
              <p class="font-data-viz text-primary">88%</p>
              <p class="font-label-sm text-on-surface-variant text-[10px]">SYMMETRY</p>
            </div>
          </div>
        </div>
      </main>

      ${bottomNavShell('home')}
    </div>
  `;
}

export function mount(navigate) {
  mountBottomNav(navigate);
  document.getElementById('start-test-btn')?.addEventListener('click', () => navigate('/instruction'));
}

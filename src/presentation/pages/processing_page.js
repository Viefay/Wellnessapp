import { bottomNavShell, mountBottomNav } from '../widgets/bottom_nav_shell.js';
import { processingStepTile } from '../widgets/processing_step_tile.js';

const STEPS = [
  { id: 1, label: 'Validating sensor data' },
  { id: 2, label: 'Calculating FreeAcc' },
  { id: 3, label: 'Detecting gait events' },
  { id: 4, label: 'Calculating semiogram' },
  { id: 5, label: 'Predicting FMA-LE' },
  { id: 6, label: 'Saving result' },
];

const STEP_DURATION_MS = 1200;

let _timers = [];

const PROFILE_IMG = 'https://lh3.googleusercontent.com/aida-public/AB6AXuCl8V4EMSiz6Thf6H7WehwuLc1j3OGBJipEKTCeBPMwc1ytiZusOmgAxUkgTvcy0wm01qq7FYIR8Pc3rNWhGThjsXuMMVsMfaUAtRSqa7e9EQpIfdXuFn62o3VgyMlaXe_1CksuuY1uTnnRW6FL63zduph3YUXjdVI2HshdG5K0XDsH9hVTl-5voAUDSAxc6BJHSS7u-xIee8BDMsqSGOFK37VpCOM7Uw7T9zRoT9BG5MuE5Oh2anK9qz7p7wYkElL_gpwrm8SIiaA';

const WAVE_BARS = [20, 35, 50, 40, 25, 45, 30].map((h, i) =>
  `<div class="wave-bar" style="height:${h}px;animation-delay:${i * 0.17}s;"></div>`
).join('');

export function render() {
  return `
    <div class="min-h-screen flex flex-col font-body-md text-on-surface" style="background-color:#f4fbf8;">
      <!-- Top App Bar -->
      <header class="bg-surface/80 backdrop-blur-md shadow-sm fixed top-0 w-full z-50 flex justify-between items-center px-margin-mobile h-16 transition-all duration-200">
        <div class="flex items-center gap-md">
          <div class="w-10 h-10 rounded-full bg-surface-container-highest overflow-hidden border border-outline-variant/30">
            <img src="${PROFILE_IMG}" alt="User" class="w-full h-full object-cover">
          </div>
          <h1 class="font-headline-sm text-headline-sm text-primary">Gait Analysis</h1>
        </div>
        <div class="flex items-center">
          <span class="material-symbols-outlined text-primary text-2xl">sensors</span>
        </div>
      </header>

      <main class="flex-grow pt-24 pb-32 px-margin-mobile max-w-md mx-auto w-full">
        <!-- Hero -->
        <section class="flex flex-col items-center text-center mb-xl">
          <div class="w-48 h-48 bg-surface-container-lowest rounded-full shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] flex items-center justify-center mb-lg relative overflow-hidden">
            <div class="wave-container">${WAVE_BARS}</div>
            <div class="absolute inset-0 flex items-center justify-center pointer-events-none opacity-10">
              <span class="material-symbols-outlined text-8xl text-primary">insights</span>
            </div>
          </div>
          <h2 class="font-headline-md text-headline-md text-on-surface mb-sm">Processing Your Gait Data</h2>
          <p class="font-body-md text-on-surface-variant max-w-[280px]">Please wait while we analyze your walking pattern.</p>
        </section>

        <!-- Processing Stepper -->
        <div class="bg-surface-container-lowest rounded-lg p-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] border border-outline-variant/10">
          <div class="flex flex-col gap-lg relative">
            <div class="absolute left-3.5 top-2 bottom-2 w-0.5 bg-outline-variant/30"></div>
            ${STEPS.map(s => processingStepTile({ id: s.id, label: s.label, status: 'pending' })).join('')}
          </div>
        </div>

        <!-- Tip -->
        <div class="mt-xl text-center">
          <div class="inline-flex items-center gap-xs px-md py-sm bg-secondary-container/20 rounded-full">
            <span class="material-symbols-outlined text-secondary text-sm">lightbulb</span>
            <span class="font-label-sm text-label-sm text-on-secondary-container">Tip: Keep your phone steady for better accuracy</span>
          </div>
        </div>
      </main>

      ${bottomNavShell('record')}
    </div>
  `;
}

export function mount(navigate) {
  _timers = [];
  mountBottomNav(navigate);

  STEPS.forEach((step, i) => {
    _timers.push(setTimeout(() => setStepStatus(step, 'active'),    i * STEP_DURATION_MS));
    _timers.push(setTimeout(() => setStepStatus(step, 'completed'), i * STEP_DURATION_MS + STEP_DURATION_MS * 0.6));
  });

  _timers.push(setTimeout(() => navigate('/result'), STEPS.length * STEP_DURATION_MS + 600));
}

export function unmount() {
  _timers.forEach(clearTimeout);
  _timers = [];
}

function setStepStatus(step, status) {
  const el = document.getElementById(`step-${step.id}`);
  if (!el) return;
  el.outerHTML = processingStepTile({ id: step.id, label: step.label, status });
}

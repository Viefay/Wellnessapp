import { bottomNavShell, mountBottomNav } from '../widgets/bottom_nav_shell.js';
import { semiogramRadarSmall } from '../widgets/semiogram_chart.js';
import { sessionState } from '../state/session_state.js';

const PROFILE_IMG = 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbM9QYN03AkFLUeD596hhW_iV9PEe2ywuDLFZ5hYa9SpE_lXNHVv7e-pI8avoOEFTNwbALsmkyyujy7d6CUHAZ9oEbHyYd_m7cvXQ8If7KYnBYbIUbAFAXHfbjW9iuasf_Xgy7cnCUQvbQdym3nky_qLIdyBoT7uAUcF33fvGiKcaBzLhuBJtRxEaM1NT04FZ4gKAYuanNAn6TYK36ytRIZQnLllPUHZo54WzN6DnKRdr5IdaMgvWo7wT-vEwqZOLnj7VLK1xziqg';

export function render() {
  const r = sessionState.currentResult;
  const confidencePct = Math.round(r.confidence * 100);
  const hsWidth = Math.round((r.heelStrikeCount / 43) * 100);
  const toWidth = Math.round((r.toeOffCount / 43) * 100);

  return `
    <div class="bg-background text-on-surface font-body-md min-h-screen pb-32">
      <!-- Top App Bar -->
      <header class="bg-surface/80 backdrop-blur-md shadow-sm sticky top-0 z-50 flex justify-between items-center px-margin-mobile h-16 w-full">
        <div class="flex items-center gap-md">
          <div class="w-10 h-10 rounded-full bg-surface-container-highest overflow-hidden border-2 border-primary-container">
            <img src="${PROFILE_IMG}" alt="Profile" class="w-full h-full object-cover">
          </div>
          <h1 class="font-headline-sm text-headline-sm text-primary">Gait Analysis</h1>
        </div>
        <div class="flex items-center gap-md">
          <button class="material-symbols-outlined text-primary transition-all duration-200 active:scale-95">sensors</button>
        </div>
      </header>

      <main class="px-margin-mobile pt-xl space-y-xl max-w-2xl mx-auto">
        <!-- Success Header -->
        <div class="text-center">
          <div class="inline-flex items-center justify-center w-12 h-12 rounded-full bg-primary-container text-on-primary-container mb-sm">
            <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">check_circle</span>
          </div>
          <h2 class="font-headline-md text-headline-md text-on-surface">Gait Analysis Result</h2>
          <p class="font-body-md text-on-surface-variant">Session completed successfully</p>
        </div>

        <!-- Score + Cards Bento Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-md">
          <!-- Primary Score -->
          <div class="md:col-span-2 bg-surface-container-lowest rounded-lg p-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] flex flex-col items-center justify-center relative overflow-hidden">
            <div class="absolute top-0 right-0 p-md">
              <span class="bg-tertiary-container text-on-tertiary-container px-sm py-1 rounded-full text-label-sm font-label-md">${r.severity}</span>
            </div>
            <div class="text-center space-y-xs">
              <p class="font-label-md text-on-surface-variant uppercase tracking-wider">Overall Assessment</p>
              <div class="flex items-baseline justify-center gap-xs">
                <span class="font-display-lg text-[64px] text-primary">${r.fmaLeScore}</span>
                <span class="font-headline-sm text-on-surface-variant">/ 34</span>
              </div>
              <p class="font-headline-sm text-on-surface">FMA-LE Score</p>
              <div class="flex items-center justify-center gap-xs text-primary-container font-label-md">
                <span class="material-symbols-outlined text-[18px]" style="font-variation-settings: 'FILL' 1;">verified</span>
                <span>${confidencePct}% confidence</span>
              </div>
            </div>
          </div>

          <!-- Classification -->
          <div class="bg-surface-container-lowest rounded-lg p-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] border-l-4 border-primary">
            <div class="flex items-center gap-sm mb-base">
              <span class="material-symbols-outlined text-primary">clinical_notes</span>
              <h3 class="font-label-md text-on-surface-variant">Classification</h3>
            </div>
            <p class="font-display-lg text-primary">${r.classification}</p>
            <p class="font-body-md text-on-surface-variant mt-xs">Cerebrovascular Accident pattern detected in gait cycle.</p>
          </div>

          <!-- Gait Events -->
          <div class="bg-surface-container-lowest rounded-lg p-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)]">
            <div class="flex items-center gap-sm mb-base">
              <span class="material-symbols-outlined text-primary">timeline</span>
              <h3 class="font-label-md text-on-surface-variant">Gait Events</h3>
            </div>
            <div class="space-y-sm">
              <div class="flex justify-between items-center">
                <span class="font-body-md text-on-surface">Heel Strike</span>
                <span class="font-data-viz text-primary text-headline-sm">${r.heelStrikeCount}</span>
              </div>
              <div class="w-full bg-surface-container rounded-full h-1.5">
                <div class="bg-primary h-1.5 rounded-full" style="width:${hsWidth}%"></div>
              </div>
              <div class="flex justify-between items-center">
                <span class="font-body-md text-on-surface">Toe Off</span>
                <span class="font-data-viz text-primary text-headline-sm">${r.toeOffCount}</span>
              </div>
              <div class="w-full bg-surface-container rounded-full h-1.5">
                <div class="bg-primary-container h-1.5 rounded-full" style="width:${toWidth}%"></div>
              </div>
            </div>
          </div>

          <!-- Semiogram Summary -->
          <div class="md:col-span-2 bg-surface-container-lowest rounded-lg p-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] overflow-hidden">
            <div class="flex justify-between items-center mb-lg">
              <div class="flex items-center gap-sm">
                <span class="material-symbols-outlined text-primary">radar</span>
                <h3 class="font-label-md text-on-surface-variant">Semiogram Summary</h3>
              </div>
              <span class="text-label-sm font-label-md text-primary bg-primary-fixed/30 px-sm py-1 rounded-full uppercase tracking-tighter">Live Analysis</span>
            </div>
            <div class="flex flex-col md:flex-row items-center gap-xl">
              ${semiogramRadarSmall()}
              <div class="flex-1 grid grid-cols-2 gap-md w-full">
                <div class="p-sm bg-surface rounded-lg">
                  <p class="font-label-sm text-on-surface-variant">Speed</p>
                  <p class="font-data-viz text-headline-sm text-on-surface">88%</p>
                </div>
                <div class="p-sm bg-surface rounded-lg">
                  <p class="font-label-sm text-on-surface-variant">Stability</p>
                  <p class="font-data-viz text-headline-sm text-on-surface">64%</p>
                </div>
                <div class="p-sm bg-surface rounded-lg">
                  <p class="font-label-sm text-on-surface-variant">Symmetry</p>
                  <p class="font-data-viz text-headline-sm text-on-surface">42%</p>
                </div>
                <div class="p-sm bg-surface rounded-lg">
                  <p class="font-label-sm text-on-surface-variant">Smoothness</p>
                  <p class="font-data-viz text-headline-sm text-on-surface">76%</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="space-y-md pt-base">
          <button id="view-semiogram-btn" class="w-full bg-primary text-on-primary py-md px-lg rounded-full font-headline-sm shadow-md transition-all duration-200 active:scale-95 hover:opacity-90 flex justify-center items-center gap-sm">
            View Semiogram Details
            <span class="material-symbols-outlined">arrow_forward</span>
          </button>
          <div class="grid grid-cols-2 gap-md">
            <button class="w-full bg-secondary-container text-on-secondary-container py-md px-base rounded-full font-label-md flex items-center justify-center gap-xs transition-all duration-200 active:scale-95">
              <span class="material-symbols-outlined">save</span> Save Result
            </button>
            <button id="new-test-btn" class="w-full bg-secondary-container text-on-secondary-container py-md px-base rounded-full font-label-md flex items-center justify-center gap-xs transition-all duration-200 active:scale-95">
              <span class="material-symbols-outlined">refresh</span> New Test
            </button>
          </div>
        </div>
      </main>

      ${bottomNavShell('record')}
    </div>
  `;
}

export function mount(navigate) {
  mountBottomNav(navigate);
  document.getElementById('view-semiogram-btn')?.addEventListener('click', () => navigate('/semiogram-detail'));
  document.getElementById('new-test-btn')?.addEventListener('click', () => navigate('/instruction'));
}

import { bottomNavShell, mountBottomNav } from '../widgets/bottom_nav_shell.js';
import { semiogramRadarFull } from '../widgets/semiogram_chart.js';
import { sessionState } from '../state/session_state.js';

const PROFILE_IMG = 'https://lh3.googleusercontent.com/aida-public/AB6AXuCDWvtM4ox25xSlolZT8jQcjXsG9wQ7Y2-SCRq6-GRRk2FmHauFmSc4ZE8gQ0yN1BV36ggIKkNQa8zboK2kac5QQiT7gbA9W7H0e6bkVJlZUoqjXKRLx4mzaDWc89Y1HSeoLTSW25SAKXLDBZh4ZohgHG0RsygQd25f8R8ACVV38SjknMOj6hC8LYk_ejesrHRR4GpPxArvReMcwOIStWePMC4HF80a93fZpUtvDyDrAB1Fe1dGVj-6z9uf_3tZktcNdaExkkbq-Gg';

export function render() {
  const s = sessionState.currentResult.semiogram;

  return `
    <div class="bg-background text-on-surface font-body-md min-h-screen pb-32">
      <!-- Top AppBar -->
      <header class="bg-surface/80 dark:bg-surface-dim/80 backdrop-blur-md shadow-sm sticky z-50 top-0 flex justify-between items-center px-margin-mobile h-16 w-full transition-all duration-200">
        <div class="flex items-center gap-md">
          <button data-nav-to="/result" class="text-on-surface-variant hover:opacity-80 transition-all">
            <span class="material-symbols-outlined">arrow_back</span>
          </button>
          <h1 class="font-headline-sm text-headline-sm text-primary">Semiogram Details</h1>
        </div>
        <div class="flex items-center gap-md">
          <span class="material-symbols-outlined text-primary">sensors</span>
          <div class="w-8 h-8 rounded-full bg-surface-variant border border-outline-variant overflow-hidden">
            <img src="${PROFILE_IMG}" alt="User Profile" class="w-full h-full object-cover">
          </div>
        </div>
      </header>

      <main class="px-margin-mobile pt-lg space-y-xl max-w-2xl mx-auto">
        <!-- Radar Chart -->
        <section class="bg-surface-container-lowest rounded-lg p-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] relative overflow-hidden">
          <div class="flex justify-between items-start mb-lg">
            <div>
              <h2 class="font-headline-md text-headline-md text-on-surface">Kinematic Balance</h2>
              <p class="font-body-md text-on-surface-variant">Last assessment: Oct 24, 2023</p>
            </div>
            <span class="bg-primary-container/20 text-on-primary-container px-sm py-xs rounded-full font-label-sm text-label-sm flex items-center gap-xs">
              <span class="material-symbols-outlined text-[14px]">check_circle</span> Complete
            </span>
          </div>
          ${semiogramRadarFull()}
          <div class="grid grid-cols-2 gap-md mt-lg">
            <div class="flex items-center gap-sm">
              <div class="w-3 h-3 rounded-full bg-primary"></div>
              <span class="font-label-md text-label-md text-on-surface">Current State</span>
            </div>
            <div class="flex items-center gap-sm">
              <div class="w-3 h-3 rounded-full border border-outline-variant bg-surface-container-highest"></div>
              <span class="font-label-md text-label-md text-on-surface-variant">Baseline</span>
            </div>
          </div>
        </section>

        <!-- Parameter Metrics -->
        <section class="space-y-md">
          <div class="flex items-center justify-between px-xs">
            <h3 class="font-headline-sm text-headline-sm text-on-surface">Parameter Metrics</h3>
            <span class="font-label-md text-label-md text-primary hover:underline cursor-pointer">Export CSV</span>
          </div>

          <!-- Velocity & Cadence -->
          <details class="group bg-surface-container-lowest rounded-lg border border-outline-variant/30 overflow-hidden" open>
            <summary class="flex items-center justify-between p-md cursor-pointer list-none hover:bg-surface-container-low transition-colors">
              <div class="flex items-center gap-md">
                <div class="p-base bg-secondary-container rounded-lg">
                  <span class="material-symbols-outlined text-on-secondary-container">speed</span>
                </div>
                <span class="font-headline-sm text-headline-sm text-on-surface">Velocity &amp; Cadence</span>
              </div>
              <span class="material-symbols-outlined transition-transform group-open:rotate-180">expand_more</span>
            </summary>
            <div class="p-md grid grid-cols-1 md:grid-cols-2 gap-md border-t border-outline-variant/20">
              <div class="bg-surface-container-low p-md rounded-md">
                <p class="font-label-sm text-label-sm text-on-surface-variant uppercase mb-xs">Average Speed (V)</p>
                <p class="font-display-lg text-headline-md text-primary">${s.V} <span class="text-label-md font-normal">m/s</span></p>
              </div>
              <div class="bg-surface-container-low p-md rounded-md">
                <p class="font-label-sm text-label-sm text-on-surface-variant uppercase mb-xs">Stride Time (StrT)</p>
                <p class="font-display-lg text-headline-md text-primary">${s.StrT} <span class="text-label-md font-normal">s</span></p>
              </div>
            </div>
          </details>

          <!-- Dynamic Factors -->
          <details class="group bg-surface-container-lowest rounded-lg border border-outline-variant/30 overflow-hidden">
            <summary class="flex items-center justify-between p-md cursor-pointer list-none hover:bg-surface-container-low transition-colors">
              <div class="flex items-center gap-md">
                <div class="p-base bg-tertiary-container rounded-lg">
                  <span class="material-symbols-outlined text-on-tertiary-container">waves</span>
                </div>
                <span class="font-headline-sm text-headline-sm text-on-surface">Dynamic Factors</span>
              </div>
              <span class="material-symbols-outlined transition-transform group-open:rotate-180">expand_more</span>
            </summary>
            <div class="p-md space-y-sm border-t border-outline-variant/20">
              <div class="flex justify-between items-center p-sm bg-surface-container-low rounded-md">
                <span class="font-body-md text-on-surface">Springiness (StrT)</span>
                <span class="font-data-viz text-data-viz text-primary">${s.StrT} s</span>
              </div>
              <div class="flex justify-between items-center p-sm bg-surface-container-low rounded-md">
                <span class="font-body-md text-on-surface">Smoothness (LDLJ)</span>
                <span class="font-data-viz text-data-viz text-error">${s.LDLJa}</span>
              </div>
              <div class="flex justify-between items-center p-sm bg-surface-container-low rounded-md">
                <span class="font-body-md text-on-surface">SPARC Rotation</span>
                <span class="font-data-viz text-data-viz text-primary">${s.SPARCrot}</span>
              </div>
            </div>
          </details>

          <!-- Steadiness -->
          <details class="group bg-surface-container-lowest rounded-lg border border-outline-variant/30 overflow-hidden">
            <summary class="flex items-center justify-between p-md cursor-pointer list-none hover:bg-surface-container-low transition-colors">
              <div class="flex items-center gap-md">
                <div class="p-base bg-primary-container rounded-lg">
                  <span class="material-symbols-outlined text-on-primary-container">directions_walk</span>
                </div>
                <span class="font-headline-sm text-headline-sm text-on-surface">Steadiness &amp; Stability</span>
              </div>
              <span class="material-symbols-outlined transition-transform group-open:rotate-180">expand_more</span>
            </summary>
            <div class="p-md space-y-sm border-t border-outline-variant/20">
              <div class="flex justify-between items-center p-sm bg-surface-container-low rounded-md">
                <span class="font-body-md text-on-surface">CV Stride Time</span>
                <span class="font-data-viz text-data-viz text-primary">${s.CVStrT}%</span>
              </div>
              <div class="flex justify-between items-center p-sm bg-surface-container-low rounded-md">
                <span class="font-body-md text-on-surface">RMS ML Acceleration</span>
                <span class="font-data-viz text-data-viz text-primary">${s.RMSaML} m/s²</span>
              </div>
              <div class="flex justify-between items-center p-sm bg-surface-container-low rounded-md">
                <span class="font-body-md text-on-surface">Step Length (SteL)</span>
                <span class="font-data-viz text-data-viz text-primary">${s.SteL} m</span>
              </div>
            </div>
          </details>

          <!-- Symmetry -->
          <details class="group bg-surface-container-lowest rounded-lg border border-outline-variant/30 overflow-hidden">
            <summary class="flex items-center justify-between p-md cursor-pointer list-none hover:bg-surface-container-low transition-colors">
              <div class="flex items-center gap-md">
                <div class="p-base bg-secondary-container rounded-lg">
                  <span class="material-symbols-outlined text-on-secondary-container">compare_arrows</span>
                </div>
                <span class="font-headline-sm text-headline-sm text-on-surface">Symmetry &amp; Synchronization</span>
              </div>
              <span class="material-symbols-outlined transition-transform group-open:rotate-180">expand_more</span>
            </summary>
            <div class="p-md space-y-sm border-t border-outline-variant/20">
              <div class="flex justify-between items-center p-sm bg-surface-container-low rounded-md">
                <span class="font-body-md text-on-surface">iHR AP</span>
                <span class="font-data-viz text-data-viz text-primary">${s.iHRaAP}%</span>
              </div>
              <div class="flex justify-between items-center p-sm bg-surface-container-low rounded-md">
                <span class="font-body-md text-on-surface">iHR CC</span>
                <span class="font-data-viz text-data-viz text-primary">${s.iHRaCC}%</span>
              </div>
              <div class="flex justify-between items-center p-sm bg-surface-container-low rounded-md">
                <span class="font-body-md text-on-surface">iHR ML</span>
                <span class="font-data-viz text-data-viz text-primary">${s.iHRaML}%</span>
              </div>
              <div class="flex justify-between items-center p-sm bg-surface-container-low rounded-md">
                <span class="font-body-md text-on-surface">Swing Time Ratio</span>
                <span class="font-data-viz text-data-viz text-primary">${s.swTr}</span>
              </div>
              <div class="flex justify-between items-center p-sm bg-surface-container-low rounded-md">
                <span class="font-body-md text-on-surface">DST Ratio</span>
                <span class="font-data-viz text-data-viz text-primary">${s.dstT}%</span>
              </div>
            </div>
          </details>
        </section>

        <!-- Clinical Insights -->
        <section class="bg-primary/5 rounded-lg p-lg border border-primary/10">
          <div class="flex items-center gap-sm mb-md">
            <span class="material-symbols-outlined text-primary">lightbulb</span>
            <h4 class="font-headline-sm text-headline-sm text-primary">Clinical Insights</h4>
          </div>
          <p class="font-body-md text-on-surface mb-md">
            Your gait exhibits a slight asymmetry in the <span class="font-bold">terminal stance</span> phase.
            Smoothness (LDLJ) is currently below the target range, suggesting minor hesitations in weight transfer.
          </p>
          <div class="flex items-center gap-md">
            <button class="flex-1 bg-primary text-on-primary font-label-md py-sm rounded-full shadow-md transition-all active:scale-95">View Therapy Plan</button>
            <button class="flex-1 bg-surface-container-lowest text-primary border border-primary font-label-md py-sm rounded-full transition-all active:scale-95">Compare Past</button>
          </div>
        </section>
      </main>

      ${bottomNavShell('history')}
    </div>
  `;
}

export function mount(navigate) {
  mountBottomNav(navigate);
  document.querySelectorAll('[data-nav-to]').forEach(el => {
    el.addEventListener('click', () => navigate(el.dataset.navTo));
  });
}

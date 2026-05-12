import { footSelectionCard } from '../widgets/foot_selection_card.js';
import { recordingState } from '../state/recording_state.js';

const PROFILE_IMG = 'https://lh3.googleusercontent.com/aida-public/AB6AXuDQ4f0KWiv65lVfJgVKe3zakMCW4-7cr8gCCzRTvhtju1P5CKTNOs0dDoQxxZ5tlWX123e1dRQwGFbU-0y42bLgv3HAmwzB4tVbJh6kc2WR_S8VSljOOOmNnFc05oJbjGJNpYbDQ6HINurTwqyV0ya-BcqxakPwn57kzTirsYOwvQbjtrJ4gTzmxVr-L26h-xDEp1Y9AA37G4NQ3hOWaw3LREPJpHW6Gz_k13rJXHpToUUpbYJ_OO2NYlGLknK6uv96IOnBiMhlrz8';

function buildCards(selectedFoot) {
  return `
    ${footSelectionCard({ foot: 'left',  selected: selectedFoot, description: 'Analyze balance and step pressure for the left side.' })}
    ${footSelectionCard({ foot: 'right', selected: selectedFoot, description: 'Analyze balance and step pressure for the right side.' })}
  `;
}

export function render() {
  return `
    <div class="bg-background text-on-background font-body-md selection:bg-primary-container selection:text-on-primary-container" style="min-height: max(884px, 100dvh);">
      <!-- Header -->
      <header class="bg-surface/80 backdrop-blur-md shadow-sm sticky top-0 z-50 h-16 w-full flex justify-between items-center px-margin-mobile">
        <div class="flex items-center gap-md">
          <button data-nav-to="/instruction" class="transition-all duration-200 active:scale-95 hover:opacity-80 text-primary">
            <span class="material-symbols-outlined">arrow_back</span>
          </button>
          <h1 class="font-headline-sm text-headline-sm text-primary">Gait Analysis</h1>
        </div>
        <div class="w-10 h-10 rounded-full bg-surface-variant flex items-center justify-center overflow-hidden border border-outline-variant/30">
          <img src="${PROFILE_IMG}" alt="User profile photo" class="w-full h-full object-cover">
        </div>
      </header>

      <main class="min-h-[calc(100vh-64px)] px-margin-mobile pt-lg pb-xl max-w-lg mx-auto flex flex-col">
        <!-- Title -->
        <section class="mb-xl text-center">
          <h2 class="font-display-lg text-display-lg text-on-surface mb-xs">Select Foot Side</h2>
          <p class="font-body-md text-body-md text-on-surface-variant">Choose which foot you want to record first.</p>
        </section>

        <!-- Cards -->
        <div id="foot-cards" class="grid grid-cols-1 gap-lg mb-xl">
          ${buildCards(recordingState.selectedFoot)}
        </div>

        <!-- Info Box -->
        <div class="bg-surface-container-high rounded-md p-md mb-xl flex gap-md items-start">
          <span class="material-symbols-outlined text-secondary" style="font-variation-settings: 'FILL' 1">info</span>
          <p class="font-label-md text-label-md text-on-surface-variant">
            You will be asked to record the other foot after this session.
          </p>
        </div>

        <!-- Action Button -->
        <div class="mt-auto">
          <button id="continue-recording-btn" class="w-full bg-primary text-on-primary font-headline-sm py-4 rounded-full shadow-lg transition-all duration-300 active:scale-95 hover:opacity-90 flex items-center justify-center gap-base">
            Continue to Recording
            <span class="material-symbols-outlined">arrow_forward</span>
          </button>
        </div>
      </main>

      <footer class="h-8 w-full bg-transparent"></footer>
    </div>
  `;
}

export function mount(navigate) {
  document.querySelectorAll('[data-nav-to]').forEach(el => {
    el.addEventListener('click', () => navigate(el.dataset.navTo));
  });

  document.querySelectorAll('[data-foot]').forEach(btn => {
    btn.addEventListener('click', () => {
      recordingState.selectedFoot = btn.dataset.foot;
      const container = document.getElementById('foot-cards');
      if (container) container.innerHTML = buildCards(recordingState.selectedFoot);
      // Re-attach after re-render
      mount(navigate);
    });
  });

  document.getElementById('continue-recording-btn')?.addEventListener('click', () => navigate('/recording'));
}

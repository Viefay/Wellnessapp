import { instructionCard } from '../widgets/instruction_card.js';

const INSTRUCTIONS = [
  { icon: 'smartphone',       title: 'Attach Your Phone',  description: 'Secure your phone firmly on the lateral side of your selected foot using a strap or tight sock.' },
  { icon: 'directions_walk',  title: 'Walk Naturally',     description: 'Walk at your most comfortable, everyday speed across a flat surface for 10 meters.' },
  { icon: 'repeat',           title: 'Record Both Feet',   description: 'To get a full analysis, you will need to repeat the test for both your right and left foot.' },
  { icon: 'health_and_safety', title: 'Stay Safe',          description: 'Ensure your walking path is clear of obstacles and avoid slippery surfaces during the test.' },
];

const HERO_IMG = 'https://lh3.googleusercontent.com/aida-public/AB6AXuDWzQ91i_Cm363zVQEjSxH_-J-noNQNNVH9SJFp4b_XawTRBwIzeWdaJalHrI6gxcvk7iwPKOy43C3rFCaF0b7o8feO_lYsxQqmREkuEJnyWw1yYR_71SBHJID8954iBp_ZvWtR6xw2A9uj-A-OLtKt5WOz5d1AY6DCG8yqFeVM4iUEGwbiwhYfKAUCtb-a6EBLJH7F7nKEUab7LCRnYPygApcSzy081YvIdmLsDN0PwJWb7YiCTHXNHggKi3ukq2EwcpX_f5U_mfA';

export function render() {
  return `
    <div class="bg-background min-h-screen flex flex-col font-body-md text-on-background selection:bg-primary-container selection:text-on-primary-container">
      <!-- Header -->
      <header class="bg-surface/80 backdrop-blur-md sticky top-0 z-50 shadow-sm flex justify-between items-center px-margin-mobile h-16 w-full">
        <div class="flex items-center gap-md">
          <button data-nav-to="/home" class="transition-all duration-200 active:scale-95 text-on-surface-variant">
            <span class="material-symbols-outlined">arrow_back</span>
          </button>
          <h1 class="font-headline-sm text-headline-sm text-primary">Before You Start</h1>
        </div>
        <div class="w-10 h-10 rounded-full bg-surface-container flex items-center justify-center text-primary">
          <span class="material-symbols-outlined">info</span>
        </div>
      </header>

      <main class="flex-grow px-margin-mobile pt-xl pb-xl max-w-xl mx-auto w-full">
        <!-- Hero -->
        <section class="mb-xl text-center">
          <div class="w-full aspect-[16/9] rounded-lg bg-surface-container-high mb-lg overflow-hidden relative">
            <div class="absolute inset-0 bg-gradient-to-tr from-primary/10 to-transparent"></div>
            <img src="${HERO_IMG}" alt="Wellness Guide" class="w-full h-full object-cover">
          </div>
          <p class="font-body-lg text-body-lg text-on-surface-variant max-w-sm mx-auto">
            Follow these simple steps to ensure your gait analysis is accurate and helpful.
          </p>
        </section>

        <!-- Instruction Cards -->
        <div class="space-y-md">
          ${INSTRUCTIONS.map(i => instructionCard(i)).join('')}
        </div>

        <!-- Reassurance Banner -->
        <div class="mt-xl p-lg bg-secondary-container/30 rounded-lg border border-secondary-container flex items-center gap-md">
          <span class="material-symbols-outlined text-on-secondary-container">verified_user</span>
          <p class="font-label-md text-label-md text-on-secondary-container">
            Your data is encrypted and used only for your clinical analysis.
          </p>
        </div>
      </main>

      <!-- Sticky Footer -->
      <footer class="p-margin-mobile bg-surface/90 backdrop-blur-md sticky bottom-0">
        <button id="continue-btn" class="w-full h-14 rounded-full bg-primary text-on-primary font-headline-sm text-headline-sm shadow-lg transition-transform active:scale-95 hover:bg-primary/90">
          Continue
        </button>
      </footer>
    </div>
  `;
}

export function mount(navigate) {
  document.querySelectorAll('[data-nav-to]').forEach(el => {
    el.addEventListener('click', () => navigate(el.dataset.navTo));
  });
  document.getElementById('continue-btn')?.addEventListener('click', () => navigate('/foot-selection'));
}

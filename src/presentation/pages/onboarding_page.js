const SLIDES = [
  {
    title: 'Analyze Your Walking Pattern',
    description: 'Use your smartphone sensors to understand your gait quality.',
    img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDFDJmIxLkaDpMRbGYGXrCH6Xa_ByDdyOEkhgwTth-QgLD_mPpvNy0Rvbpa9bCo1q27JoeowtAi-0y41Us78h-8LfOPw01A91t_Hus7qKw7FbCN7RbVvmzhD4WLIDpMemNSRBe4-BS6oYr2ziBS55snk0Q3iPG6cGP2TzYhvM1_oDZa12agQ9Wvon6yiDLXVjDiXE_JwJ-OrkKa479IePcuWyS3AwuoueDGtMyczqFObII14wMpLg-sRyOLZPiFXo68yznWXJJDTRA',
    chip: 'Live Sensors',
    chipIcon: 'check_circle',
  },
  {
    title: 'Record Right and Left Foot',
    description: 'Place your phone alternately on each foot and follow the walking test.',
    img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDFDJmIxLkaDpMRbGYGXrCH6Xa_ByDdyOEkhgwTth-QgLD_mPpvNy0Rvbpa9bCo1q27JoeowtAi-0y41Us78h-8LfOPw01A91t_Hus7qKw7FbCN7RbVvmzhD4WLIDpMemNSRBe4-BS6oYr2ziBS55snk0Q3iPG6cGP2TzYhvM1_oDZa12agQ9Wvon6yiDLXVjDiXE_JwJ-OrkKa479IePcuWyS3AwuoueDGtMyczqFObII14wMpLg-sRyOLZPiFXo68yznWXJJDTRA',
    chip: 'Dual Recording',
    chipIcon: 'swap_horiz',
  },
  {
    title: 'Get Smart Gait Insights',
    description: 'View FMA-LE prediction, gait events, and semiogram results.',
    img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDFDJmIxLkaDpMRbGYGXrCH6Xa_ByDdyOEkhgwTth-QgLD_mPpvNy0Rvbpa9bCo1q27JoeowtAi-0y41Us78h-8LfOPw01A91t_Hus7qKw7FbCN7RbVvmzhD4WLIDpMemNSRBe4-BS6oYr2ziBS55snk0Q3iPG6cGP2TzYhvM1_oDZa12agQ9Wvon6yiDLXVjDiXE_JwJ-OrkKa479IePcuWyS3AwuoueDGtMyczqFObII14wMpLg-sRyOLZPiFXo68yznWXJJDTRA',
    chip: 'AI Analysis',
    chipIcon: 'insights',
  },
];

let currentSlide = 0;

function renderDots(active) {
  return SLIDES.map((_, i) => `
    <div class="h-2 rounded-full transition-all ${i === active ? 'w-8 bg-primary' : 'w-2 bg-surface-container-highest'}"></div>
  `).join('');
}

export function render() {
  currentSlide = 0;
  return buildPage(0);
}

function buildPage(slideIndex) {
  const slide = SLIDES[slideIndex];
  return `
    <div class="bg-background text-on-surface min-h-screen flex flex-col font-body-md overflow-hidden">
      <!-- Header -->
      <header class="flex justify-between items-center px-margin-mobile h-16 w-full sticky top-0 bg-surface/80 backdrop-blur-md z-10">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-primary">directions_run</span>
          <h1 class="font-display-lg text-headline-sm text-primary">Gait Analysis</h1>
        </div>
        <button id="skip-btn" class="font-label-md text-primary hover:opacity-80 transition-all active:scale-95">Skip</button>
      </header>

      <!-- Main -->
      <main class="flex-1 flex flex-col relative">
        <section class="flex-1 flex flex-col px-margin-mobile py-xl">
          <!-- Illustration -->
          <div class="w-full aspect-[4/5] max-h-[400px] mb-xl relative overflow-hidden rounded-xl bg-surface-container-lowest shadow-[0_4px_20px_0_rgba(29,53,87,0.06)]">
            <div class="absolute inset-0 bg-gradient-to-br from-primary-container/20 to-transparent"></div>
            <div class="absolute inset-0 flex items-center justify-center p-xl">
              <img src="${slide.img}" alt="${slide.title}" class="w-full h-full object-cover rounded-lg mix-blend-multiply opacity-90">
            </div>
            <div class="absolute top-md right-md bg-white/90 backdrop-blur-sm px-sm py-xs rounded-full border border-primary-container/30 flex items-center gap-2 shadow-sm">
              <span class="material-symbols-outlined text-primary text-[16px]" style="font-variation-settings: 'FILL' 1;">${slide.chipIcon}</span>
              <span class="font-label-sm text-on-surface-variant">${slide.chip}</span>
            </div>
          </div>

          <!-- Typography -->
          <div class="flex flex-col gap-md text-center">
            <h2 class="font-display-lg text-display-lg text-on-surface leading-tight">${slide.title}</h2>
            <p class="font-body-lg text-on-surface-variant max-w-[280px] mx-auto">${slide.description}</p>
          </div>
        </section>

        <!-- Footer Actions -->
        <div class="px-margin-mobile pb-xl flex flex-col items-center gap-xl">
          <div id="onboarding-dots" class="flex gap-2">${renderDots(slideIndex)}</div>
          <div class="w-full flex flex-col gap-md">
            <button id="onboarding-next" class="w-full bg-primary text-on-primary py-md px-lg rounded-full font-label-md text-body-lg shadow-[0_8px_24px_rgba(46,196,182,0.15)] transition-all duration-200 active:scale-95 flex items-center justify-center gap-2">
              ${slideIndex < SLIDES.length - 1 ? 'Next <span class="material-symbols-outlined">arrow_forward</span>' : 'Get Started <span class="material-symbols-outlined">arrow_forward</span>'}
            </button>
            <p class="font-label-sm text-outline text-center px-lg">
              By continuing, you agree to our privacy policy regarding sensor data collection.
            </p>
          </div>
        </div>
      </main>

      <!-- Background decoration -->
      <div class="fixed top-[-10%] right-[-10%] w-[300px] h-[300px] bg-primary-container/10 rounded-full blur-3xl -z-10"></div>
      <div class="fixed bottom-[-5%] left-[-10%] w-[250px] h-[250px] bg-tertiary-container/10 rounded-full blur-3xl -z-10"></div>
    </div>
  `;
}

export function mount(navigate) {
  document.getElementById('skip-btn')?.addEventListener('click', () => navigate('/home'));
  document.getElementById('onboarding-next')?.addEventListener('click', () => {
    if (currentSlide < SLIDES.length - 1) {
      currentSlide++;
      const app = document.getElementById('app');
      app.innerHTML = buildPage(currentSlide);
      mount(navigate);
    } else {
      navigate('/home');
    }
  });
}

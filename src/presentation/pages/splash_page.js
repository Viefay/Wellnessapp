let _splashTimer = null;

export function render() {
  return `
    <div class="min-h-screen flex flex-col items-center justify-center p-margin-mobile" style="background: linear-gradient(180deg, #CBF3F0 0%, #F7F9FA 100%);">
      <main class="w-full max-w-md flex flex-col items-center justify-center space-y-xl">
        <!-- Logo Cluster -->
        <div class="relative flex items-center justify-center">
          <div class="absolute w-48 h-48 bg-primary-container/20 rounded-full blur-3xl"></div>
          <div class="relative flex flex-col items-center">
            <div class="w-24 h-24 bg-white rounded-xl shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] flex items-center justify-center mb-md">
              <div class="relative">
                <span class="material-symbols-outlined text-primary text-[48px]">directions_walk</span>
                <div class="absolute -bottom-1 -right-1 bg-primary text-white rounded-full p-1 border-2 border-white">
                  <span class="material-symbols-outlined text-[16px]" style="font-variation-settings: 'FILL' 1;">monitor_heart</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Typography -->
        <div class="text-center space-y-md">
          <h1 class="font-display-lg text-display-lg text-primary tracking-tight">Wellness App</h1>
          <p class="font-body-lg text-body-lg text-on-surface-variant max-w-[280px] mx-auto opacity-90">
            Smart gait assessment from your smartphone
          </p>
        </div>

        <!-- Hero Image -->
        <div class="w-full pt-xl">
          <div class="relative w-full aspect-square rounded-lg overflow-hidden shadow-sm">
            <img
              src="https://lh3.googleusercontent.com/aida-public/AB6AXuDpU5PKo8bd1xwI7taVzBVu9COxzZ_3yiX3onAH0h53UQa8bYVmIrbAExW5tB37T-cbf618XgHtETYd8k0Az4sChpI0GNF_EZg_srXFgqVymX-JWcXGGyRCgxNc39uAvi6x6jNh3XOIYA0cgAOV9YpgyySLyITNgG7lOTV4Y86FPGNpNjdErniqV_sVGT2SA93TYWj_8NsCzzm1xAz9mD4tJQqUmJUHbq8lAbfCQtmnLhIW_feqqMPeqW1MXV75aqSs84kxgEo0PTI"
              alt="Wellness Assessment"
              class="w-full h-full object-cover"
            >
            <div class="absolute inset-0 bg-gradient-to-t from-surface/80 to-transparent flex items-end p-lg">
              <div class="glass-background p-md rounded-lg w-full border border-white/30">
                <div class="flex items-center space-y-1">
                  <div class="flex-1">
                    <div class="h-1.5 w-full bg-primary-container/30 rounded-full overflow-hidden">
                      <div class="h-full bg-primary w-2/3 rounded-full"></div>
                    </div>
                    <div class="flex justify-between mt-2">
                      <span class="font-label-sm text-label-sm text-primary uppercase tracking-wider">Analyzing Motion</span>
                      <span class="font-label-sm text-label-sm text-on-surface-variant">68%</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>

      <!-- Footer -->
      <footer class="fixed bottom-xl w-full flex flex-col items-center space-y-md px-margin-mobile">
        <div class="flex space-x-2">
          <div class="w-8 h-1 bg-primary rounded-full"></div>
          <div class="w-2 h-1 bg-outline-variant/40 rounded-full"></div>
          <div class="w-2 h-1 bg-outline-variant/40 rounded-full"></div>
        </div>
        <button id="splash-cta" class="bg-primary text-white font-label-md text-label-md px-xl py-md rounded-full shadow-lg active:scale-95 transition-transform">
          Get Started
        </button>
      </footer>
    </div>
  `;
}

export function mount(navigate) {
  _splashTimer = setTimeout(() => navigate('/onboarding'), 2500);
  document.getElementById('splash-cta')?.addEventListener('click', () => {
    if (_splashTimer) clearTimeout(_splashTimer);
    navigate('/onboarding');
  });
}

export function unmount() {
  if (_splashTimer) clearTimeout(_splashTimer);
}

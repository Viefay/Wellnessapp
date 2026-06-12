/** Radar chart SVG for the semiogram summary on the result page */
export function semiogramRadarSmall() {
  return `
    <div class="relative w-48 h-48 flex items-center justify-center">
      <div class="absolute inset-0 rounded-full border border-outline-variant/30 scale-100"></div>
      <div class="absolute inset-0 rounded-full border border-outline-variant/30 scale-75"></div>
      <div class="absolute inset-0 rounded-full border border-outline-variant/30 scale-50"></div>
      <svg class="w-full h-full drop-shadow-lg" viewBox="0 0 100 100">
        <polygon class="fill-primary/20 stroke-primary stroke-2" points="50,10 85,35 75,80 20,70 15,30"></polygon>
        <circle class="fill-primary" cx="50" cy="10" r="3"></circle>
        <circle class="fill-primary" cx="85" cy="35" r="3"></circle>
        <circle class="fill-primary" cx="75" cy="80" r="3"></circle>
        <circle class="fill-primary" cx="20" cy="70" r="3"></circle>
        <circle class="fill-primary" cx="15" cy="30" r="3"></circle>
      </svg>
      <span class="absolute -top-4 font-label-sm text-on-surface-variant">Speed</span>
      <span class="absolute -right-8 font-label-sm text-on-surface-variant">Stability</span>
      <span class="absolute -bottom-4 font-label-sm text-on-surface-variant">Symmetry</span>
      <span class="absolute -left-10 font-label-sm text-on-surface-variant">Smoothness</span>
    </div>
  `;
}

/** Full hexagonal radar chart for the semiogram detail page */
export function semiogramRadarFull() {
  return `
    <div class="w-full aspect-square relative flex items-center justify-center py-md">
      <svg class="w-full h-full max-w-[320px]" viewBox="0 0 400 400">
        <polygon class="radar-grid" points="200,40 338,120 338,280 200,360 62,280 62,120"></polygon>
        <polygon class="radar-grid" points="200,80 305,140 305,260 200,320 95,260 95,140"></polygon>
        <polygon class="radar-grid" points="200,120 272,160 272,240 200,280 128,240 128,160"></polygon>
        <line class="radar-grid" x1="200" y1="40" x2="200" y2="360"></line>
        <line class="radar-grid" x1="62"  y1="120" x2="338" y2="280"></line>
        <line class="radar-grid" x1="62"  y1="280" x2="338" y2="120"></line>
        <polygon class="radar-area" points="200,60 310,135 320,270 200,330 80,260 110,150"></polygon>
        <text class="font-data-viz text-label-sm fill-on-surface-variant" text-anchor="middle" x="200" y="30">Speed</text>
        <text class="font-data-viz text-label-sm fill-on-surface-variant" text-anchor="start"  x="350" y="120">Springiness</text>
        <text class="font-data-viz text-label-sm fill-on-surface-variant" text-anchor="start"  x="350" y="290">Smoothness</text>
        <text class="font-data-viz text-label-sm fill-on-surface-variant" text-anchor="middle" x="200" y="385">Steadiness</text>
        <text class="font-data-viz text-label-sm fill-on-surface-variant" text-anchor="end"    x="50"  y="290">Sturdiness</text>
        <text class="font-data-viz text-label-sm fill-on-surface-variant" text-anchor="end"    x="50"  y="120">Stability</text>
      </svg>
      <div class="absolute inset-0 flex items-center justify-center pointer-events-none">
        <div class="bg-surface-container-lowest/80 backdrop-blur-sm rounded-full p-lg flex flex-col items-center shadow-lg border border-outline-variant/30">
          <span class="font-display-lg text-display-lg text-primary">82</span>
          <span class="font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider">Index Score</span>
        </div>
      </div>
    </div>
  `;
}

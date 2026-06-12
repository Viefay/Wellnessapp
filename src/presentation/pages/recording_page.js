import { bottomNavShell, mountBottomNav } from '../widgets/bottom_nav_shell.js';
import { recordingState, resetRecording } from '../state/recording_state.js';

const CIRCUMFERENCE = 276.46;
const TOTAL_TIME = 30;

const PROFILE_IMG = 'https://lh3.googleusercontent.com/aida-public/AB6AXuBocmruQVWzf-9-nIeRWjkIR4G0Ie3ebtiMMvkI-2sa35xZ0serm-uJzpnPz2G-RebXfTcDrwDdj5pYQBzODxFFBHf2xKJbixIia7xzSO2KUcZB3u3EXGzzmnsw_cykhYYTzzQVm5OsocsNOWABD2P-LbxMwwYmeobCuxot5yXPtX8GAm0WaaADRdM0vcxx740lRq5jei6ILWu1hroRAB7ddxdJ2Bc95fTPKfVbxpKxXdrobW78XIdW7xdq-I4Th0XTj7jEl8XRj84';

const BARS = [40, 60, 80, 50, 90, 70, 40, 60, 30, 55, 85, 65].map(h =>
  `<div class="bg-primary-container/60 flex-1 rounded-t-xs" style="height:${h}%;"></div>`
).join('');

function formatTime(s) {
  return `${String(Math.floor(s / 60)).padStart(2, '0')}:${String(s % 60).padStart(2, '0')}`;
}

export function render() {
  const foot = recordingState.selectedFoot === 'right' ? 'Right Foot' : 'Left Foot';
  return `
    <div class="bg-background text-on-background font-body-md min-h-screen pb-24">
      <!-- Top App Bar -->
      <header class="bg-surface/80 backdrop-blur-md shadow-sm fixed top-0 w-full z-50 h-16 flex justify-between items-center px-margin-mobile">
        <div class="flex items-center gap-md">
          <div class="w-10 h-10 rounded-full bg-surface-variant overflow-hidden border border-outline-variant/30">
            <img src="${PROFILE_IMG}" alt="User Profile" class="w-full h-full object-cover">
          </div>
          <h1 class="font-headline-sm text-headline-sm text-primary">Gait Analysis</h1>
        </div>
        <button class="text-primary transition-all duration-200 active:scale-95 hover:opacity-80">
          <span class="material-symbols-outlined">sensors</span>
        </button>
      </header>

      <main class="pt-24 px-margin-mobile flex flex-col items-center">
        <!-- Header Text -->
        <div class="text-center mb-xl">
          <h2 class="font-headline-md text-headline-md text-on-surface">Recording: ${foot}</h2>
          <p class="font-body-md text-on-surface-variant mt-xs">Keep walking naturally until the timer ends.</p>
        </div>

        <!-- Timer Ring -->
        <div class="relative flex items-center justify-center w-64 h-64 mb-xl">
          <svg class="absolute w-full h-full" viewBox="0 0 100 100">
            <circle class="text-surface-container-highest" cx="50" cy="50" r="44" fill="transparent" stroke="currentColor" stroke-width="6"></circle>
            <circle
              id="progress-ring"
              class="text-primary-container progress-ring__circle"
              cx="50" cy="50" r="44"
              fill="transparent"
              stroke="currentColor"
              stroke-dasharray="${CIRCUMFERENCE}"
              stroke-dashoffset="0"
              stroke-linecap="round"
              stroke-width="6"
            ></circle>
          </svg>
          <div class="text-center z-10">
            <span id="timer-display" class="font-display-lg text-[64px] leading-none text-primary">${formatTime(TOTAL_TIME)}</span>
            <p class="font-label-md text-on-surface-variant mt-base">SECONDS REMAINING</p>
          </div>
        </div>

        <!-- Sensor Status Grid -->
        <div class="grid grid-cols-2 gap-md w-full mb-xl">
          <div class="col-span-1 bg-surface-container-lowest p-md rounded-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] border border-outline-variant/10">
            <div class="flex items-center gap-base mb-xs text-primary">
              <span class="material-symbols-outlined text-[20px]">directions_run</span>
              <span class="font-label-sm uppercase tracking-wider text-on-surface-variant">Accelerometer</span>
            </div>
            <p class="font-headline-sm text-primary">Active</p>
          </div>
          <div class="col-span-1 bg-surface-container-lowest p-md rounded-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] border border-outline-variant/10">
            <div class="flex items-center gap-base mb-xs text-primary">
              <span class="material-symbols-outlined text-[20px]">explore</span>
              <span class="font-label-sm uppercase tracking-wider text-on-surface-variant">Gyroscope</span>
            </div>
            <p class="font-headline-sm text-primary">Active</p>
          </div>
          <div class="col-span-2 bg-surface-container-lowest p-md rounded-lg shadow-[0_4px_20px_0_rgba(29,53,87,0.06)] border border-outline-variant/10">
            <div class="flex justify-between items-center mb-sm">
              <div class="flex items-center gap-base text-primary">
                <span class="material-symbols-outlined text-[20px]">speed</span>
                <span class="font-label-sm uppercase tracking-wider text-on-surface-variant">Sampling Rate: Stable</span>
              </div>
              <span class="font-data-viz text-primary">120 Hz</span>
            </div>
            <div class="h-12 w-full flex items-end gap-[2px]">${BARS}</div>
          </div>
        </div>

        <!-- Action Area -->
        <div id="action-area" class="flex flex-col items-center gap-lg w-full">
          <button id="start-btn" class="w-full bg-primary text-on-primary font-headline-sm py-4 rounded-full shadow-lg transition-all duration-300 active:scale-95 hover:opacity-90 flex items-center justify-center gap-base">
            <span class="material-symbols-outlined">play_arrow</span>
            Start Recording
          </button>
        </div>
      </main>

      ${bottomNavShell('record')}
    </div>
  `;
}

export function mount(navigate) {
  resetRecording();
  mountBottomNav(navigate);

  document.getElementById('start-btn')?.addEventListener('click', () => startRecording(navigate));
}

function startRecording(navigate) {
  recordingState.isRecording = true;
  recordingState.timeRemaining = TOTAL_TIME;

  const actionArea = document.getElementById('action-area');
  if (actionArea) {
    actionArea.innerHTML = `
      <button id="stop-btn" class="w-24 h-24 rounded-full bg-error text-on-error flex items-center justify-center pulse-error transition-all duration-300 active:scale-90 shadow-lg">
        <span class="material-symbols-outlined text-[40px]" style="font-variation-settings: 'FILL' 1;">stop</span>
      </button>
      <div class="bg-surface-container-high/50 p-md rounded-lg flex items-start gap-md w-full border-l-4 border-tertiary-container">
        <span class="material-symbols-outlined text-tertiary">info</span>
        <p class="font-label-md text-on-surface-variant">Make sure the phone stays attached during recording.</p>
      </div>
    `;
    document.getElementById('stop-btn')?.addEventListener('click', () => stopRecording(navigate));
  }

  recordingState.timerInterval = setInterval(() => {
    recordingState.timeRemaining--;
    updateTimer();
    if (recordingState.timeRemaining <= 0) {
      clearInterval(recordingState.timerInterval);
      showProcessData(navigate);
    }
  }, 1000);
}

function stopRecording(navigate) {
  if (recordingState.timerInterval) clearInterval(recordingState.timerInterval);
  recordingState.isRecording = false;
  showProcessData(navigate);
}

function showProcessData(navigate) {
  const actionArea = document.getElementById('action-area');
  if (actionArea) {
    actionArea.innerHTML = `
      <button id="process-btn" class="w-full bg-primary text-on-primary font-headline-sm py-4 rounded-full shadow-lg transition-all duration-300 active:scale-95 hover:opacity-90 flex items-center justify-center gap-base">
        <span class="material-symbols-outlined">insights</span>
        Process Data
      </button>
    `;
    document.getElementById('process-btn')?.addEventListener('click', () => navigate('/processing'));
  }
}

function updateTimer() {
  const display = document.getElementById('timer-display');
  const ring = document.getElementById('progress-ring');
  if (display) display.textContent = formatTime(recordingState.timeRemaining);
  if (ring) {
    const offset = ((TOTAL_TIME - recordingState.timeRemaining) / TOTAL_TIME) * CIRCUMFERENCE;
    ring.setAttribute('stroke-dashoffset', offset);
  }
}

export function unmount() {
  if (recordingState.timerInterval) {
    clearInterval(recordingState.timerInterval);
    recordingState.timerInterval = null;
  }
}

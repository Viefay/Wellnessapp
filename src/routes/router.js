import * as splashPage          from '../presentation/pages/splash_page.js';
import * as onboardingPage      from '../presentation/pages/onboarding_page.js';
import * as homePage            from '../presentation/pages/home_page.js';
import * as instructionPage     from '../presentation/pages/instruction_page.js';
import * as footSelectionPage   from '../presentation/pages/foot_selection_page.js';
import * as recordingPage       from '../presentation/pages/recording_page.js';
import * as processingPage      from '../presentation/pages/processing_page.js';
import * as resultPage          from '../presentation/pages/result_page.js';
import * as semiogramDetailPage from '../presentation/pages/semiogram_detail_page.js';
import * as historyPage         from '../presentation/pages/history_page.js';
import * as profilePage         from '../presentation/pages/profile_page.js';

const PAGES = {
  '/splash':          splashPage,
  '/onboarding':      onboardingPage,
  '/home':            homePage,
  '/instruction':     instructionPage,
  '/foot-selection':  footSelectionPage,
  '/recording':       recordingPage,
  '/processing':      processingPage,
  '/result':          resultPage,
  '/semiogram-detail': semiogramDetailPage,
  '/history':         historyPage,
  '/profile':         profilePage,
};

let _currentPage = null;

export function navigate(route) {
  window.location.hash = route;
}

function handleRoute() {
  const route = window.location.hash.slice(1) || '/splash';
  const page = PAGES[route];

  if (!page) {
    navigate('/splash');
    return;
  }

  if (_currentPage?.unmount) _currentPage.unmount();

  const appEl = document.getElementById('app');
  appEl.innerHTML = page.render();
  _currentPage = page;

  if (page.mount) page.mount(navigate);
}

export function initRouter() {
  window.addEventListener('hashchange', handleRoute);
  handleRoute();
}

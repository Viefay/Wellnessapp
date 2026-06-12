const PROFILE_IMG = 'https://lh3.googleusercontent.com/aida-public/AB6AXuC4YzJzQwQncoyk4L9gJ_ZPPf_AzvNnnkU_o87onjrRsI8ejdwOptD7roe6wRy506s2AhU87sAETjiZw3I7NiLIRH_p9Dj4qHVNQeHXrJkitwcVmPLCBbjt1rfdlvfvC9GW6x4rrS5O-kFzPq3C4tLmwJ9aFkDn67lxlhqRjqw_SnYYYgIylDW5s5tDGI6h0xoJ12dpAqO8wuezx8FO4oFDp_yHIA62C1JNvGJUh8AeJxeFHrqWl5qQjyPfHKpfZGAfWYEblJXITOo';

/** Standard top app bar with profile avatar + title + action icon */
export function appHeader({ title = 'Gait Analysis', actionIcon = 'sensors', showBack = false, backRoute = '' } = {}) {
  return `
    <header class="bg-surface/80 backdrop-blur-md shadow-sm sticky top-0 z-50 h-16 w-full flex justify-between items-center px-margin-mobile">
      <div class="flex items-center gap-md">
        ${showBack
          ? `<button data-nav-to="${backRoute}" class="transition-all duration-200 active:scale-95 hover:opacity-80 text-primary">
               <span class="material-symbols-outlined">arrow_back</span>
             </button>`
          : `<div class="w-10 h-10 rounded-full overflow-hidden border-2 border-primary-container">
               <img src="${PROFILE_IMG}" alt="User Profile" class="w-full h-full object-cover">
             </div>`
        }
        <h1 class="font-headline-sm text-headline-sm text-primary">${title}</h1>
      </div>
      <button class="text-primary hover:opacity-80 transition-all duration-200 active:scale-95">
        <span class="material-symbols-outlined">${actionIcon}</span>
      </button>
    </header>
  `;
}

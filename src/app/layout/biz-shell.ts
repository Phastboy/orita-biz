import { Component } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-biz-shell',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive, MatIconModule],
  template: `
    <div class="min-h-screen bg-slate-50 flex flex-col md:flex-row font-sans text-slate-900">
      <!-- Mobile header -->
      <div class="md:hidden flex items-center justify-between bg-white border-b border-slate-200 p-4 sticky top-0 z-30">
        <div class="flex items-center gap-2">
          <div class="w-8 h-8 bg-indigo-600 rounded-lg flex items-center justify-center text-white font-bold">O</div>
          <span class="font-semibold text-lg tracking-tight">Oríta Biz</span>
        </div>
        <button (click)="mobileMenuOpen = !mobileMenuOpen" class="text-slate-500 hover:text-slate-900 focus:outline-none">
          <mat-icon>{{ mobileMenuOpen ? 'close' : 'menu' }}</mat-icon>
        </button>
      </div>

      <!-- Sidebar -->
      <aside [class.hidden]="!mobileMenuOpen" class="md:flex flex-col w-full md:w-64 bg-white border-r border-slate-200 fixed md:sticky top-[65px] md:top-0 h-[calc(100vh-65px)] md:h-screen z-20 overflow-y-auto">
        <div class="hidden md:flex items-center gap-2 p-6 pb-2">
          <div class="w-8 h-8 bg-indigo-600 rounded-lg flex items-center justify-center text-white font-bold">O</div>
          <span class="font-semibold text-lg tracking-tight">Oríta Biz</span>
        </div>
        
        <div class="p-6 md:p-6 pb-4">
          <div class="flex items-center gap-3">
            <img src="https://picsum.photos/seed/bizlogo/64/64" alt="Biz Logo" class="w-10 h-10 rounded-full border border-slate-200">
            <div class="overflow-hidden">
              <p class="font-medium text-sm truncate">Lakeside Cafe & Bakery</p>
              <p class="text-xs text-slate-500 truncate">Food & Dining</p>
            </div>
          </div>
        </div>

        <nav class="flex-1 px-4 space-y-1 pb-8">
          @for (item of navItems; track item.path) {
            <a [routerLink]="item.path" 
               routerLinkActive="bg-indigo-50 text-indigo-700 font-medium"
               [routerLinkActiveOptions]="{exact: item.exact}"
               (click)="mobileMenuOpen = false"
               [class.text-amber-600]="item.label === 'Opportunities'"
               class="flex items-center gap-3 px-3 py-2 rounded-md text-sm text-slate-600 hover:bg-slate-50 transition-colors group">
              <mat-icon class="text-slate-400 group-hover:text-slate-600"
                        [class.!text-amber-500]="item.label === 'Opportunities'"
                        [class.!text-indigo-600]="isRouteActive(item.path, item.exact)">
                {{ item.icon }}
              </mat-icon>
              {{ item.label }}
            </a>
          }
        </nav>
        
        <div class="p-4 border-t border-slate-200 mt-auto">
           <a routerLink="/settings"
               routerLinkActive="bg-indigo-50 text-indigo-700 font-medium"
               (click)="mobileMenuOpen = false"
               class="flex items-center gap-3 px-3 py-2 rounded-md text-sm text-slate-600 hover:bg-slate-50 transition-colors group">
              <mat-icon class="text-slate-400 group-hover:text-slate-600">settings</mat-icon>
              Settings
            </a>
        </div>
      </aside>

      <!-- Main content -->
      <main class="flex-1 min-w-0 overflow-y-auto">
        <router-outlet></router-outlet>
      </main>
    </div>
  `
})
export class BizShell {
  mobileMenuOpen = false;
  
  navItems = [
    { path: '/dashboard', label: 'Dashboard', icon: 'dashboard', exact: false },
    { path: '/business', label: 'Business Profile', icon: 'storefront', exact: false },
    { path: '/listings', label: 'Listings', icon: 'inventory_2', exact: false },
    { path: '/opportunities', label: 'Opportunities', icon: 'campaign', exact: false },
    { path: '/messages', label: 'Messages', icon: 'forum', exact: false },
    { path: '/analytics', label: 'Analytics', icon: 'bar_chart', exact: false },
  ];

  // A simple hacky check since RouterLinkActive on the icon doesn't easily work without viewchild, 
  // but we can just let RouterLinkActive handle the main classes.
  // Actually, standard RouterLinkActive works fine on the anchor.
  isRouteActive(path: string, exact: boolean) {
    // In a real app we'd inject Router and check isActive
    return false; // we'll rely on CSS cascade instead for the icon color if needed.
  }
}

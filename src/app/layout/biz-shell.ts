import { Component, inject } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { BusinessService } from '../core/business.service';

@Component({
  selector: 'app-biz-shell',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive, MatIconModule],
  template: `
    <div class="flex h-screen w-full bg-slate-50 font-sans overflow-hidden text-slate-900"> 
      
      <!-- Mobile sidebar toggle -->
      <div class="md:hidden absolute top-4 right-4 z-50">
        <button (click)="mobileMenuOpen = !mobileMenuOpen" class="bg-white p-2 rounded-lg shadow-sm border border-slate-200 text-slate-600 focus:outline-none">
          <mat-icon>{{ mobileMenuOpen ? 'close' : 'menu' }}</mat-icon>
        </button>
      </div>

      <aside [class.hidden]="!mobileMenuOpen && false" class="md:flex w-64 bg-white border-r border-slate-200 flex-col absolute md:relative z-40 h-full transition-transform" [class.-translate-x-full]="!mobileMenuOpen" [class.translate-x-0]="mobileMenuOpen" class="md:translate-x-0 w-64 bg-white border-r border-slate-200 flex flex-col h-full absolute md:relative z-40 transition-transform">
        <div class="p-6 flex items-center gap-3">
          <div class="w-8 h-8 bg-indigo-600 rounded-lg flex items-center justify-center text-white font-bold">O</div> 
          <span class="text-xl font-bold tracking-tight">Oríta Biz</span> 
        </div> 

        <nav class="flex-1 px-4 space-y-1 overflow-y-auto mt-4">
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
               class="flex items-center gap-3 px-3 py-2 rounded-md text-sm text-slate-600 hover:bg-slate-50 transition-colors group mb-4">
              <mat-icon class="text-slate-400 group-hover:text-slate-600">settings</mat-icon>
              Settings
            </a>
          <div class="flex items-center gap-3 bg-slate-50 p-3 rounded-lg"> 
            <div class="w-10 h-10 rounded-full flex items-center justify-center overflow-hidden shrink-0 border border-slate-200"> 
              <img [src]="bizSvc.currentBusiness().logo" class="w-full h-full object-cover"> 
            </div> 
            <div class="flex-1 min-w-0"> 
              <p class="text-sm font-semibold truncate">{{ bizSvc.currentBusiness().name }}</p> 
              <p class="text-xs text-slate-500 truncate">{{ bizSvc.currentBusiness().category }}</p> 
            </div> 
          </div> 
        </div> 
      </aside> 
      <main class="flex-1 flex flex-col overflow-hidden relative"> 
        <router-outlet></router-outlet>
      </main> 
    </div>
  `
})
export class BizShell {
  bizSvc = inject(BusinessService);
  mobileMenuOpen = false;
  
  navItems = [
    { path: '/dashboard', label: 'Dashboard', icon: 'dashboard', exact: false },
    { path: '/business', label: 'Business Profile', icon: 'storefront', exact: false },
    { path: '/listings', label: 'Listings', icon: 'inventory_2', exact: false },
    { path: '/opportunities', label: 'Opportunities', icon: 'campaign', exact: false },
    { path: '/messages', label: 'Messages', icon: 'forum', exact: false },
    { path: '/analytics', label: 'Analytics', icon: 'bar_chart', exact: false },
  ];

  isRouteActive(path: string, exact: boolean) {
    return false;
  }
}

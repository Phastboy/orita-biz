import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./layout/biz-shell').then(m => m.BizShell),
    children: [
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
      { path: 'dashboard', loadComponent: () => import('./pages/dashboard/dashboard.component').then(m => m.DashboardComponent) },
      { path: 'business', loadComponent: () => import('./pages/business/business.component').then(m => m.BusinessComponent) },
      { path: 'listings', loadComponent: () => import('./pages/listings/listings.component').then(m => m.ListingsComponent) },
      { path: 'opportunities', loadComponent: () => import('./pages/opportunities/opportunities.component').then(m => m.OpportunitiesComponent) },
      { path: 'messages', loadComponent: () => import('./pages/messages/messages.component').then(m => m.MessagesComponent) },
      { path: 'analytics', loadComponent: () => import('./pages/analytics/analytics.component').then(m => m.AnalyticsComponent) },
      { path: 'settings', loadComponent: () => import('./pages/settings/settings.component').then(m => m.SettingsComponent) },
    ]
  }
];

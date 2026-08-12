#!/bin/bash
set -e

# core types
cat << 'CORE' > src/app/core/types.ts
export type ListingStatus = 'active' | 'draft' | 'archived';
export type OpportunityStatus = 'active' | 'scheduled' | 'expired' | 'closed';
export type MessageStatus = 'unread' | 'read' | 'replied';

export interface Business {
  id: string;
  name: string;
  description: string;
  logo: string;
  coverImage: string;
  category: string;
  email: string;
  phone: string;
  address: string;
  openingHours: string;
  serviceAreas: string[];
}

export interface Listing {
  id: string;
  title: string;
  description: string;
  price: number;
  status: ListingStatus;
  availability: 'in-stock' | 'out-of-stock' | 'pre-order';
  image: string;
  category: string;
  views: number;
}

export interface Opportunity {
  id: string;
  title: string;
  type: string;
  description: string;
  status: OpportunityStatus;
  createdAt: string;
  expiresAt: string;
  interactions: number;
}

export interface Message {
  id: string;
  senderName: string;
  preview: string;
  contextType: 'listing' | 'opportunity' | 'general';
  contextTitle?: string;
  status: MessageStatus;
  timestamp: string;
}

export interface Metric {
  label: string;
  value: string | number;
  trend: number;
}
CORE

# core mock data
cat << 'MOCK' > src/app/core/mock-data.ts
import { Business, Listing, Opportunity, Message, Metric } from './types';

export const MOCK_BUSINESS: Business = {
  id: 'b1',
  name: 'Lakeside Cafe & Bakery',
  description: 'Artisan coffee, fresh pastries, and a cozy atmosphere. We source local ingredients and roast our own beans daily.',
  logo: 'https://picsum.photos/seed/bizlogo/200/200',
  coverImage: 'https://picsum.photos/seed/bizcover/1200/400',
  category: 'Food & Dining',
  email: 'hello@lakesidecafe.com',
  phone: '(555) 123-4567',
  address: '123 Main St, Springfield',
  openingHours: 'Mon-Sat: 7am - 6pm, Sun: 8am - 4pm',
  serviceAreas: ['Springfield', 'Shelbyville', 'Capital City']
};

export const MOCK_METRICS: Metric[] = [
  { label: 'Profile Views', value: '1,248', trend: 12.5 },
  { label: 'Listing Views', value: '3,842', trend: 8.2 },
  { label: 'Contact Clicks', value: '156', trend: -2.4 },
  { label: 'Messages', value: '42', trend: 18.0 }
];

export const MOCK_LISTINGS: Listing[] = [
  { id: 'l1', title: 'Signature Espresso Roast', description: 'Our house blend espresso beans (1lb)', price: 18.00, status: 'active', availability: 'in-stock', image: 'https://picsum.photos/seed/l1/300/300', category: 'Coffee Beans', views: 342 },
  { id: 'l2', title: 'Sourdough Loaf', description: 'Freshly baked artisan sourdough', price: 8.50, status: 'active', availability: 'in-stock', image: 'https://picsum.photos/seed/l2/300/300', category: 'Bakery', views: 890 },
  { id: 'l3', title: 'Catering: Breakfast Pastry Box', description: 'Assorted pastries for 10-12 people', price: 45.00, status: 'active', availability: 'pre-order', image: 'https://picsum.photos/seed/l3/300/300', category: 'Catering', views: 124 },
  { id: 'l4', title: 'Seasonal Pumpkin Spice Latte', description: 'Fall special', price: 5.50, status: 'archived', availability: 'out-of-stock', image: 'https://picsum.photos/seed/l4/300/300', category: 'Beverages', views: 1560 },
  { id: 'l5', title: 'Ceramic Coffee Mug', description: 'Locally made branded mug', price: 22.00, status: 'draft', availability: 'in-stock', image: 'https://picsum.photos/seed/l5/300/300', category: 'Merch', views: 0 }
];

export const MOCK_OPPORTUNITIES: Opportunity[] = [
  { id: 'o1', title: 'Need a Barista for Weekend Shifts', type: 'Hiring', description: 'Looking for an experienced barista to cover Saturday and Sunday morning shifts.', status: 'active', createdAt: '2026-08-10T10:00:00Z', expiresAt: '2026-08-20T10:00:00Z', interactions: 5 },
  { id: 'o2', title: 'Free Pastry with Large Coffee', type: 'Promotion', description: 'Today only! Buy any large coffee and get a free croissant or muffin.', status: 'active', createdAt: '2026-08-12T08:00:00Z', expiresAt: '2026-08-12T18:00:00Z', interactions: 42 },
  { id: 'o3', title: 'Upcoming Latte Art Workshop', type: 'Event', description: 'Join us next week for a beginner-friendly latte art class.', status: 'scheduled', createdAt: '2026-08-05T14:00:00Z', expiresAt: '2026-08-15T18:00:00Z', interactions: 12 },
  { id: 'o4', title: 'Looking for Local Honey Supplier', type: 'Sourcing', description: 'We want to partner with a local apiary for our new drink menu.', status: 'expired', createdAt: '2026-07-01T09:00:00Z', expiresAt: '2026-07-15T09:00:00Z', interactions: 3 }
];

export const MOCK_MESSAGES: Message[] = [
  { id: 'm1', senderName: 'Sarah Jenkins', preview: 'Is the barista position still open?', contextType: 'opportunity', contextTitle: 'Need a Barista for Weekend Shifts', status: 'unread', timestamp: '2026-08-12T10:30:00Z' },
  { id: 'm2', senderName: 'Mike Chen', preview: 'Can I pre-order 5 pastry boxes for next Tuesday?', contextType: 'listing', contextTitle: 'Catering: Breakfast Pastry Box', status: 'unread', timestamp: '2026-08-12T09:15:00Z' },
  { id: 'm3', senderName: 'Elena Rodriguez', preview: 'Do you guys have oat milk available today?', contextType: 'general', status: 'replied', timestamp: '2026-08-11T14:20:00Z' },
  { id: 'm4', senderName: 'David Smith', preview: 'Hi, I run a local apiary and saw your post.', contextType: 'opportunity', contextTitle: 'Looking for Local Honey Supplier', status: 'read', timestamp: '2026-07-05T11:45:00Z' }
];
MOCK

# app.routes.ts
cat << 'ROUTES' > src/app/app.routes.ts
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
ROUTES

# UI components base
cat << 'UI_BADGE' > src/app/components/status-badge.ts
import { Component, input } from '@angular/core';

@Component({
  selector: 'app-status-badge',
  standalone: true,
  template: \`
    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium uppercase tracking-wider"
          [class]="getClasses()">
      {{ status() }}
    </span>
  \`
})
export class StatusBadge {
  status = input.required<string>();

  getClasses(): string {
    const s = this.status().toLowerCase();
    if (['active', 'in-stock', 'read'].includes(s)) return 'bg-emerald-100 text-emerald-800 border border-emerald-200';
    if (['draft', 'scheduled', 'pre-order', 'replied'].includes(s)) return 'bg-amber-100 text-amber-800 border border-amber-200';
    if (['archived', 'expired', 'closed', 'out-of-stock'].includes(s)) return 'bg-slate-100 text-slate-800 border border-slate-200';
    if (['unread'].includes(s)) return 'bg-blue-100 text-blue-800 border border-blue-200';
    return 'bg-slate-100 text-slate-800 border border-slate-200';
  }
}
UI_BADGE

cat << 'UI_METRIC' > src/app/components/metric-card.ts
import { Component, input } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-metric-card',
  standalone: true,
  imports: [MatIconModule],
  template: \`
    <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 flex flex-col hover:shadow-md transition-shadow">
      <dt class="text-sm font-medium text-slate-500 truncate mb-1">{{ label() }}</dt>
      <dd class="mt-1 text-3xl font-semibold tracking-tight text-slate-900">{{ value() }}</dd>
      @if (trend() !== undefined) {
        <div class="mt-4 flex items-center text-sm">
          @if (trend()! > 0) {
            <mat-icon class="text-emerald-500 text-sm h-4 w-4 mr-1">trending_up</mat-icon>
            <span class="text-emerald-700 font-medium">{{ trend() }}%</span>
          } @else if (trend()! < 0) {
            <mat-icon class="text-rose-500 text-sm h-4 w-4 mr-1">trending_down</mat-icon>
            <span class="text-rose-700 font-medium">{{ Math.abs(trend()!) }}%</span>
          } @else {
            <mat-icon class="text-slate-400 text-sm h-4 w-4 mr-1">trending_flat</mat-icon>
            <span class="text-slate-500 font-medium">0%</span>
          }
          <span class="text-slate-500 ml-2">vs last month</span>
        </div>
      }
    </div>
  \`
})
export class MetricCard {
  label = input.required<string>();
  value = input.required<string | number>();
  trend = input<number>();
  Math = Math;
}
UI_METRIC

cat << 'UI_EMPTY' > src/app/components/empty-state.ts
import { Component, input, output } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-empty-state',
  standalone: true,
  imports: [MatIconModule],
  template: \`
    <div class="text-center bg-white rounded-xl border border-slate-200 border-dashed p-12">
      <div class="mx-auto h-16 w-16 bg-slate-50 rounded-full flex items-center justify-center mb-4">
        <mat-icon class="text-slate-400 text-3xl">{{ icon() }}</mat-icon>
      </div>
      <h3 class="mt-2 text-lg font-semibold text-slate-900">{{ title() }}</h3>
      <p class="mt-2 text-sm text-slate-500 max-w-sm mx-auto">{{ description() }}</p>
      @if (actionLabel()) {
        <div class="mt-6">
          <button (click)="action.emit()" class="inline-flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg shadow-sm text-white bg-slate-900 hover:bg-slate-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-900 transition-colors">
            @if (actionIcon()) {
              <mat-icon class="mr-2 text-sm h-4 w-4">{{ actionIcon() }}</mat-icon>
            }
            {{ actionLabel() }}
          </button>
        </div>
      }
    </div>
  \`
})
export class EmptyState {
  icon = input<string>('inbox');
  title = input.required<string>();
  description = input.required<string>();
  actionLabel = input<string>();
  actionIcon = input<string>();
  action = output<void>();
}
UI_EMPTY

# Add initial content to layout and pages
cat << 'P_SHELL' > src/app/layout/biz-shell.ts
import { Component } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-biz-shell',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive, MatIconModule],
  template: \`
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
               routerLinkActive="bg-slate-100 text-indigo-700 font-medium"
               [routerLinkActiveOptions]="{exact: item.exact}"
               (click)="mobileMenuOpen = false"
               class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-slate-600 hover:bg-slate-50 transition-colors group">
              <mat-icon class="text-slate-400 group-hover:text-slate-600"
                        [class.!text-indigo-600]="isRouteActive(item.path, item.exact)">
                {{ item.icon }}
              </mat-icon>
              {{ item.label }}
            </a>
          }
        </nav>
        
        <div class="p-4 border-t border-slate-200">
           <a routerLink="/settings"
               routerLinkActive="bg-slate-100 text-indigo-700 font-medium"
               (click)="mobileMenuOpen = false"
               class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-slate-600 hover:bg-slate-50 transition-colors group">
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
  \`
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
P_SHELL

cat << 'P_DASH' > src/app/pages/dashboard/dashboard.component.ts
import { Component } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { RouterLink } from '@angular/router';
import { MetricCard } from '../../components/metric-card';
import { StatusBadge } from '../../components/status-badge';
import { MOCK_METRICS, MOCK_OPPORTUNITIES, MOCK_MESSAGES } from '../../core/mock-data';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [MatIconModule, RouterLink, MetricCard, StatusBadge],
  template: \`
    <div class="p-6 max-w-7xl mx-auto space-y-8">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold tracking-tight text-slate-900">Dashboard</h1>
          <p class="text-sm text-slate-500 mt-1">Welcome back. Here's what's happening with your business.</p>
        </div>
        <div class="flex items-center gap-3">
          <a routerLink="/business" class="text-sm font-medium text-slate-600 hover:text-slate-900 bg-white border border-slate-300 px-4 py-2 rounded-lg shadow-sm transition-colors">
            Edit Profile
          </a>
          <a routerLink="/listings" class="text-sm font-medium text-white bg-slate-900 hover:bg-slate-800 px-4 py-2 rounded-lg shadow-sm transition-colors flex items-center gap-2">
            <mat-icon class="text-sm h-4 w-4">add</mat-icon> Add Listing
          </a>
        </div>
      </div>

      <!-- Metrics -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        @for (metric of metrics; track metric.label) {
          <app-metric-card [label]="metric.label" [value]="metric.value" [trend]="metric.trend" />
        }
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        <!-- Left Col: Profile Completion & Messages -->
        <div class="lg:col-span-1 space-y-8">
          
          <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
            <h2 class="text-base font-semibold text-slate-900 mb-4">Profile Setup</h2>
            <div class="mb-2 flex items-center justify-between text-sm">
              <span class="font-medium text-slate-700">80% Complete</span>
              <span class="text-slate-500">4 of 5 steps</span>
            </div>
            <div class="w-full bg-slate-100 rounded-full h-2 mb-6">
              <div class="bg-emerald-500 h-2 rounded-full" style="width: 80%"></div>
            </div>
            <ul class="space-y-3 text-sm">
              <li class="flex items-start gap-2 text-slate-700">
                <mat-icon class="text-emerald-500 text-sm">check_circle</mat-icon> Add business details
              </li>
              <li class="flex items-start gap-2 text-slate-700">
                <mat-icon class="text-emerald-500 text-sm">check_circle</mat-icon> Upload logo & cover
              </li>
              <li class="flex items-start gap-2 text-slate-700">
                <mat-icon class="text-emerald-500 text-sm">check_circle</mat-icon> Add opening hours
              </li>
              <li class="flex items-start gap-2 text-slate-700">
                <mat-icon class="text-emerald-500 text-sm">check_circle</mat-icon> Create first listing
              </li>
              <li class="flex items-start gap-2 text-slate-500">
                <mat-icon class="text-slate-300 text-sm">radio_button_unchecked</mat-icon> Link social media accounts
              </li>
            </ul>
          </div>

          <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
             <div class="flex items-center justify-between mb-4">
              <h2 class="text-base font-semibold text-slate-900">Recent Messages</h2>
              <a routerLink="/messages" class="text-sm text-indigo-600 hover:text-indigo-700 font-medium">View all</a>
            </div>
            <div class="space-y-4">
              @for (msg of recentMessages; track msg.id) {
                <div class="flex gap-3 items-start border-b border-slate-100 pb-4 last:border-0 last:pb-0">
                  <div class="w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center flex-shrink-0 text-slate-600 font-medium text-xs">
                    {{ msg.senderName.charAt(0) }}
                  </div>
                  <div class="min-w-0 flex-1">
                    <p class="text-sm font-medium text-slate-900 truncate">{{ msg.senderName }}</p>
                    <p class="text-sm text-slate-500 truncate">{{ msg.preview }}</p>
                    <p class="text-xs text-slate-400 mt-1">{{ msg.timestamp | date:'shortTime' }}</p>
                  </div>
                  @if (msg.status === 'unread') {
                    <div class="w-2 h-2 rounded-full bg-blue-600 mt-2"></div>
                  }
                </div>
              }
            </div>
          </div>

        </div>

        <!-- Right Col: Active Opportunities & Activity -->
        <div class="lg:col-span-2 space-y-8">
           
           <div class="bg-white rounded-xl shadow-sm border border-slate-200">
             <div class="p-6 border-b border-slate-100 flex items-center justify-between">
              <h2 class="text-base font-semibold text-slate-900">Active Opportunities</h2>
              <a routerLink="/opportunities" class="text-sm text-indigo-600 hover:text-indigo-700 font-medium">Manage</a>
            </div>
            <div class="divide-y divide-slate-100">
              @for (opp of activeOpportunities; track opp.id) {
                <div class="p-6 flex flex-col sm:flex-row gap-4 items-start sm:items-center justify-between hover:bg-slate-50 transition-colors">
                  <div class="min-w-0 flex-1">
                    <div class="flex items-center gap-2 mb-1">
                      <span class="text-xs font-semibold uppercase tracking-wider text-indigo-600">{{ opp.type }}</span>
                      <span class="text-slate-300">•</span>
                      <span class="text-xs text-slate-500">Closes {{ opp.expiresAt | date:'mediumDate' }}</span>
                    </div>
                    <h3 class="text-base font-medium text-slate-900 truncate">{{ opp.title }}</h3>
                    <p class="text-sm text-slate-500 line-clamp-1 mt-1">{{ opp.description }}</p>
                  </div>
                  <div class="flex items-center gap-4 flex-shrink-0">
                    <div class="text-right">
                      <p class="text-xl font-semibold text-slate-900">{{ opp.interactions }}</p>
                      <p class="text-xs text-slate-500">interactions</p>
                    </div>
                    <app-status-badge [status]="opp.status" />
                  </div>
                </div>
              }
            </div>
           </div>

        </div>

      </div>
    </div>
  \`
})
export class DashboardComponent {
  metrics = MOCK_METRICS;
  activeOpportunities = MOCK_OPPORTUNITIES.filter(o => o.status === 'active' || o.status === 'scheduled').slice(0, 3);
  recentMessages = MOCK_MESSAGES.slice(0, 3);
}
P_DASH

cat << 'P_BIZ' > src/app/pages/business/business.component.ts
import { Component, signal } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MOCK_BUSINESS } from '../../core/mock-data';

@Component({
  selector: 'app-business',
  standalone: true,
  imports: [MatIconModule],
  template: \`
    <div class="p-6 max-w-5xl mx-auto space-y-8">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-2xl font-bold tracking-tight text-slate-900">Business Profile</h1>
          <p class="text-sm text-slate-500 mt-1">Manage how your business appears to customers on Oríta.</p>
        </div>
        <button class="text-sm font-medium text-white bg-slate-900 hover:bg-slate-800 px-4 py-2 rounded-lg shadow-sm transition-colors">
          Save Changes
        </button>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Left: Nav -->
        <div class="lg:col-span-1">
          <nav class="flex flex-col space-y-1">
            @for (tab of tabs; track tab.id) {
              <button (click)="activeTab.set(tab.id)"
                      [class.bg-slate-100]="activeTab() === tab.id"
                      [class.text-indigo-700]="activeTab() === tab.id"
                      [class.font-medium]="activeTab() === tab.id"
                      class="flex items-center gap-3 px-4 py-3 rounded-lg text-sm text-slate-600 hover:bg-slate-50 text-left transition-colors">
                <mat-icon [class.!text-indigo-600]="activeTab() === tab.id" class="text-slate-400">{{ tab.icon }}</mat-icon>
                {{ tab.label }}
              </button>
            }
          </nav>
        </div>

        <!-- Right: Forms -->
        <div class="lg:col-span-2">
          
          @if (activeTab() === 'basic') {
            <div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
              <!-- Cover image area -->
              <div class="h-48 relative bg-slate-200 group">
                <img [src]="biz.coverImage" alt="Cover" class="w-full h-full object-cover">
                <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                  <button class="bg-white text-slate-900 px-4 py-2 rounded-lg text-sm font-medium flex items-center gap-2">
                    <mat-icon class="text-sm">photo_camera</mat-icon> Change Cover
                  </button>
                </div>
              </div>
              <div class="p-6 sm:p-8">
                <!-- Logo -->
                <div class="relative -mt-16 mb-8 w-24 h-24 rounded-full border-4 border-white bg-slate-100 group overflow-hidden shadow-sm">
                  <img [src]="biz.logo" alt="Logo" class="w-full h-full object-cover">
                  <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center cursor-pointer">
                    <mat-icon class="text-white">edit</mat-icon>
                  </div>
                </div>

                <div class="space-y-6">
                  <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Business Name</label>
                    <input type="text" [value]="biz.name" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Category</label>
                    <select class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5 bg-white">
                      <option [selected]="biz.category === 'Food & Dining'">Food & Dining</option>
                      <option>Retail</option>
                      <option>Services</option>
                      <option>Health & Beauty</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Description</label>
                    <textarea rows="4" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">{{ biz.description }}</textarea>
                    <p class="mt-1 text-xs text-slate-500">Briefly describe what your business does. This appears on your public profile.</p>
                  </div>
                </div>
              </div>
            </div>
          }

          @if (activeTab() === 'contact') {
            <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 sm:p-8 space-y-6">
              <h2 class="text-lg font-semibold text-slate-900 mb-4">Contact Information</h2>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Email Address</label>
                <input type="email" [value]="biz.email" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Phone Number</label>
                <input type="tel" [value]="biz.phone" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">WhatsApp Business</label>
                <input type="tel" [value]="biz.phone" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">
              </div>
            </div>
          }
          
          @if (activeTab() === 'location') {
            <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 sm:p-8 space-y-6">
               <h2 class="text-lg font-semibold text-slate-900 mb-4">Location & Areas</h2>
               <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Physical Address</label>
                <textarea rows="2" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">{{ biz.address }}</textarea>
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Service Areas (Comma separated)</label>
                <input type="text" [value]="biz.serviceAreas.join(', ')" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">
              </div>
            </div>
          }

        </div>
      </div>
    </div>
  \`
})
export class BusinessComponent {
  biz = MOCK_BUSINESS;
  activeTab = signal('basic');
  tabs = [
    { id: 'basic', label: 'Basic Information', icon: 'info' },
    { id: 'contact', label: 'Contact Details', icon: 'call' },
    { id: 'location', label: 'Location & Areas', icon: 'place' },
    { id: 'hours', label: 'Opening Hours', icon: 'schedule' },
    { id: 'preview', label: 'Public Preview', icon: 'visibility' },
  ];
}
P_BIZ


#!/bin/bash
set -e

# Listings
cat << 'P_LISTINGS' > src/app/pages/listings/listings.component.ts
import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { StatusBadge } from '../../components/status-badge';
import { MOCK_LISTINGS } from '../../core/mock-data';

@Component({
  selector: 'app-listings',
  standalone: true,
  imports: [CommonModule, MatIconModule, StatusBadge],
  template: \`
    <div class="p-6 max-w-7xl mx-auto space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold tracking-tight text-slate-900">Listings</h1>
          <p class="text-sm text-slate-500 mt-1">Manage your products and services.</p>
        </div>
        <button class="text-sm font-medium text-white bg-slate-900 hover:bg-slate-800 px-4 py-2 rounded-lg shadow-sm transition-colors flex items-center gap-2">
          <mat-icon class="text-sm h-4 w-4">add</mat-icon> Add Listing
        </button>
      </div>

      <!-- Filters & Search -->
      <div class="bg-white p-4 rounded-xl shadow-sm border border-slate-200 flex flex-col sm:flex-row gap-4 items-center justify-between">
        <div class="relative w-full sm:w-96">
          <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <mat-icon class="text-slate-400 text-sm h-5 w-5">search</mat-icon>
          </div>
          <input type="text" placeholder="Search listings..." class="block w-full pl-10 pr-3 py-2 border border-slate-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm shadow-sm bg-white">
        </div>
        <div class="flex items-center gap-2 w-full sm:w-auto overflow-x-auto pb-1 sm:pb-0">
          <button (click)="filter.set('all')" [class.bg-slate-100]="filter() === 'all'" [class.text-slate-900]="filter() === 'all'" [class.text-slate-500]="filter() !== 'all'" class="px-3 py-1.5 rounded-md text-sm font-medium hover:bg-slate-50 whitespace-nowrap">All</button>
          <button (click)="filter.set('active')" [class.bg-slate-100]="filter() === 'active'" [class.text-slate-900]="filter() === 'active'" [class.text-slate-500]="filter() !== 'active'" class="px-3 py-1.5 rounded-md text-sm font-medium hover:bg-slate-50 whitespace-nowrap">Active</button>
          <button (click)="filter.set('draft')" [class.bg-slate-100]="filter() === 'draft'" [class.text-slate-900]="filter() === 'draft'" [class.text-slate-500]="filter() !== 'draft'" class="px-3 py-1.5 rounded-md text-sm font-medium hover:bg-slate-50 whitespace-nowrap">Drafts</button>
          <button (click)="filter.set('archived')" [class.bg-slate-100]="filter() === 'archived'" [class.text-slate-900]="filter() === 'archived'" [class.text-slate-500]="filter() !== 'archived'" class="px-3 py-1.5 rounded-md text-sm font-medium hover:bg-slate-50 whitespace-nowrap">Archived</button>
        </div>
      </div>

      <!-- Listings Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        @for (listing of filteredListings(); track listing.id) {
          <div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden hover:shadow-md transition-all group flex flex-col">
            <div class="relative h-48 bg-slate-100">
              <img [src]="listing.image" [alt]="listing.title" class="w-full h-full object-cover">
              <div class="absolute top-3 right-3 flex flex-col gap-2">
                <app-status-badge [status]="listing.status" />
              </div>
              <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-3">
                <button class="bg-white text-slate-900 p-2 rounded-lg hover:bg-slate-50 shadow-sm transition-colors" title="Edit">
                  <mat-icon>edit</mat-icon>
                </button>
                <button class="bg-white text-slate-900 p-2 rounded-lg hover:bg-slate-50 shadow-sm transition-colors" title="Archive">
                  <mat-icon>archive</mat-icon>
                </button>
              </div>
            </div>
            <div class="p-5 flex-1 flex flex-col">
              <div class="flex justify-between items-start mb-2">
                <h3 class="text-base font-semibold text-slate-900 line-clamp-1" [title]="listing.title">{{ listing.title }}</h3>
                <span class="text-base font-semibold text-slate-900 ml-2">\${{ listing.price.toFixed(2) }}</span>
              </div>
              <p class="text-sm text-slate-500 line-clamp-2 mb-4 flex-1">{{ listing.description }}</p>
              
              <div class="pt-4 border-t border-slate-100 flex items-center justify-between text-xs text-slate-500">
                <span class="flex items-center gap-1">
                  <mat-icon class="text-[16px] h-4 w-4">inventory_2</mat-icon> {{ listing.availability }}
                </span>
                <span class="flex items-center gap-1">
                  <mat-icon class="text-[16px] h-4 w-4">visibility</mat-icon> {{ listing.views }}
                </span>
              </div>
            </div>
          </div>
        }
      </div>
    </div>
  \`
})
export class ListingsComponent {
  listings = MOCK_LISTINGS;
  filter = signal('all');

  filteredListings() {
    if (this.filter() === 'all') return this.listings;
    return this.listings.filter(l => l.status === this.filter());
  }
}
P_LISTINGS

# Opportunities
cat << 'P_OPPS' > src/app/pages/opportunities/opportunities.component.ts
import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { StatusBadge } from '../../components/status-badge';
import { EmptyState } from '../../components/empty-state';
import { MOCK_OPPORTUNITIES } from '../../core/mock-data';

@Component({
  selector: 'app-opportunities',
  standalone: true,
  imports: [CommonModule, MatIconModule, StatusBadge, EmptyState],
  template: \`
    <div class="p-6 max-w-5xl mx-auto space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold tracking-tight text-slate-900">Opportunities</h1>
          <p class="text-sm text-slate-500 mt-1">Post temporary needs, offers, or availability.</p>
        </div>
        <button class="text-sm font-medium text-white bg-slate-900 hover:bg-slate-800 px-4 py-2 rounded-lg shadow-sm transition-colors flex items-center gap-2">
          <mat-icon class="text-sm h-4 w-4">add</mat-icon> Create Opportunity
        </button>
      </div>

      <div class="flex items-center gap-4 border-b border-slate-200">
        <button (click)="tab.set('active')" [class.border-indigo-600]="tab() === 'active'" [class.text-indigo-600]="tab() === 'active'" [class.border-transparent]="tab() !== 'active'" [class.text-slate-500]="tab() !== 'active'" class="whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm hover:text-slate-700 hover:border-slate-300">Active</button>
        <button (click)="tab.set('scheduled')" [class.border-indigo-600]="tab() === 'scheduled'" [class.text-indigo-600]="tab() === 'scheduled'" [class.border-transparent]="tab() !== 'scheduled'" [class.text-slate-500]="tab() !== 'scheduled'" class="whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm hover:text-slate-700 hover:border-slate-300">Scheduled</button>
        <button (click)="tab.set('past')" [class.border-indigo-600]="tab() === 'past'" [class.text-indigo-600]="tab() === 'past'" [class.border-transparent]="tab() !== 'past'" [class.text-slate-500]="tab() !== 'past'" class="whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm hover:text-slate-700 hover:border-slate-300">Past</button>
      </div>

      <div class="space-y-4">
        @if (filteredOpps().length === 0) {
          <app-empty-state 
            title="No opportunities found" 
            description="Create a temporary opportunity to connect with customers right now."
            actionLabel="Create Opportunity"
            actionIcon="add" />
        } @else {
          @for (opp of filteredOpps(); track opp.id) {
            <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 flex flex-col md:flex-row gap-6 items-start md:items-center justify-between hover:border-indigo-200 transition-colors group">
              <div class="flex-1 min-w-0">
                <div class="flex items-center gap-3 mb-2">
                  <app-status-badge [status]="opp.status" />
                  <span class="text-xs font-semibold text-slate-500 uppercase tracking-wider">{{ opp.type }}</span>
                </div>
                <h3 class="text-lg font-semibold text-slate-900 mb-1 truncate">{{ opp.title }}</h3>
                <p class="text-sm text-slate-600 line-clamp-2 max-w-2xl">{{ opp.description }}</p>
                <div class="mt-4 flex items-center gap-4 text-xs text-slate-500">
                  <span class="flex items-center gap-1"><mat-icon class="text-[16px] h-4 w-4">calendar_today</mat-icon> Created: {{ opp.createdAt | date:'shortDate' }}</span>
                  <span class="flex items-center gap-1"><mat-icon class="text-[16px] h-4 w-4">schedule</mat-icon> Expires: {{ opp.expiresAt | date:'short' }}</span>
                </div>
              </div>
              <div class="flex items-center gap-6 md:flex-col md:items-end w-full md:w-auto">
                <div class="text-center md:text-right">
                  <span class="block text-2xl font-semibold text-slate-900">{{ opp.interactions }}</span>
                  <span class="text-xs text-slate-500 font-medium">Interactions</span>
                </div>
                <div class="flex gap-2 ml-auto md:ml-0 opacity-0 group-hover:opacity-100 transition-opacity">
                  <button class="p-2 text-slate-400 hover:text-indigo-600 hover:bg-indigo-50 rounded-lg transition-colors" title="Edit"><mat-icon>edit</mat-icon></button>
                  <button class="p-2 text-slate-400 hover:text-slate-900 hover:bg-slate-100 rounded-lg transition-colors" title="Close early"><mat-icon>stop_circle</mat-icon></button>
                </div>
              </div>
            </div>
          }
        }
      </div>
    </div>
  \`
})
export class OpportunitiesComponent {
  opps = MOCK_OPPORTUNITIES;
  tab = signal('active');

  filteredOpps() {
    if (this.tab() === 'active') return this.opps.filter(o => o.status === 'active');
    if (this.tab() === 'scheduled') return this.opps.filter(o => o.status === 'scheduled');
    return this.opps.filter(o => o.status === 'expired' || o.status === 'closed');
  }
}
P_OPPS

# Messages
cat << 'P_MSGS' > src/app/pages/messages/messages.component.ts
import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { MOCK_MESSAGES } from '../../core/mock-data';
import { Message } from '../../core/types';

@Component({
  selector: 'app-messages',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  template: \`
    <div class="h-full flex flex-col md:flex-row bg-white overflow-hidden max-h-screen">
      <!-- Chat List Sidebar -->
      <div class="w-full md:w-80 lg:w-96 flex-shrink-0 border-r border-slate-200 flex flex-col bg-slate-50 h-[calc(100vh-65px)] md:h-screen">
        <div class="p-4 border-b border-slate-200 bg-white sticky top-0 z-10">
          <h2 class="text-xl font-bold tracking-tight text-slate-900 mb-4">Messages</h2>
          <div class="relative">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <mat-icon class="text-slate-400 text-sm h-5 w-5">search</mat-icon>
            </div>
            <input type="text" placeholder="Search conversations..." class="block w-full pl-10 pr-3 py-2 border border-slate-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm shadow-sm bg-white">
          </div>
        </div>
        
        <div class="flex-1 overflow-y-auto">
          <ul class="divide-y divide-slate-100">
            @for (msg of messages; track msg.id) {
              <li>
                <button (click)="selectMsg(msg)" [class.bg-indigo-50]="selected()?.id === msg.id" class="w-full text-left p-4 hover:bg-slate-100 transition-colors focus:outline-none flex gap-3">
                  <div class="w-10 h-10 rounded-full bg-slate-200 flex items-center justify-center flex-shrink-0 text-slate-600 font-medium">
                    {{ msg.senderName.charAt(0) }}
                  </div>
                  <div class="flex-1 min-w-0">
                    <div class="flex justify-between items-baseline mb-1">
                      <p class="text-sm font-semibold text-slate-900 truncate pr-2" [class.text-indigo-900]="msg.status === 'unread'">{{ msg.senderName }}</p>
                      <p class="text-xs text-slate-500 flex-shrink-0" [class.font-semibold]="msg.status === 'unread'">{{ msg.timestamp | date:'shortTime' }}</p>
                    </div>
                    <p class="text-sm text-slate-500 line-clamp-1" [class.font-medium]="msg.status === 'unread'" [class.text-slate-800]="msg.status === 'unread'">{{ msg.preview }}</p>
                    @if (msg.contextType !== 'general') {
                      <div class="mt-2 flex items-center gap-1 text-[10px] uppercase tracking-wider font-semibold text-indigo-600 bg-indigo-50 px-2 py-1 rounded inline-flex">
                        <mat-icon class="text-[12px] h-3 w-3">{{ msg.contextType === 'opportunity' ? 'campaign' : 'inventory_2' }}</mat-icon>
                        <span class="truncate max-w-[150px]">{{ msg.contextTitle }}</span>
                      </div>
                    }
                  </div>
                  @if (msg.status === 'unread') {
                    <div class="w-2.5 h-2.5 bg-blue-600 rounded-full mt-1.5 flex-shrink-0"></div>
                  }
                </button>
              </li>
            }
          </ul>
        </div>
      </div>

      <!-- Chat Area -->
      <div class="hidden md:flex flex-1 flex-col bg-white h-screen relative">
        @if (selected()) {
          <!-- Chat Header -->
          <div class="p-4 border-b border-slate-200 flex items-center justify-between bg-white z-10 sticky top-0">
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-slate-100 flex items-center justify-center text-slate-600 font-medium">
                {{ selected()!.senderName.charAt(0) }}
              </div>
              <div>
                <h3 class="text-base font-semibold text-slate-900">{{ selected()!.senderName }}</h3>
                <p class="text-xs text-slate-500">Local customer</p>
              </div>
            </div>
            <button class="text-slate-400 hover:text-slate-600 p-2 rounded-full hover:bg-slate-100 transition-colors">
              <mat-icon>more_vert</mat-icon>
            </button>
          </div>

          <!-- Context Banner -->
          @if (selected()!.contextType !== 'general') {
            <div class="bg-indigo-50 border-b border-indigo-100 px-6 py-3 flex items-center gap-3">
              <mat-icon class="text-indigo-600">{{ selected()!.contextType === 'opportunity' ? 'campaign' : 'inventory_2' }}</mat-icon>
              <div>
                <p class="text-xs text-indigo-800 font-medium uppercase tracking-wider">Inquiring about {{ selected()!.contextType }}</p>
                <p class="text-sm font-semibold text-indigo-900">{{ selected()!.contextTitle }}</p>
              </div>
              <button class="ml-auto text-xs font-medium text-indigo-700 bg-white px-3 py-1.5 rounded shadow-sm border border-indigo-200 hover:bg-indigo-50">View Details</button>
            </div>
          }

          <!-- Chat History -->
          <div class="flex-1 overflow-y-auto p-6 space-y-6 bg-slate-50">
            <div class="flex justify-center">
              <span class="text-xs font-medium text-slate-400 uppercase tracking-wider bg-white px-3 py-1 rounded-full shadow-sm">Today</span>
            </div>
            
            <div class="flex gap-3">
              <div class="w-8 h-8 rounded-full bg-slate-200 flex items-center justify-center flex-shrink-0 text-slate-600 text-xs font-medium">
                {{ selected()!.senderName.charAt(0) }}
              </div>
              <div class="max-w-md">
                <div class="bg-white p-3 rounded-2xl rounded-tl-none shadow-sm border border-slate-200 text-sm text-slate-800">
                  {{ selected()!.preview }}
                </div>
                <p class="text-xs text-slate-400 mt-1 ml-1">{{ selected()!.timestamp | date:'shortTime' }}</p>
              </div>
            </div>
          </div>

          <!-- Composer -->
          <div class="p-4 border-t border-slate-200 bg-white">
            <div class="flex items-end gap-2 bg-slate-50 p-2 rounded-xl border border-slate-300 focus-within:border-indigo-500 focus-within:ring-1 focus-within:ring-indigo-500 transition-shadow">
              <button class="p-2 text-slate-400 hover:text-slate-600 rounded-full transition-colors"><mat-icon>attach_file</mat-icon></button>
              <textarea rows="1" class="flex-1 bg-transparent border-0 focus:ring-0 resize-none py-2 text-sm text-slate-900 placeholder:text-slate-400 max-h-32" placeholder="Write a reply..."></textarea>
              <button class="p-2 bg-indigo-600 text-white hover:bg-indigo-700 rounded-full transition-colors flex items-center justify-center"><mat-icon class="text-sm h-5 w-5">send</mat-icon></button>
            </div>
          </div>
        } @else {
          <div class="flex-1 flex flex-col items-center justify-center text-slate-400 bg-slate-50">
            <mat-icon class="text-5xl mb-4 opacity-20">forum</mat-icon>
            <p class="text-sm font-medium">Select a conversation to start messaging</p>
          </div>
        }
      </div>
    </div>
  \`
})
export class MessagesComponent {
  messages = MOCK_MESSAGES;
  selected = signal<Message | null>(null);

  selectMsg(msg: Message) {
    this.selected.set(msg);
    msg.status = 'read';
  }
}
P_MSGS

# Analytics
cat << 'P_ANALYTICS' > src/app/pages/analytics/analytics.component.ts
import { Component } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MetricCard } from '../../components/metric-card';
import { MOCK_METRICS } from '../../core/mock-data';

@Component({
  selector: 'app-analytics',
  standalone: true,
  imports: [MatIconModule, MetricCard],
  template: \`
    <div class="p-6 max-w-7xl mx-auto space-y-8">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold tracking-tight text-slate-900">Analytics</h1>
          <p class="text-sm text-slate-500 mt-1">Understand how your business is performing on Oríta.</p>
        </div>
        <div class="flex bg-white rounded-lg p-1 shadow-sm border border-slate-200">
          <button class="px-4 py-1.5 text-sm font-medium rounded-md bg-slate-100 text-slate-900">30 days</button>
          <button class="px-4 py-1.5 text-sm font-medium rounded-md text-slate-500 hover:text-slate-900 hover:bg-slate-50">90 days</button>
          <button class="px-4 py-1.5 text-sm font-medium rounded-md text-slate-500 hover:text-slate-900 hover:bg-slate-50">12 months</button>
        </div>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        @for (metric of metrics; track metric.label) {
          <app-metric-card [label]="metric.label" [value]="metric.value" [trend]="metric.trend" />
        }
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        
        <!-- Top Listings -->
        <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
          <h2 class="text-lg font-semibold text-slate-900 mb-6">Top Performing Listings</h2>
          <div class="space-y-4">
            <div class="flex items-center gap-4">
              <span class="text-sm font-bold text-slate-400 w-4">1</span>
              <img src="https://picsum.photos/seed/l2/60/60" class="w-12 h-12 rounded-lg object-cover">
              <div class="flex-1 min-w-0">
                <h3 class="text-sm font-semibold text-slate-900 truncate">Sourdough Loaf</h3>
                <p class="text-xs text-slate-500">890 views</p>
              </div>
              <div class="text-right">
                <span class="text-sm font-semibold text-emerald-600 flex items-center"><mat-icon class="text-sm h-4 w-4 mr-1">arrow_upward</mat-icon> 24%</span>
              </div>
            </div>
            
            <div class="flex items-center gap-4">
              <span class="text-sm font-bold text-slate-400 w-4">2</span>
              <img src="https://picsum.photos/seed/l1/60/60" class="w-12 h-12 rounded-lg object-cover">
              <div class="flex-1 min-w-0">
                <h3 class="text-sm font-semibold text-slate-900 truncate">Signature Espresso Roast</h3>
                <p class="text-xs text-slate-500">342 views</p>
              </div>
              <div class="text-right">
                <span class="text-sm font-semibold text-emerald-600 flex items-center"><mat-icon class="text-sm h-4 w-4 mr-1">arrow_upward</mat-icon> 12%</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Audience -->
        <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 flex flex-col items-center justify-center min-h-[300px]">
          <mat-icon class="text-slate-300 text-5xl mb-4">pie_chart</mat-icon>
          <p class="text-slate-500 font-medium">Audience demographic data will appear here once you reach 1,000 profile views.</p>
        </div>

      </div>
    </div>
  \`
})
export class AnalyticsComponent {
  metrics = MOCK_METRICS;
}
P_ANALYTICS

# Settings
cat << 'P_SETTINGS' > src/app/pages/settings/settings.component.ts
import { Component } from '@angular/core';

@Component({
  selector: 'app-settings',
  standalone: true,
  template: \`
    <div class="p-6 max-w-4xl mx-auto space-y-8">
      <div>
        <h1 class="text-2xl font-bold tracking-tight text-slate-900">Settings</h1>
        <p class="text-sm text-slate-500 mt-1">Manage your account preferences and team.</p>
      </div>

      <div class="bg-white rounded-xl shadow-sm border border-slate-200 divide-y divide-slate-100">
        
        <div class="p-6 sm:p-8 flex flex-col md:flex-row gap-8">
          <div class="md:w-1/3">
            <h2 class="text-base font-semibold text-slate-900">Notifications</h2>
            <p class="text-sm text-slate-500 mt-1">Decide how you want to be notified about activity.</p>
          </div>
          <div class="md:w-2/3 space-y-4">
            <label class="flex items-center gap-3">
              <input type="checkbox" checked class="rounded border-slate-300 text-indigo-600 focus:ring-indigo-600 h-5 w-5">
              <span class="text-sm text-slate-700">Email notifications for new messages</span>
            </label>
            <label class="flex items-center gap-3">
              <input type="checkbox" checked class="rounded border-slate-300 text-indigo-600 focus:ring-indigo-600 h-5 w-5">
              <span class="text-sm text-slate-700">Email notifications for opportunity interactions</span>
            </label>
            <label class="flex items-center gap-3">
              <input type="checkbox" class="rounded border-slate-300 text-indigo-600 focus:ring-indigo-600 h-5 w-5">
              <span class="text-sm text-slate-700">Weekly performance report</span>
            </label>
          </div>
        </div>

        <div class="p-6 sm:p-8 flex flex-col md:flex-row gap-8">
          <div class="md:w-1/3">
            <h2 class="text-base font-semibold text-slate-900">Team Members</h2>
            <p class="text-sm text-slate-500 mt-1">Manage who has access to this business workspace.</p>
          </div>
          <div class="md:w-2/3">
            <div class="border border-slate-200 rounded-lg p-4 flex items-center justify-between mb-4 bg-slate-50">
              <div class="flex items-center gap-3">
                <div class="w-8 h-8 bg-indigo-100 text-indigo-700 rounded-full flex items-center justify-center font-bold text-sm">You</div>
                <div>
                  <p class="text-sm font-semibold text-slate-900">hello&#64;lakesidecafe.com</p>
                  <p class="text-xs text-slate-500">Owner</p>
                </div>
              </div>
            </div>
            <button class="text-sm font-medium text-indigo-600 bg-indigo-50 hover:bg-indigo-100 px-4 py-2 rounded-lg transition-colors border border-indigo-100">
              Invite Team Member
            </button>
          </div>
        </div>

      </div>
    </div>
  \`
})
export class SettingsComponent {}
P_SETTINGS


import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { RouterLink } from '@angular/router';
import { MetricCard } from '../../components/metric-card';
import { StatusBadge } from '../../components/status-badge';
import { MOCK_METRICS, MOCK_OPPORTUNITIES, MOCK_MESSAGES } from '../../core/mock-data';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, MatIconModule, RouterLink, MetricCard, StatusBadge],
  template: `
    <div class="p-6 max-w-7xl mx-auto space-y-8">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 class="text-xl font-bold text-slate-800">Dashboard</h1>
          <p class="text-sm text-slate-500 mt-1">Welcome back. Here's what's happening with your business.</p>
        </div>
        <div class="flex items-center gap-3">
          <a routerLink="/business" class="text-sm font-medium text-slate-600 hover:text-slate-900 bg-white border border-slate-300 px-4 py-2 rounded-lg shadow-sm transition-colors">
            Edit Profile
          </a>
          <a routerLink="/listings" class="bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-indigo-700 transition-colors shadow-sm flex items-center gap-2">
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
  `
})
export class DashboardComponent {
  metrics = MOCK_METRICS;
  activeOpportunities = MOCK_OPPORTUNITIES.filter(o => o.status === 'active' || o.status === 'scheduled').slice(0, 3);
  recentMessages = MOCK_MESSAGES.slice(0, 3);
}

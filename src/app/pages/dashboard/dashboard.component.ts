import { Component, inject, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { RouterLink } from '@angular/router';
import { MetricCard } from '../../components/metric-card';
import { StatusBadge } from '../../components/status-badge';
import { BusinessService } from '../../core/business.service';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  host: { class: 'flex flex-col h-full w-full overflow-hidden' },
  imports: [CommonModule, MatIconModule, RouterLink, MetricCard, StatusBadge],
  template: `
    <header class="h-16 border-b border-slate-200 bg-white flex items-center justify-between px-4 sm:px-8 shrink-0">
      <h1 class="text-xl font-bold text-slate-800">Business Overview</h1>
      <div class="flex items-center gap-3">
        <a routerLink="/opportunities" class="hidden sm:block bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-indigo-700 transition-colors shadow-sm">
          + New Opportunity
        </a>
        <a routerLink="/opportunities" class="sm:hidden w-8 h-8 rounded-full bg-indigo-600 flex items-center justify-center text-white">
          <mat-icon class="text-sm h-4 w-4">add</mat-icon>
        </a>
        <div class="w-8 h-8 rounded-full bg-slate-100 border flex items-center justify-center text-slate-400">
          <mat-icon class="text-sm h-5 w-5">notifications</mat-icon>
        </div>
      </div>
    </header>
    
    <section class="flex-1 p-4 sm:p-8 overflow-y-auto space-y-6">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        @for (metric of metrics(); track metric.label) {
          <app-metric-card [label]="metric.label" [value]="metric.value" [trend]="metric.trend"></app-metric-card>
        }
      </div>
      
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
        <div class="lg:col-span-8 bg-white border border-slate-200 rounded-xl p-6 shadow-sm flex flex-col h-full min-h-[300px]">
          <div class="flex items-center justify-between mb-6">
            <h4 class="font-bold text-slate-800">Performance Trend</h4>
            <select class="text-xs border border-slate-200 rounded px-2 py-1 bg-slate-50 outline-none">
              <option>Last 7 Days</option>
              <option>Last 30 Days</option>
            </select>
          </div>
          <div class="flex-1 flex items-end justify-between gap-2 px-2 mt-auto">
            <div class="w-full bg-indigo-100 rounded-t h-[40%]"></div>
            <div class="w-full bg-indigo-100 rounded-t h-[60%]"></div>
            <div class="w-full bg-indigo-100 rounded-t h-[75%]"></div>
            <div class="w-full bg-indigo-600 rounded-t h-full"></div>
            <div class="w-full bg-indigo-100 rounded-t h-[80%]"></div>
            <div class="w-full bg-indigo-100 rounded-t h-[30%]"></div>
            <div class="w-full bg-indigo-100 rounded-t h-[50%]"></div>
          </div>
          <div class="flex justify-between text-[10px] text-slate-400 mt-4 px-2 font-medium">
            <span>MON</span><span>TUE</span><span>WED</span><span>THU</span><span>FRI</span><span>SAT</span><span>SUN</span>
          </div>
        </div>
        
        <div class="lg:col-span-4 space-y-6 flex flex-col h-full">
          <div class="bg-indigo-900 text-white rounded-xl p-6 shadow-lg relative overflow-hidden shrink-0">
            <div class="relative z-10">
              <h4 class="text-lg font-bold mb-1">Business Health</h4>
              <p class="text-indigo-200 text-xs mb-4">Your profile is 85% complete</p>
              <div class="w-full bg-indigo-800 h-2 rounded-full mb-6">
                <div class="bg-emerald-400 h-full rounded-full w-[85%]"></div>
              </div>
              <button routerLink="/business" class="w-full py-2 bg-white/10 hover:bg-white/20 border border-white/20 rounded-lg text-sm transition-colors font-medium">
                Finish Setup
              </button>
            </div>
            <div class="absolute -right-4 -bottom-4 w-24 h-24 bg-white/5 rounded-full blur-2xl"></div>
          </div>
          
          <div class="bg-white border border-slate-200 rounded-xl p-5 shadow-sm flex-1">
            <div class="flex items-center justify-between mb-4">
              <h4 class="font-bold text-slate-800 text-sm">Recent Messages</h4>
              <a routerLink="/messages" class="text-[10px] text-indigo-600 font-semibold uppercase tracking-wider">View all</a>
            </div>
            <div class="space-y-4">
              @for (msg of recentMessages(); track msg.id) {
                <div class="flex items-start gap-3 cursor-pointer group">
                  <div class="w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center text-xs font-bold text-slate-600 shrink-0 border border-slate-200">
                    {{ msg.senderName.charAt(0) }}
                  </div>
                  <div class="flex-1 min-w-0">
                    <div class="flex justify-between items-baseline mb-0.5">
                      <p class="text-xs font-bold text-slate-700 truncate group-hover:text-indigo-600 transition-colors">{{ msg.senderName }}</p>
                      @if (msg.status === 'unread') {
                        <span class="w-2 h-2 rounded-full bg-indigo-600 shrink-0"></span>
                      }
                    </div>
                    <p class="text-[11px] text-slate-500 truncate" [class.font-medium]="msg.status === 'unread' || msg.status === 'replied'" [class.text-slate-700]="msg.status === 'unread'">{{ msg.preview }}</p>
                  </div>
                </div>
              }
              @if (recentMessages().length === 0) {
                 <div class="text-center py-4 text-xs text-slate-500">No new messages</div>
              }
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white border border-slate-200 rounded-xl p-5 shadow-sm">
        <div class="flex items-center justify-between mb-4">
          <h4 class="font-bold text-slate-800">Active Opportunities</h4>
          <a routerLink="/opportunities" class="text-xs text-indigo-600 font-semibold">View all</a>
        </div>
        <div class="flex gap-4 overflow-x-auto pb-2 -mx-5 px-5 sm:mx-0 sm:px-0">
          @for (opp of activeOpportunities(); track opp.id) {
            <div class="min-w-[280px] bg-slate-50 border border-slate-200 rounded-lg p-4 cursor-pointer hover:border-indigo-300 hover:shadow-sm transition-all group">
              <div class="flex justify-between items-start mb-2">
                <span class="text-[10px] font-bold text-indigo-700 uppercase tracking-tight bg-indigo-100 px-2 py-0.5 rounded">
                  {{ opp.type }}
                </span>
                <span class="text-[10px] text-slate-500">
                  {{ opp.status === 'active' ? 'Active' : 'Scheduled' }}
                </span>
              </div>
              <p class="text-sm font-bold text-slate-800 group-hover:text-indigo-700 transition-colors">{{ opp.title }}</p>
              <p class="text-xs text-slate-600 mt-1 line-clamp-1">{{ opp.description }}</p>
            </div>
          }
          @if (activeOpportunities().length === 0) {
             <div class="text-center py-8 w-full text-sm text-slate-500 border border-dashed border-slate-300 rounded-lg">
                No active opportunities. Create one to reach more customers!
             </div>
          }
        </div>
      </div>
    </section>
  `
})
export class DashboardComponent {
  bizSvc = inject(BusinessService);
  metrics = this.bizSvc.metrics;
  activeOpportunities = computed(() => this.bizSvc.opportunities().filter(o => o.status === 'active' || o.status === 'scheduled').slice(0, 3));
  recentMessages = computed(() => this.bizSvc.messages().slice(0, 3));
}

import { Component } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MetricCard } from '../../components/metric-card';
import { MOCK_METRICS } from '../../core/mock-data';

@Component({
  selector: 'app-analytics',
  standalone: true,
  imports: [MatIconModule, MetricCard],
  template: `
    <div class="p-6 max-w-7xl mx-auto space-y-8">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 class="text-xl font-bold text-slate-800">Analytics</h1>
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
  `
})
export class AnalyticsComponent {
  metrics = MOCK_METRICS;
}

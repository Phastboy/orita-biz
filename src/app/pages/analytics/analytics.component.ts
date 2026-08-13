import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { BusinessService } from '../../core/business.service';

@Component({
  selector: 'app-analytics',
  standalone: true,
  host: { class: 'flex flex-col h-full w-full overflow-hidden' },
  imports: [CommonModule, MatIconModule],
  template: `
    <header class="h-16 border-b border-slate-200 bg-white flex items-center justify-between px-4 sm:px-8 shrink-0">
      <h1 class="text-xl font-bold text-slate-800">Analytics</h1>
      <div class="flex bg-slate-100 rounded-lg p-1 shadow-sm border border-slate-200">
        <button class="px-3 py-1.5 text-xs font-medium rounded-md bg-white text-slate-900 shadow-sm">Overview</button>
        <button class="px-3 py-1.5 text-xs font-medium rounded-md text-slate-600 hover:text-slate-900">Listings</button>
      </div>
    </header>

    <div class="flex-1 overflow-y-auto p-4 sm:p-8">
      <div class="max-w-7xl mx-auto space-y-8">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div class="col-span-1 md:col-span-2 bg-white border border-slate-200 rounded-xl p-6 shadow-sm min-h-[300px] flex flex-col">
            <h4 class="font-bold text-slate-800 mb-6">Views Overview</h4>
            <div class="flex-1 flex items-end justify-between gap-4 px-2">
              <div class="w-full bg-indigo-100 rounded-t h-[40%]"></div>
              <div class="w-full bg-indigo-100 rounded-t h-[60%]"></div>
              <div class="w-full bg-indigo-100 rounded-t h-[75%]"></div>
              <div class="w-full bg-indigo-600 rounded-t h-full relative group cursor-pointer">
                <div class="absolute -top-10 left-1/2 -translate-x-1/2 bg-slate-900 text-white text-[10px] font-bold py-1 px-2 rounded opacity-0 group-hover:opacity-100 transition-opacity shadow-lg">452 Views</div>
              </div>
              <div class="w-full bg-indigo-100 rounded-t h-[80%]"></div>
              <div class="w-full bg-indigo-100 rounded-t h-[30%]"></div>
              <div class="w-full bg-indigo-100 rounded-t h-[50%]"></div>
            </div>
            <div class="flex justify-between text-[10px] font-bold text-slate-400 mt-4 px-2 uppercase tracking-wider">
              <span>MON</span><span>TUE</span><span>WED</span><span>THU</span><span>FRI</span><span>SAT</span><span>SUN</span>
            </div>
          </div>
          
          <div class="col-span-1 bg-white border border-slate-200 rounded-xl p-6 shadow-sm">
            <h4 class="font-bold text-slate-800 mb-6">Top Metrics</h4>
            <div class="space-y-6">
              @for (metric of bizSvc.metrics(); track metric.label) {
                <div>
                  <div class="flex justify-between items-baseline mb-1">
                    <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">{{ metric.label }}</span>
                    <span class="font-bold text-slate-900">{{ metric.value }}</span>
                  </div>
                  <div class="flex items-center gap-2">
                    <div class="h-1.5 flex-1 bg-slate-100 rounded-full overflow-hidden">
                       <div class="h-full bg-indigo-500 rounded-full" [style.width]="'75%'"></div>
                    </div>
                    <span class="text-[10px] font-bold" [class.text-emerald-600]="metric.trend > 0" [class.text-rose-500]="metric.trend < 0" [class.text-slate-400]="metric.trend === 0">
                      {{ metric.trend > 0 ? '+' : '' }}{{ metric.trend }}%
                    </span>
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
export class AnalyticsComponent {
  bizSvc = inject(BusinessService);
}

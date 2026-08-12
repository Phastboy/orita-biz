import { Component, input } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-metric-card',
  standalone: true,
  imports: [MatIconModule],
  template: `
    <div class="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex flex-col">
      <dt class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">{{ label() }}</dt>
      <dd class="text-2xl font-bold">{{ value() }}</dd>
      @if (trend() !== undefined) {
        <div class="mt-2 flex items-center text-xs font-medium">
          @if (trend()! > 0) {
            <mat-icon class="text-emerald-600 text-sm h-4 w-4 mr-1">trending_up</mat-icon>
            <span class="text-emerald-600">{{ trend() }}%</span>
          } @else if (trend()! < 0) {
            <mat-icon class="text-rose-500 text-sm h-4 w-4 mr-1">trending_down</mat-icon>
            <span class="text-rose-500">{{ Math.abs(trend()!) }}%</span>
          } @else {
            <mat-icon class="text-slate-400 text-sm h-4 w-4 mr-1">trending_flat</mat-icon>
            <span class="text-slate-500">0%</span>
          }
          <span class="text-slate-500 ml-1 font-normal">vs last month</span>
        </div>
      }
    </div>
  `
})
export class MetricCard {
  label = input.required<string>();
  value = input.required<string | number>();
  trend = input<number>();
  Math = Math;
}

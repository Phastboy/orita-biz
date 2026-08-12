import { Component, input } from '@angular/core';

@Component({
  selector: 'app-status-badge',
  standalone: true,
  template: `
    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium uppercase tracking-wider"
          [class]="getClasses()">
      {{ status() }}
    </span>
  `
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

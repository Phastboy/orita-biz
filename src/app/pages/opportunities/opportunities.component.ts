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
  template: `
    <div class="p-6 max-w-5xl mx-auto space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 class="text-xl font-bold text-slate-800">Opportunities</h1>
          <p class="text-sm text-slate-500 mt-1">Post temporary needs, offers, or availability.</p>
        </div>
        <button class="bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-indigo-700 transition-colors shadow-sm flex items-center gap-2">
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
  `
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

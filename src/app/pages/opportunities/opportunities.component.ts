import { Component, signal, inject, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { BusinessService } from '../../core/business.service';

@Component({
  selector: 'app-opportunities',
  standalone: true,
  host: { class: 'flex flex-col h-full w-full overflow-hidden' },
  imports: [CommonModule, MatIconModule],
  template: `
    <header class="h-16 border-b border-slate-200 bg-white flex items-center justify-between px-4 sm:px-8 shrink-0">
      <h1 class="text-xl font-bold text-slate-800">Opportunities</h1>
      <button class="bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-indigo-700 transition-colors shadow-sm flex items-center gap-2">
        <mat-icon class="text-sm h-4 w-4">add</mat-icon> Create Opportunity
      </button>
    </header>

    <div class="flex-1 overflow-y-auto p-4 sm:p-8">
      <div class="max-w-5xl mx-auto space-y-6">
        <div class="bg-white p-1 rounded-lg border border-slate-200 shadow-sm inline-flex">
           @for (t of tabs; track t.id) {
             <button 
               (click)="tab.set(t.id)"
               [class.bg-slate-100]="tab() === t.id"
               [class.text-slate-900]="tab() === t.id"
               [class.font-medium]="tab() === t.id"
               [class.shadow-sm]="tab() === t.id"
               [class.text-slate-500]="tab() !== t.id"
               class="px-4 py-1.5 rounded-md text-sm transition-all">
               {{ t.label }}
             </button>
           }
        </div>

        <div class="space-y-4">
          @for (opp of filteredOpps(); track opp.id) {
            <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-5 flex flex-col sm:flex-row gap-4 hover:border-indigo-300 transition-colors cursor-pointer group">
               <div class="flex-1 min-w-0">
                 <div class="flex items-center gap-2 mb-2">
                   <span class="text-[10px] font-bold text-indigo-700 uppercase tracking-tight bg-indigo-50 border border-indigo-100 px-2 py-0.5 rounded">
                     {{ opp.type }}
                   </span>
                   @if (opp.status === 'scheduled') {
                     <span class="text-[10px] font-bold text-amber-700 uppercase tracking-tight bg-amber-50 border border-amber-100 px-2 py-0.5 rounded flex items-center gap-1">
                       <mat-icon class="text-[10px] h-3 w-3">schedule</mat-icon> Scheduled
                     </span>
                   }
                   <span class="text-[10px] text-slate-500 ml-auto">Expires: {{ opp.expiresAt | date:'medium' }}</span>
                 </div>
                 <h3 class="text-base font-bold text-slate-900 mb-1 group-hover:text-indigo-600 transition-colors">{{ opp.title }}</h3>
                 <p class="text-sm text-slate-600 line-clamp-2 mb-3">{{ opp.description }}</p>
                 
                 <div class="flex items-center gap-4 text-xs font-medium text-slate-500">
                   <span class="flex items-center gap-1"><mat-icon class="text-sm h-4 w-4 text-slate-400">forum</mat-icon> {{ opp.interactions }} responses</span>
                   <span class="flex items-center gap-1"><mat-icon class="text-sm h-4 w-4 text-slate-400">calendar_today</mat-icon> Created {{ opp.createdAt | date:'shortDate' }}</span>
                 </div>
               </div>
               
               <div class="sm:border-l border-slate-100 sm:pl-4 flex sm:flex-col justify-end sm:justify-center gap-2">
                 <button class="p-2 text-slate-400 hover:text-indigo-600 hover:bg-indigo-50 rounded-lg transition-colors border border-transparent hover:border-indigo-100" title="Edit">
                    <mat-icon class="text-sm h-5 w-5">edit</mat-icon>
                 </button>
                 <button class="p-2 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg transition-colors border border-transparent hover:border-rose-100" title="Close/Delete">
                    <mat-icon class="text-sm h-5 w-5">delete_outline</mat-icon>
                 </button>
               </div>
            </div>
          }
          @if (filteredOpps().length === 0) {
            <div class="text-center py-12 text-slate-500 bg-white rounded-xl border border-dashed border-slate-300">
               <mat-icon class="text-4xl text-slate-300 mb-2">campaign</mat-icon>
               <h3 class="text-sm font-medium text-slate-900 mb-1">No opportunities found</h3>
               <p class="text-xs">You don't have any opportunities in this tab.</p>
            </div>
          }
        </div>
      </div>
    </div>
  `
})
export class OpportunitiesComponent {
  bizSvc = inject(BusinessService);
  
  tab = signal('active');
  tabs = [
    { id: 'active', label: 'Active' },
    { id: 'scheduled', label: 'Scheduled' },
    { id: 'past', label: 'Past / Closed' },
  ];

  filteredOpps = computed(() => {
    if (this.tab() === 'active') return this.bizSvc.opportunities().filter(o => o.status === 'active');
    if (this.tab() === 'scheduled') return this.bizSvc.opportunities().filter(o => o.status === 'scheduled');
    return this.bizSvc.opportunities().filter(o => o.status === 'expired' || o.status === 'closed');
  });
}

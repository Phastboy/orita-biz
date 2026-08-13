import { Component, signal, inject, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { StatusBadge } from '../../components/status-badge';
import { BusinessService } from '../../core/business.service';

@Component({
  selector: 'app-listings',
  standalone: true,
  host: { class: 'flex flex-col h-full w-full overflow-hidden' },
  imports: [CommonModule, MatIconModule, StatusBadge],
  template: `
    <header class="h-16 border-b border-slate-200 bg-white flex items-center justify-between px-4 sm:px-8 shrink-0">
      <h1 class="text-xl font-bold text-slate-800">Listings</h1>
      <button class="bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-indigo-700 transition-colors shadow-sm flex items-center gap-2">
        <mat-icon class="text-sm h-4 w-4">add</mat-icon> Add Listing
      </button>
    </header>

    <div class="flex-1 overflow-y-auto p-4 sm:p-8">
      <div class="max-w-7xl mx-auto space-y-6">
        <div class="flex flex-col sm:flex-row gap-4 items-center justify-between bg-white p-2 rounded-xl shadow-sm border border-slate-200">
          <div class="flex gap-1 w-full sm:w-auto overflow-x-auto">
            @for (f of filters; track f.id) {
              <button 
                (click)="filter.set(f.id)"
                [class.bg-slate-100]="filter() === f.id"
                [class.text-slate-900]="filter() === f.id"
                [class.font-medium]="filter() === f.id"
                [class.text-slate-600]="filter() !== f.id"
                class="px-4 py-2 rounded-lg text-sm whitespace-nowrap hover:bg-slate-50 transition-colors">
                {{ f.label }}
              </button>
            }
          </div>
          
          <div class="relative w-full sm:w-64">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <mat-icon class="text-slate-400 text-sm h-4 w-4">search</mat-icon>
            </div>
            <input type="text" placeholder="Search listings..." class="w-full pl-9 pr-3 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 transition-shadow">
          </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          @for (listing of filteredListings(); track listing.id) {
            <div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden hover:shadow-md transition-shadow group flex flex-col">
              <div class="h-48 bg-slate-100 relative">
                <img [src]="listing.image" [alt]="listing.title" class="w-full h-full object-cover">
                <div class="absolute top-3 left-3">
                  <app-status-badge [status]="listing.status"></app-status-badge>
                </div>
                <div class="absolute top-3 right-3 bg-white/90 backdrop-blur-sm px-2 py-1 rounded text-[10px] font-bold text-slate-700 uppercase tracking-wide shadow-sm">
                  {{ listing.availability }}
                </div>
              </div>
              <div class="p-4 flex-1 flex flex-col">
                <div class="flex justify-between items-start mb-1">
                  <span class="text-xs text-slate-500">{{ listing.category }}</span>
                  <span class="text-xs text-slate-400 flex items-center gap-1"><mat-icon class="text-[10px] h-3 w-3">visibility</mat-icon> {{ listing.views }}</span>
                </div>
                <h3 class="font-bold text-slate-900 text-sm mb-1 line-clamp-1 group-hover:text-indigo-600 transition-colors">{{ listing.title }}</h3>
                <p class="text-slate-500 text-xs line-clamp-2 mb-4 flex-1">{{ listing.description }}</p>
                <div class="flex items-center justify-between mt-auto">
                   <span class="font-bold text-slate-900">{{ listing.price | currency:'NGN':'symbol':'1.0-0' }}</span>
                   <button class="text-slate-400 hover:text-indigo-600 transition-colors p-1 rounded-md hover:bg-slate-50">
                     <mat-icon class="text-sm h-5 w-5">edit</mat-icon>
                   </button>
                </div>
              </div>
            </div>
          }
        </div>
      </div>
    </div>
  `
})
export class ListingsComponent {
  bizSvc = inject(BusinessService);
  
  filter = signal('all');
  filters = [
    { id: 'all', label: 'All Listings' },
    { id: 'active', label: 'Active' },
    { id: 'draft', label: 'Drafts' },
    { id: 'archived', label: 'Archived' },
  ];

  filteredListings = computed(() => {
    if (this.filter() === 'all') return this.bizSvc.listings();
    return this.bizSvc.listings().filter(l => l.status === this.filter());
  });
}

import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { StatusBadge } from '../../components/status-badge';
import { MOCK_LISTINGS } from '../../core/mock-data';

@Component({
  selector: 'app-listings',
  standalone: true,
  imports: [CommonModule, MatIconModule, StatusBadge],
  template: `
    <div class="p-6 max-w-7xl mx-auto space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 class="text-xl font-bold text-slate-800">Listings</h1>
          <p class="text-sm text-slate-500 mt-1">Manage your products and services.</p>
        </div>
        <button class="bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-indigo-700 transition-colors shadow-sm flex items-center gap-2">
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
  `
})
export class ListingsComponent {
  listings = MOCK_LISTINGS;
  filter = signal('all');

  filteredListings() {
    if (this.filter() === 'all') return this.listings;
    return this.listings.filter(l => l.status === this.filter());
  }
}

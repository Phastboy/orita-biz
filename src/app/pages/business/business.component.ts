import { Component, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { BusinessService } from '../../core/business.service';

@Component({
  selector: 'app-business',
  standalone: true,
  host: { class: 'flex flex-col h-full w-full overflow-hidden' },
  imports: [CommonModule, MatIconModule],
  template: `
    <header class="h-16 border-b border-slate-200 bg-white flex items-center justify-between px-4 sm:px-8 shrink-0">
      <h1 class="text-xl font-bold text-slate-800">Business Profile</h1>
      <button class="bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-indigo-700 transition-colors shadow-sm">
        Save Changes
      </button>
    </header>

    <div class="flex-1 overflow-y-auto p-4 sm:p-8">
      <div class="max-w-5xl mx-auto space-y-8">
        <div class="relative bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <div class="h-32 sm:h-48 bg-slate-200 relative group cursor-pointer">
            <img [src]="biz().coverImage" alt="Cover" class="w-full h-full object-cover">
            <div class="absolute inset-0 bg-slate-900/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
              <div class="bg-white/20 backdrop-blur-sm text-white px-3 py-1.5 rounded-lg flex items-center text-sm font-medium gap-2">
                <mat-icon class="text-sm h-4 w-4">photo_camera</mat-icon> Edit Cover
              </div>
            </div>
          </div>
          
          <div class="px-6 sm:px-8 pb-6">
            <div class="relative flex justify-between items-end -mt-12 sm:-mt-16 mb-4">
              <div class="relative group cursor-pointer">
                <img [src]="biz().logo" alt="Logo" class="w-24 h-24 sm:w-32 sm:h-32 rounded-xl object-cover border-4 border-white bg-white shadow-sm">
                <div class="absolute inset-0 bg-slate-900/40 opacity-0 group-hover:opacity-100 transition-opacity rounded-xl flex items-center justify-center">
                   <mat-icon class="text-white">edit</mat-icon>
                </div>
              </div>
            </div>
            
            <div>
              <h2 class="text-2xl font-bold tracking-tight text-slate-900">{{ biz().name }}</h2>
              <p class="text-sm text-slate-500 mt-1">{{ biz().category }} • {{ biz().address }}</p>
            </div>
          </div>
        </div>

        <div class="flex flex-col md:flex-row gap-8">
          <div class="w-full md:w-56 shrink-0 flex flex-row md:flex-col gap-1 overflow-x-auto pb-2 md:pb-0">
            @for (tab of tabs; track tab.id) {
              <button 
                (click)="activeTab.set(tab.id)"
                [class.bg-indigo-50]="activeTab() === tab.id"
                [class.text-indigo-700]="activeTab() === tab.id"
                [class.font-medium]="activeTab() === tab.id"
                [class.text-slate-600]="activeTab() !== tab.id"
                [class.hover:bg-slate-50]="activeTab() !== tab.id"
                class="px-4 py-2.5 rounded-lg text-sm text-left transition-colors whitespace-nowrap md:whitespace-normal">
                {{ tab.label }}
              </button>
            }
          </div>

          <div class="flex-1 min-w-0">
            @if (activeTab() === 'basic') {
              <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 sm:p-8 space-y-6">
                 <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Business Name</label>
                    <input type="text" [value]="biz().name" class="w-full px-3 py-2 bg-white border border-slate-300 rounded-lg text-sm shadow-sm focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500">
                 </div>
                 <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Description</label>
                    <textarea rows="4" class="w-full px-3 py-2 bg-white border border-slate-300 rounded-lg text-sm shadow-sm focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 resize-none">{{ biz().description }}</textarea>
                    <p class="mt-1 text-xs text-slate-500">Briefly describe what your business offers.</p>
                 </div>
                 <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Primary Category</label>
                    <select class="w-full px-3 py-2 bg-white border border-slate-300 rounded-lg text-sm shadow-sm focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500">
                      <option selected>{{ biz().category }}</option>
                      <option>Retail</option>
                      <option>Services</option>
                    </select>
                 </div>
              </div>
            }

            @if (activeTab() === 'contact') {
              <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 sm:p-8 space-y-6">
                 <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Email Address</label>
                    <input type="email" [value]="biz().email" class="w-full px-3 py-2 bg-white border border-slate-300 rounded-lg text-sm shadow-sm focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500">
                 </div>
                 <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Phone Number</label>
                    <input type="tel" [value]="biz().phone" class="w-full px-3 py-2 bg-white border border-slate-300 rounded-lg text-sm shadow-sm focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500">
                 </div>
              </div>
            }

            @if (activeTab() === 'location') {
              <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 sm:p-8 space-y-6">
                 <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Physical Address</label>
                    <input type="text" [value]="biz().address" class="w-full px-3 py-2 bg-white border border-slate-300 rounded-lg text-sm shadow-sm focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500">
                 </div>
                 <hr class="border-slate-200">
                 <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Service Areas (Neighborhoods/Regions)</label>
                    <div class="flex flex-wrap gap-2 mt-2 mb-3">
                      @for (area of biz().serviceAreas; track area) {
                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-md text-xs font-medium bg-slate-100 text-slate-700 border border-slate-200">
                          {{ area }}
                          <mat-icon class="text-xs h-3 w-3 cursor-pointer hover:text-slate-900">close</mat-icon>
                        </span>
                      }
                    </div>
                    <div class="flex gap-2">
                       <input type="text" placeholder="Add an area..." class="flex-1 px-3 py-2 bg-white border border-slate-300 rounded-lg text-sm shadow-sm focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500">
                       <button class="bg-slate-100 text-slate-700 border border-slate-200 px-4 py-2 rounded-lg text-sm font-medium hover:bg-slate-200 transition-colors">Add</button>
                    </div>
                 </div>
              </div>
            }
            
            @if (activeTab() === 'hours') {
              <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 sm:p-8 space-y-6 text-center text-slate-500">
                 <mat-icon class="text-4xl text-slate-300 mb-2">schedule</mat-icon>
                 <h2 class="text-lg font-semibold text-slate-900">Opening Hours</h2>
                 <p class="text-sm">Manage your daily opening and closing times here.</p>
              </div>
            }

            @if (activeTab() === 'preview') {
              <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 sm:p-8 space-y-6 text-center text-slate-500">
                 <mat-icon class="text-4xl text-slate-300 mb-2">visibility</mat-icon>
                 <h2 class="text-lg font-semibold text-slate-900">Public Preview</h2>
                 <p class="text-sm">See how your business appears to customers on Oríta.</p>
              </div>
            }
          </div>
        </div>
      </div>
    </div>
  `
})
export class BusinessComponent {
  bizSvc = inject(BusinessService);
  biz = this.bizSvc.currentBusiness;

  tabs = [
    { id: 'basic', label: 'Basic Information' },
    { id: 'contact', label: 'Contact Details' },
    { id: 'location', label: 'Location & Areas' },
    { id: 'hours', label: 'Opening Hours' },
    { id: 'preview', label: 'Preview Profile' },
  ];

  activeTab = signal('basic');
}

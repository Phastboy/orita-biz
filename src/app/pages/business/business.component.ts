import { Component, signal } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MOCK_BUSINESS } from '../../core/mock-data';

@Component({
  selector: 'app-business',
  standalone: true,
  imports: [MatIconModule],
  template: `
    <div class="p-6 max-w-5xl mx-auto space-y-8">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-xl font-bold text-slate-800">Business Profile</h1>
          <p class="text-sm text-slate-500 mt-1">Manage how your business appears to customers on Oríta.</p>
        </div>
        <button class="bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-indigo-700 transition-colors shadow-sm">
          Save Changes
        </button>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Left: Nav -->
        <div class="lg:col-span-1">
          <nav class="flex flex-col space-y-1">
            @for (tab of tabs; track tab.id) {
              <button (click)="activeTab.set(tab.id)"
                      [class.bg-slate-100]="activeTab() === tab.id"
                      [class.text-indigo-700]="activeTab() === tab.id"
                      [class.font-medium]="activeTab() === tab.id"
                      class="flex items-center gap-3 px-4 py-3 rounded-lg text-sm text-slate-600 hover:bg-slate-50 text-left transition-colors">
                <mat-icon [class.!text-indigo-600]="activeTab() === tab.id" class="text-slate-400">{{ tab.icon }}</mat-icon>
                {{ tab.label }}
              </button>
            }
          </nav>
        </div>

        <!-- Right: Forms -->
        <div class="lg:col-span-2">
          
          @if (activeTab() === 'basic') {
            <div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
              <!-- Cover image area -->
              <div class="h-48 relative bg-slate-200 group">
                <img [src]="biz.coverImage" alt="Cover" class="w-full h-full object-cover">
                <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                  <button class="bg-white text-slate-900 px-4 py-2 rounded-lg text-sm font-medium flex items-center gap-2">
                    <mat-icon class="text-sm">photo_camera</mat-icon> Change Cover
                  </button>
                </div>
              </div>
              <div class="p-6 sm:p-8">
                <!-- Logo -->
                <div class="relative -mt-16 mb-8 w-24 h-24 rounded-full border-4 border-white bg-slate-100 group overflow-hidden shadow-sm">
                  <img [src]="biz.logo" alt="Logo" class="w-full h-full object-cover">
                  <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center cursor-pointer">
                    <mat-icon class="text-white">edit</mat-icon>
                  </div>
                </div>

                <div class="space-y-6">
                  <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Business Name</label>
                    <input type="text" [value]="biz.name" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Category</label>
                    <select class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5 bg-white">
                      <option [selected]="biz.category === 'Food & Dining'">Food & Dining</option>
                      <option>Retail</option>
                      <option>Services</option>
                      <option>Health & Beauty</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Description</label>
                    <textarea rows="4" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">{{ biz.description }}</textarea>
                    <p class="mt-1 text-xs text-slate-500">Briefly describe what your business does. This appears on your public profile.</p>
                  </div>
                </div>
              </div>
            </div>
          }

          @if (activeTab() === 'contact') {
            <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 sm:p-8 space-y-6">
              <h2 class="text-lg font-semibold text-slate-900 mb-4">Contact Information</h2>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Email Address</label>
                <input type="email" [value]="biz.email" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Phone Number</label>
                <input type="tel" [value]="biz.phone" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">WhatsApp Business</label>
                <input type="tel" [value]="biz.phone" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">
              </div>
            </div>
          }
          
          @if (activeTab() === 'location') {
            <div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 sm:p-8 space-y-6">
               <h2 class="text-lg font-semibold text-slate-900 mb-4">Location & Areas</h2>
               <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Physical Address</label>
                <textarea rows="2" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">{{ biz.address }}</textarea>
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Service Areas (Comma separated)</label>
                <input type="text" [value]="biz.serviceAreas.join(', ')" class="w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm border p-2.5">
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
  `
})
export class BusinessComponent {
  biz = MOCK_BUSINESS;
  activeTab = signal('basic');
  tabs = [
    { id: 'basic', label: 'Basic Information', icon: 'info' },
    { id: 'contact', label: 'Contact Details', icon: 'call' },
    { id: 'location', label: 'Location & Areas', icon: 'place' },
    { id: 'hours', label: 'Opening Hours', icon: 'schedule' },
    { id: 'preview', label: 'Public Preview', icon: 'visibility' },
  ];
}

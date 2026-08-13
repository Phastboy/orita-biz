#!/bin/bash
set -e

# BizShell
cat << 'P_SHELL' > src/app/layout/biz-shell.ts
import { Component, inject } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { BusinessService } from '../core/business.service';

@Component({
  selector: 'app-biz-shell',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive, MatIconModule],
  template: `
    <div class="flex h-screen w-full bg-slate-50 font-sans overflow-hidden text-slate-900"> 
      
      <!-- Mobile sidebar toggle -->
      <div class="md:hidden absolute top-4 right-4 z-50">
        <button (click)="mobileMenuOpen = !mobileMenuOpen" class="bg-white p-2 rounded-lg shadow-sm border border-slate-200 text-slate-600 focus:outline-none">
          <mat-icon>{{ mobileMenuOpen ? 'close' : 'menu' }}</mat-icon>
        </button>
      </div>

      <aside [class.hidden]="!mobileMenuOpen && false" class="md:flex w-64 bg-white border-r border-slate-200 flex-col absolute md:relative z-40 h-full transition-transform" [class.-translate-x-full]="!mobileMenuOpen" [class.translate-x-0]="mobileMenuOpen" class="md:translate-x-0 w-64 bg-white border-r border-slate-200 flex flex-col h-full absolute md:relative z-40 transition-transform">
        <div class="p-6 flex items-center gap-3">
          <div class="w-8 h-8 bg-indigo-600 rounded-lg flex items-center justify-center text-white font-bold">O</div> 
          <span class="text-xl font-bold tracking-tight">Oríta Biz</span> 
        </div> 

        <div class="px-4 pb-4">
          <select (change)="switchBusiness($event)" class="w-full text-sm font-medium border border-slate-200 rounded-lg p-2 bg-slate-50 outline-none mb-4 focus:ring-2 focus:ring-indigo-500 text-slate-700 cursor-pointer">
            @for (b of bizSvc.businesses(); track b.id) {
              <option [value]="b.id" [selected]="b.id === bizSvc.currentBusinessId()">{{ b.name }}</option>
            }
          </select>
        </div>

        <nav class="flex-1 px-4 space-y-1 overflow-y-auto">
          @for (item of navItems; track item.path) {
            <a [routerLink]="item.path" 
               routerLinkActive="bg-indigo-50 text-indigo-700 font-medium"
               [routerLinkActiveOptions]="{exact: item.exact}"
               (click)="mobileMenuOpen = false"
               [class.text-amber-600]="item.label === 'Opportunities'"
               class="flex items-center gap-3 px-3 py-2 rounded-md text-sm text-slate-600 hover:bg-slate-50 transition-colors group">
              <mat-icon class="text-slate-400 group-hover:text-slate-600"
                        [class.!text-amber-500]="item.label === 'Opportunities'"
                        [class.!text-indigo-600]="isRouteActive(item.path, item.exact)">
                {{ item.icon }}
              </mat-icon>
              {{ item.label }}
            </a>
          }
        </nav> 
        <div class="p-4 border-t border-slate-200 mt-auto"> 
           <a routerLink="/settings"
               routerLinkActive="bg-indigo-50 text-indigo-700 font-medium"
               (click)="mobileMenuOpen = false"
               class="flex items-center gap-3 px-3 py-2 rounded-md text-sm text-slate-600 hover:bg-slate-50 transition-colors group mb-4">
              <mat-icon class="text-slate-400 group-hover:text-slate-600">settings</mat-icon>
              Settings
            </a>
          <div class="flex items-center gap-3 bg-slate-50 p-3 rounded-lg"> 
            <div class="w-10 h-10 rounded-full flex items-center justify-center overflow-hidden shrink-0 border border-slate-200"> 
              <img [src]="bizSvc.currentBusiness().logo" class="w-full h-full object-cover"> 
            </div> 
            <div class="flex-1 min-w-0"> 
              <p class="text-sm font-semibold truncate">{{ bizSvc.currentBusiness().name }}</p> 
              <p class="text-xs text-slate-500 truncate">{{ bizSvc.currentBusiness().category }}</p> 
            </div> 
          </div> 
        </div> 
      </aside> 
      <main class="flex-1 flex flex-col overflow-hidden relative"> 
        <router-outlet></router-outlet>
      </main> 
    </div>
  `
})
export class BizShell {
  bizSvc = inject(BusinessService);
  mobileMenuOpen = false;
  
  navItems = [
    { path: '/dashboard', label: 'Dashboard', icon: 'dashboard', exact: false },
    { path: '/business', label: 'Business Profile', icon: 'storefront', exact: false },
    { path: '/listings', label: 'Listings', icon: 'inventory_2', exact: false },
    { path: '/opportunities', label: 'Opportunities', icon: 'campaign', exact: false },
    { path: '/messages', label: 'Messages', icon: 'forum', exact: false },
    { path: '/analytics', label: 'Analytics', icon: 'bar_chart', exact: false },
  ];

  switchBusiness(event: any) {
    this.bizSvc.switchBusiness(event.target.value);
  }

  isRouteActive(path: string, exact: boolean) {
    return false;
  }
}
P_SHELL

# Dashboard
cat << 'P_DASH' > src/app/pages/dashboard/dashboard.component.ts
import { Component, inject, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { RouterLink } from '@angular/router';
import { MetricCard } from '../../components/metric-card';
import { StatusBadge } from '../../components/status-badge';
import { BusinessService } from '../../core/business.service';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, MatIconModule, RouterLink, MetricCard, StatusBadge],
  template: \`
    <header class="h-16 border-b border-slate-200 bg-white flex items-center justify-between px-4 sm:px-8 shrink-0">
      <h1 class="text-xl font-bold text-slate-800">Business Overview</h1>
      <div class="flex items-center gap-3">
        <a routerLink="/opportunities" class="hidden sm:block bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-indigo-700 transition-colors shadow-sm">
          + New Opportunity
        </a>
        <a routerLink="/opportunities" class="sm:hidden w-8 h-8 rounded-full bg-indigo-600 flex items-center justify-center text-white">
          <mat-icon class="text-sm h-4 w-4">add</mat-icon>
        </a>
        <div class="w-8 h-8 rounded-full bg-slate-100 border flex items-center justify-center text-slate-400">
          <mat-icon class="text-sm h-5 w-5">notifications</mat-icon>
        </div>
      </div>
    </header>
    
    <section class="flex-1 p-4 sm:p-8 overflow-y-auto space-y-6">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        @for (metric of metrics(); track metric.label) {
          <app-metric-card [label]="metric.label" [value]="metric.value" [trend]="metric.trend"></app-metric-card>
        }
      </div>
      
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
        <div class="lg:col-span-8 bg-white border border-slate-200 rounded-xl p-6 shadow-sm flex flex-col h-full min-h-[300px]">
          <div class="flex items-center justify-between mb-6">
            <h4 class="font-bold text-slate-800">Performance Trend</h4>
            <select class="text-xs border border-slate-200 rounded px-2 py-1 bg-slate-50 outline-none">
              <option>Last 7 Days</option>
              <option>Last 30 Days</option>
            </select>
          </div>
          <div class="flex-1 flex items-end justify-between gap-2 px-2 mt-auto">
            <div class="w-full bg-indigo-100 rounded-t h-[40%]"></div>
            <div class="w-full bg-indigo-100 rounded-t h-[60%]"></div>
            <div class="w-full bg-indigo-100 rounded-t h-[75%]"></div>
            <div class="w-full bg-indigo-600 rounded-t h-full"></div>
            <div class="w-full bg-indigo-100 rounded-t h-[80%]"></div>
            <div class="w-full bg-indigo-100 rounded-t h-[30%]"></div>
            <div class="w-full bg-indigo-100 rounded-t h-[50%]"></div>
          </div>
          <div class="flex justify-between text-[10px] text-slate-400 mt-4 px-2 font-medium">
            <span>MON</span><span>TUE</span><span>WED</span><span>THU</span><span>FRI</span><span>SAT</span><span>SUN</span>
          </div>
        </div>
        
        <div class="lg:col-span-4 space-y-6 flex flex-col h-full">
          <div class="bg-indigo-900 text-white rounded-xl p-6 shadow-lg relative overflow-hidden shrink-0">
            <div class="relative z-10">
              <h4 class="text-lg font-bold mb-1">Business Health</h4>
              <p class="text-indigo-200 text-xs mb-4">Your profile is 85% complete</p>
              <div class="w-full bg-indigo-800 h-2 rounded-full mb-6">
                <div class="bg-emerald-400 h-full rounded-full w-[85%]"></div>
              </div>
              <button routerLink="/business" class="w-full py-2 bg-white/10 hover:bg-white/20 border border-white/20 rounded-lg text-sm transition-colors font-medium">
                Finish Setup
              </button>
            </div>
            <div class="absolute -right-4 -bottom-4 w-24 h-24 bg-white/5 rounded-full blur-2xl"></div>
          </div>
          
          <div class="bg-white border border-slate-200 rounded-xl p-5 shadow-sm flex-1">
            <div class="flex items-center justify-between mb-4">
              <h4 class="font-bold text-slate-800 text-sm">Recent Messages</h4>
              <a routerLink="/messages" class="text-[10px] text-indigo-600 font-semibold uppercase tracking-wider">View all</a>
            </div>
            <div class="space-y-4">
              @for (msg of recentMessages(); track msg.id) {
                <div class="flex items-start gap-3 cursor-pointer group">
                  <div class="w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center text-xs font-bold text-slate-600 shrink-0 border border-slate-200">
                    {{ msg.senderName.charAt(0) }}
                  </div>
                  <div class="flex-1 min-w-0">
                    <div class="flex justify-between items-baseline mb-0.5">
                      <p class="text-xs font-bold text-slate-700 truncate group-hover:text-indigo-600 transition-colors">{{ msg.senderName }}</p>
                      @if (msg.status === 'unread') {
                        <span class="w-2 h-2 rounded-full bg-indigo-600 shrink-0"></span>
                      }
                    </div>
                    <p class="text-[11px] text-slate-500 truncate" [class.font-medium]="msg.status === 'unread' || msg.status === 'replied'" [class.text-slate-700]="msg.status === 'unread'">{{ msg.preview }}</p>
                  </div>
                </div>
              }
              @if (recentMessages().length === 0) {
                 <div class="text-center py-4 text-xs text-slate-500">No new messages</div>
              }
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white border border-slate-200 rounded-xl p-5 shadow-sm">
        <div class="flex items-center justify-between mb-4">
          <h4 class="font-bold text-slate-800">Active Opportunities</h4>
          <a routerLink="/opportunities" class="text-xs text-indigo-600 font-semibold">View all</a>
        </div>
        <div class="flex gap-4 overflow-x-auto pb-2 -mx-5 px-5 sm:mx-0 sm:px-0">
          @for (opp of activeOpportunities(); track opp.id) {
            <div class="min-w-[280px] bg-slate-50 border border-slate-200 rounded-lg p-4 cursor-pointer hover:border-indigo-300 hover:shadow-sm transition-all group">
              <div class="flex justify-between items-start mb-2">
                <span class="text-[10px] font-bold text-indigo-700 uppercase tracking-tight bg-indigo-100 px-2 py-0.5 rounded">
                  {{ opp.type }}
                </span>
                <span class="text-[10px] text-slate-500">
                  {{ opp.status === 'active' ? 'Active' : 'Scheduled' }}
                </span>
              </div>
              <p class="text-sm font-bold text-slate-800 group-hover:text-indigo-700 transition-colors">{{ opp.title }}</p>
              <p class="text-xs text-slate-600 mt-1 line-clamp-1">{{ opp.description }}</p>
            </div>
          }
          @if (activeOpportunities().length === 0) {
             <div class="text-center py-8 w-full text-sm text-slate-500 border border-dashed border-slate-300 rounded-lg">
                No active opportunities. Create one to reach more customers!
             </div>
          }
        </div>
      </div>
    </section>
  \`
})
export class DashboardComponent {
  bizSvc = inject(BusinessService);
  metrics = this.bizSvc.metrics;
  activeOpportunities = computed(() => this.bizSvc.opportunities().filter(o => o.status === 'active' || o.status === 'scheduled').slice(0, 3));
  recentMessages = computed(() => this.bizSvc.messages().slice(0, 3));
}
P_DASH

# Business Profile
cat << 'P_BIZ' > src/app/pages/business/business.component.ts
import { Component, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { BusinessService } from '../../core/business.service';

@Component({
  selector: 'app-business',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  template: \`
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
  \`
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
P_BIZ

# Listings
cat << 'P_LIST' > src/app/pages/listings/listings.component.ts
import { Component, signal, inject, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { StatusBadge } from '../../components/status-badge';
import { BusinessService } from '../../core/business.service';

@Component({
  selector: 'app-listings',
  standalone: true,
  imports: [CommonModule, MatIconModule, StatusBadge],
  template: \`
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
  \`
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
P_LIST

# Opportunities
cat << 'P_OPP' > src/app/pages/opportunities/opportunities.component.ts
import { Component, signal, inject, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { BusinessService } from '../../core/business.service';

@Component({
  selector: 'app-opportunities',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  template: \`
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
  \`
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
P_OPP

# Messages
cat << 'P_MSG' > src/app/pages/messages/messages.component.ts
import { Component, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { Message } from '../../core/types';
import { BusinessService } from '../../core/business.service';

@Component({
  selector: 'app-messages',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  template: \`
    <div class="flex h-full bg-white overflow-hidden">
      <!-- Chat List Sidebar -->
      <div class="w-full md:w-80 lg:w-96 flex-shrink-0 border-r border-slate-200 flex flex-col bg-slate-50 h-full">
        <div class="p-4 border-b border-slate-200 bg-white shrink-0">
          <h2 class="text-xl font-bold text-slate-800 mb-4">Messages</h2>
          <div class="relative">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <mat-icon class="text-slate-400 text-sm h-5 w-5">search</mat-icon>
            </div>
            <input type="text" placeholder="Search conversations..." class="w-full pl-9 pr-3 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 transition-shadow">
          </div>
        </div>
        
        <div class="flex-1 overflow-y-auto">
          @for (msg of bizSvc.messages(); track msg.id) {
            <div (click)="selectMsg(msg)"
                 class="p-4 border-b border-slate-100 cursor-pointer transition-colors relative"
                 [class.bg-white]="selected()?.id === msg.id"
                 [class.hover:bg-slate-100]="selected()?.id !== msg.id">
              
              @if (selected()?.id === msg.id) {
                <div class="absolute left-0 top-0 bottom-0 w-1 bg-indigo-600"></div>
              }
              
              <div class="flex justify-between items-baseline mb-1">
                <span class="font-bold text-sm text-slate-900 truncate" [class.text-indigo-900]="msg.status === 'unread'">{{ msg.senderName }}</span>
                <span class="text-[10px] font-medium text-slate-400 shrink-0 ml-2" [class.text-indigo-600]="msg.status === 'unread'">{{ msg.timestamp | date:'shortTime' }}</span>
              </div>
              
              @if (msg.contextType !== 'general') {
                <div class="mb-1.5 flex items-center gap-1 text-[10px] font-bold uppercase tracking-wider text-slate-500">
                  <mat-icon class="text-[10px] h-3 w-3">{{ msg.contextType === 'listing' ? 'inventory_2' : 'campaign' }}</mat-icon>
                  <span class="truncate">{{ msg.contextTitle }}</span>
                </div>
              }
              
              <div class="flex items-center gap-2">
                <p class="text-xs text-slate-500 line-clamp-2 flex-1" [class.font-medium]="msg.status === 'unread'" [class.text-slate-700]="msg.status === 'unread'">
                  {{ msg.preview }}
                </p>
                @if (msg.status === 'unread') {
                  <span class="w-2.5 h-2.5 rounded-full bg-indigo-600 shrink-0"></span>
                }
              </div>
            </div>
          }
        </div>
      </div>

      <!-- Active Chat Area -->
      <div class="hidden md:flex flex-1 flex-col bg-white h-full relative">
        @if (selected()) {
          <!-- Chat Header -->
          <div class="h-16 border-b border-slate-200 px-6 flex items-center justify-between bg-white shrink-0">
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-slate-100 border border-slate-200 flex items-center justify-center text-slate-600 font-bold">
                {{ selected()!.senderName.charAt(0) }}
              </div>
              <div>
                <h3 class="font-bold text-slate-900 text-sm">{{ selected()!.senderName }}</h3>
                <p class="text-xs text-slate-500">Customer</p>
              </div>
            </div>
            <div class="flex items-center gap-2">
              <button class="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-50 rounded-full transition-colors"><mat-icon class="text-sm h-5 w-5">more_vert</mat-icon></button>
            </div>
          </div>
          
          <!-- Context Banner -->
          @if (selected()!.contextType !== 'general') {
            <div class="bg-indigo-50 border-b border-indigo-100 p-3 px-6 shrink-0 flex items-center justify-between">
               <div class="flex items-center gap-2">
                 <div class="w-8 h-8 rounded bg-white shadow-sm border border-indigo-100 flex items-center justify-center text-indigo-500">
                   <mat-icon class="text-sm h-4 w-4">{{ selected()!.contextType === 'listing' ? 'inventory_2' : 'campaign' }}</mat-icon>
                 </div>
                 <div>
                   <p class="text-[10px] font-bold text-indigo-500 uppercase tracking-wider">Inquiring about {{ selected()!.contextType }}</p>
                   <p class="text-sm font-medium text-slate-800">{{ selected()!.contextTitle }}</p>
                 </div>
               </div>
               <button class="text-xs font-medium text-indigo-600 bg-white border border-indigo-200 px-3 py-1.5 rounded shadow-sm hover:bg-indigo-50 transition-colors">View Details</button>
            </div>
          }

          <!-- Chat History -->
          <div class="flex-1 overflow-y-auto p-6 space-y-6 bg-slate-50/50">
            <!-- Simulated Message Bubble -->
            <div class="flex items-end gap-2">
              <div class="w-8 h-8 rounded-full bg-slate-200 shrink-0"></div>
              <div class="bg-white border border-slate-200 p-3 px-4 rounded-2xl rounded-bl-sm shadow-sm max-w-[75%]">
                <p class="text-sm text-slate-700">{{ selected()!.preview }}</p>
                <p class="text-[10px] text-slate-400 mt-1 text-right">{{ selected()!.timestamp | date:'shortTime' }}</p>
              </div>
            </div>
          </div>
          
          <!-- Message Input -->
          <div class="p-4 bg-white border-t border-slate-200 shrink-0">
            <div class="flex items-end gap-2 bg-slate-50 border border-slate-200 rounded-xl p-2 focus-within:ring-1 focus-within:ring-indigo-500 focus-within:border-indigo-500 transition-shadow">
              <button class="p-2 text-slate-400 hover:text-slate-600 transition-colors shrink-0"><mat-icon class="text-sm h-5 w-5">attach_file</mat-icon></button>
              <textarea 
                rows="1" 
                placeholder="Type your message..." 
                class="flex-1 bg-transparent border-none focus:ring-0 text-sm py-2 px-1 resize-none outline-none text-slate-700 max-h-32 min-h-[40px]"></textarea>
              <button class="p-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors shrink-0 shadow-sm"><mat-icon class="text-sm h-5 w-5">send</mat-icon></button>
            </div>
          </div>
        } @else {
          <div class="flex-1 flex flex-col items-center justify-center text-slate-400 bg-slate-50/50">
            <div class="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mb-4 border border-slate-200 shadow-sm">
              <mat-icon class="text-3xl">forum</mat-icon>
            </div>
            <h3 class="text-lg font-medium text-slate-900 mb-1">Your Messages</h3>
            <p class="text-sm">Select a conversation to start chatting.</p>
          </div>
        }
      </div>
    </div>
  \`
})
export class MessagesComponent {
  bizSvc = inject(BusinessService);
  selected = signal<Message | null>(null);

  selectMsg(msg: Message) {
    this.selected.set(msg);
    msg.status = 'read';
  }
}
P_MSG

# Analytics
cat << 'P_ANALYTICS' > src/app/pages/analytics/analytics.component.ts
import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { BusinessService } from '../../core/business.service';

@Component({
  selector: 'app-analytics',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  template: \`
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
  \`
})
export class AnalyticsComponent {
  bizSvc = inject(BusinessService);
}
P_ANALYTICS


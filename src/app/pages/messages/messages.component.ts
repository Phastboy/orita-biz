import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { MOCK_MESSAGES } from '../../core/mock-data';
import { Message } from '../../core/types';

@Component({
  selector: 'app-messages',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  template: `
    <div class="h-full flex flex-col md:flex-row bg-white overflow-hidden max-h-screen">
      <!-- Chat List Sidebar -->
      <div class="w-full md:w-80 lg:w-96 flex-shrink-0 border-r border-slate-200 flex flex-col bg-slate-50 h-[calc(100vh-65px)] md:h-screen">
        <div class="p-4 border-b border-slate-200 bg-white sticky top-0 z-10">
          <h2 class="text-xl font-bold text-slate-800 mb-4">Messages</h2>
          <div class="relative">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <mat-icon class="text-slate-400 text-sm h-5 w-5">search</mat-icon>
            </div>
            <input type="text" placeholder="Search conversations..." class="block w-full pl-10 pr-3 py-2 border border-slate-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm shadow-sm bg-white">
          </div>
        </div>
        
        <div class="flex-1 overflow-y-auto">
          <ul class="divide-y divide-slate-100">
            @for (msg of messages; track msg.id) {
              <li>
                <button (click)="selectMsg(msg)" [class.bg-indigo-50]="selected()?.id === msg.id" class="w-full text-left p-4 hover:bg-slate-100 transition-colors focus:outline-none flex gap-3">
                  <div class="w-10 h-10 rounded-full bg-slate-200 flex items-center justify-center flex-shrink-0 text-slate-600 font-medium">
                    {{ msg.senderName.charAt(0) }}
                  </div>
                  <div class="flex-1 min-w-0">
                    <div class="flex justify-between items-baseline mb-1">
                      <p class="text-sm font-semibold text-slate-900 truncate pr-2" [class.text-indigo-900]="msg.status === 'unread'">{{ msg.senderName }}</p>
                      <p class="text-xs text-slate-500 flex-shrink-0" [class.font-semibold]="msg.status === 'unread'">{{ msg.timestamp | date:'shortTime' }}</p>
                    </div>
                    <p class="text-sm text-slate-500 line-clamp-1" [class.font-medium]="msg.status === 'unread'" [class.text-slate-800]="msg.status === 'unread'">{{ msg.preview }}</p>
                    @if (msg.contextType !== 'general') {
                      <div class="mt-2 flex items-center gap-1 text-[10px] uppercase tracking-wider font-semibold text-indigo-600 bg-indigo-50 px-2 py-1 rounded inline-flex">
                        <mat-icon class="text-[12px] h-3 w-3">{{ msg.contextType === 'opportunity' ? 'campaign' : 'inventory_2' }}</mat-icon>
                        <span class="truncate max-w-[150px]">{{ msg.contextTitle }}</span>
                      </div>
                    }
                  </div>
                  @if (msg.status === 'unread') {
                    <div class="w-2.5 h-2.5 bg-blue-600 rounded-full mt-1.5 flex-shrink-0"></div>
                  }
                </button>
              </li>
            }
          </ul>
        </div>
      </div>

      <!-- Chat Area -->
      <div class="hidden md:flex flex-1 flex-col bg-white h-screen relative">
        @if (selected()) {
          <!-- Chat Header -->
          <div class="p-4 border-b border-slate-200 flex items-center justify-between bg-white z-10 sticky top-0">
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-slate-100 flex items-center justify-center text-slate-600 font-medium">
                {{ selected()!.senderName.charAt(0) }}
              </div>
              <div>
                <h3 class="text-base font-semibold text-slate-900">{{ selected()!.senderName }}</h3>
                <p class="text-xs text-slate-500">Local customer</p>
              </div>
            </div>
            <button class="text-slate-400 hover:text-slate-600 p-2 rounded-full hover:bg-slate-100 transition-colors">
              <mat-icon>more_vert</mat-icon>
            </button>
          </div>

          <!-- Context Banner -->
          @if (selected()!.contextType !== 'general') {
            <div class="bg-indigo-50 border-b border-indigo-100 px-6 py-3 flex items-center gap-3">
              <mat-icon class="text-indigo-600">{{ selected()!.contextType === 'opportunity' ? 'campaign' : 'inventory_2' }}</mat-icon>
              <div>
                <p class="text-xs text-indigo-800 font-medium uppercase tracking-wider">Inquiring about {{ selected()!.contextType }}</p>
                <p class="text-sm font-semibold text-indigo-900">{{ selected()!.contextTitle }}</p>
              </div>
              <button class="ml-auto text-xs font-medium text-indigo-700 bg-white px-3 py-1.5 rounded shadow-sm border border-indigo-200 hover:bg-indigo-50">View Details</button>
            </div>
          }

          <!-- Chat History -->
          <div class="flex-1 overflow-y-auto p-6 space-y-6 bg-slate-50">
            <div class="flex justify-center">
              <span class="text-xs font-medium text-slate-400 uppercase tracking-wider bg-white px-3 py-1 rounded-full shadow-sm">Today</span>
            </div>
            
            <div class="flex gap-3">
              <div class="w-8 h-8 rounded-full bg-slate-200 flex items-center justify-center flex-shrink-0 text-slate-600 text-xs font-medium">
                {{ selected()!.senderName.charAt(0) }}
              </div>
              <div class="max-w-md">
                <div class="bg-white p-3 rounded-2xl rounded-tl-none shadow-sm border border-slate-200 text-sm text-slate-800">
                  {{ selected()!.preview }}
                </div>
                <p class="text-xs text-slate-400 mt-1 ml-1">{{ selected()!.timestamp | date:'shortTime' }}</p>
              </div>
            </div>
          </div>

          <!-- Composer -->
          <div class="p-4 border-t border-slate-200 bg-white">
            <div class="flex items-end gap-2 bg-slate-50 p-2 rounded-xl border border-slate-300 focus-within:border-indigo-500 focus-within:ring-1 focus-within:ring-indigo-500 transition-shadow">
              <button class="p-2 text-slate-400 hover:text-slate-600 rounded-full transition-colors"><mat-icon>attach_file</mat-icon></button>
              <textarea rows="1" class="flex-1 bg-transparent border-0 focus:ring-0 resize-none py-2 text-sm text-slate-900 placeholder:text-slate-400 max-h-32" placeholder="Write a reply..."></textarea>
              <button class="p-2 bg-indigo-600 text-white hover:bg-indigo-700 rounded-full transition-colors flex items-center justify-center"><mat-icon class="text-sm h-5 w-5">send</mat-icon></button>
            </div>
          </div>
        } @else {
          <div class="flex-1 flex flex-col items-center justify-center text-slate-400 bg-slate-50">
            <mat-icon class="text-5xl mb-4 opacity-20">forum</mat-icon>
            <p class="text-sm font-medium">Select a conversation to start messaging</p>
          </div>
        }
      </div>
    </div>
  `
})
export class MessagesComponent {
  messages = MOCK_MESSAGES;
  selected = signal<Message | null>(null);

  selectMsg(msg: Message) {
    this.selected.set(msg);
    msg.status = 'read';
  }
}

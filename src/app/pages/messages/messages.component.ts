import { Component, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { Message } from '../../core/types';
import { BusinessService } from '../../core/business.service';

@Component({
  selector: 'app-messages',
  standalone: true,
  host: { class: 'flex flex-col h-full w-full overflow-hidden' },
  imports: [CommonModule, MatIconModule],
  template: `
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
  `
})
export class MessagesComponent {
  bizSvc = inject(BusinessService);
  selected = signal<Message | null>(null);

  selectMsg(msg: Message) {
    this.selected.set(msg);
    msg.status = 'read';
  }
}

import { Component } from '@angular/core';

@Component({
  selector: 'app-settings',
  standalone: true,
  host: { class: 'flex flex-col h-full w-full overflow-y-auto' },
  template: `
    <div class="p-6 max-w-4xl mx-auto space-y-8">
      <div>
        <h1 class="text-xl font-bold text-slate-800">Settings</h1>
        <p class="text-sm text-slate-500 mt-1">Manage your account preferences and team.</p>
      </div>

      <div class="bg-white rounded-xl shadow-sm border border-slate-200 divide-y divide-slate-100">
        
        <div class="p-6 sm:p-8 flex flex-col md:flex-row gap-8">
          <div class="md:w-1/3">
            <h2 class="text-base font-semibold text-slate-900">Notifications</h2>
            <p class="text-sm text-slate-500 mt-1">Decide how you want to be notified about activity.</p>
          </div>
          <div class="md:w-2/3 space-y-4">
            <label class="flex items-center gap-3">
              <input type="checkbox" checked class="rounded border-slate-300 text-indigo-600 focus:ring-indigo-600 h-5 w-5">
              <span class="text-sm text-slate-700">Email notifications for new messages</span>
            </label>
            <label class="flex items-center gap-3">
              <input type="checkbox" checked class="rounded border-slate-300 text-indigo-600 focus:ring-indigo-600 h-5 w-5">
              <span class="text-sm text-slate-700">Email notifications for opportunity interactions</span>
            </label>
            <label class="flex items-center gap-3">
              <input type="checkbox" class="rounded border-slate-300 text-indigo-600 focus:ring-indigo-600 h-5 w-5">
              <span class="text-sm text-slate-700">Weekly performance report</span>
            </label>
          </div>
        </div>

        <div class="p-6 sm:p-8 flex flex-col md:flex-row gap-8">
          <div class="md:w-1/3">
            <h2 class="text-base font-semibold text-slate-900">Team Members</h2>
            <p class="text-sm text-slate-500 mt-1">Manage who has access to this business workspace.</p>
          </div>
          <div class="md:w-2/3">
            <div class="border border-slate-200 rounded-lg p-4 flex items-center justify-between mb-4 bg-slate-50">
              <div class="flex items-center gap-3">
                <div class="w-8 h-8 bg-indigo-100 text-indigo-700 rounded-full flex items-center justify-center font-bold text-sm">You</div>
                <div>
                  <p class="text-sm font-semibold text-slate-900">hello&#64;lakesidecafe.com</p>
                  <p class="text-xs text-slate-500">Owner</p>
                </div>
              </div>
            </div>
            <button class="text-sm font-medium text-indigo-600 bg-indigo-50 hover:bg-indigo-100 px-4 py-2 rounded-lg transition-colors border border-indigo-100">
              Invite Team Member
            </button>
          </div>
        </div>

      </div>
    </div>
  `
})
export class SettingsComponent {}

import { Component, input, output } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-empty-state',
  standalone: true,
  imports: [MatIconModule],
  template: `
    <div class="text-center bg-white rounded-xl border border-slate-200 border-dashed p-12">
      <div class="mx-auto h-16 w-16 bg-slate-50 rounded-full flex items-center justify-center mb-4">
        <mat-icon class="text-slate-400 text-3xl">{{ icon() }}</mat-icon>
      </div>
      <h3 class="mt-2 text-lg font-semibold text-slate-900">{{ title() }}</h3>
      <p class="mt-2 text-sm text-slate-500 max-w-sm mx-auto">{{ description() }}</p>
      @if (actionLabel()) {
        <div class="mt-6">
          <button (click)="action.emit()" class="inline-flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg shadow-sm text-white bg-slate-900 hover:bg-slate-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-900 transition-colors">
            @if (actionIcon()) {
              <mat-icon class="mr-2 text-sm h-4 w-4">{{ actionIcon() }}</mat-icon>
            }
            {{ actionLabel() }}
          </button>
        </div>
      }
    </div>
  `
})
export class EmptyState {
  icon = input<string>('inbox');
  title = input.required<string>();
  description = input.required<string>();
  actionLabel = input<string>();
  actionIcon = input<string>();
  action = output<void>();
}

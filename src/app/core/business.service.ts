import { Injectable, signal, computed } from '@angular/core';
import { MOCK_BUSINESSES, MOCK_LISTINGS, MOCK_OPPORTUNITIES, MOCK_MESSAGES, MOCK_METRICS } from './mock-data';

@Injectable({ providedIn: 'root' })
export class BusinessService {
  currentBusinessId = signal<string>('b2');

  businesses = signal(MOCK_BUSINESSES);
  
  currentBusiness = computed(() => this.businesses().find(b => b.id === this.currentBusinessId())!);
  metrics = computed(() => MOCK_METRICS.filter(m => m.businessId === this.currentBusinessId()));
  listings = computed(() => MOCK_LISTINGS.filter(l => l.businessId === this.currentBusinessId()));
  opportunities = computed(() => MOCK_OPPORTUNITIES.filter(o => o.businessId === this.currentBusinessId()));
  messages = computed(() => MOCK_MESSAGES.filter(m => m.businessId === this.currentBusinessId()));

  switchBusiness(id: string) {
    this.currentBusinessId.set(id);
  }
}

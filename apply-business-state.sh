#!/bin/bash
set -e

# 1. Update Types
cat << 'TYPES' > src/app/core/types.ts
export type ListingStatus = 'active' | 'draft' | 'archived';
export type OpportunityStatus = 'active' | 'scheduled' | 'expired' | 'closed';
export type MessageStatus = 'unread' | 'read' | 'replied';

export interface Business {
  id: string;
  name: string;
  description: string;
  logo: string;
  coverImage: string;
  category: string;
  email: string;
  phone: string;
  address: string;
  openingHours: string;
  serviceAreas: string[];
}

export interface Listing {
  id: string;
  businessId: string;
  title: string;
  description: string;
  price: number;
  status: ListingStatus;
  availability: 'in-stock' | 'out-of-stock' | 'pre-order';
  image: string;
  category: string;
  views: number;
}

export interface Opportunity {
  id: string;
  businessId: string;
  title: string;
  type: string;
  description: string;
  status: OpportunityStatus;
  createdAt: string;
  expiresAt: string;
  interactions: number;
}

export interface Message {
  id: string;
  businessId: string;
  senderName: string;
  preview: string;
  contextType: 'listing' | 'opportunity' | 'general';
  contextTitle?: string;
  status: MessageStatus;
  timestamp: string;
}

export interface Metric {
  businessId: string;
  label: string;
  value: string | number;
  trend: number;
}
TYPES

# 2. Update Mock Data
cat << 'MOCK' > src/app/core/mock-data.ts
import { Business, Listing, Opportunity, Message, Metric } from './types';

export const MOCK_BUSINESSES: Business[] = [
  {
    id: 'b1',
    name: 'Lakeside Cafe (Standard)',
    description: 'A simple local cafe & bakery.',
    logo: 'https://picsum.photos/seed/bizlogo/200/200',
    coverImage: 'https://picsum.photos/seed/bizcover/1200/400',
    category: 'Food & Dining',
    email: 'hello@lakesidecafe.com',
    phone: '(555) 123-4567',
    address: '123 Main St, Springfield',
    openingHours: 'Mon-Sat: 7am - 6pm',
    serviceAreas: ['Springfield']
  },
  {
    id: 'b2',
    name: 'Campus FreshPack',
    description: 'Cleaned, measured, and packaged farm produce and foodstuff. Reliable home & hostel delivery with fixed windows.',
    logo: 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&q=80&w=200&h=200',
    coverImage: 'https://images.unsplash.com/photo-1608686207856-001b95cf60ca?auto=format&fit=crop&q=80&w=1200&h=400',
    category: 'Groceries & Produce',
    email: 'orders@campusfreshpack.com',
    phone: '+234 800 123 4567',
    address: 'Shop 4, Mayfair Commercial Center, Ile-Ife',
    openingHours: 'Mon-Sat: 8am - 7pm',
    serviceAreas: ['OAU Campus', 'Maintenance Hostel', 'Asherifa', 'Parakin', 'Modakeke']
  }
];

export const MOCK_METRICS: Metric[] = [
  { businessId: 'b1', label: 'Profile Views', value: '148', trend: 2.5 },
  { businessId: 'b1', label: 'Listing Views', value: '342', trend: 1.2 },
  { businessId: 'b1', label: 'Contact Clicks', value: '15', trend: -1.4 },
  { businessId: 'b1', label: 'Messages', value: '4', trend: 0 },
  
  { businessId: 'b2', label: 'Profile Views', value: '3,248', trend: 24.5 },
  { businessId: 'b2', label: 'Listing Views', value: '12,842', trend: 18.2 },
  { businessId: 'b2', label: 'Basket Subscriptions', value: '156', trend: 12.4 },
  { businessId: 'b2', label: 'Messages', value: '142', trend: 32.0 }
];

export const MOCK_LISTINGS: Listing[] = [
  { id: 'l1', businessId: 'b1', title: 'Espresso Roast', description: 'Simple coffee beans', price: 18.00, status: 'active', availability: 'in-stock', image: 'https://picsum.photos/seed/l1/300/300', category: 'Coffee', views: 342 },
  { id: 'l2', businessId: 'b1', title: 'Sourdough Loaf', description: 'Fresh bread', price: 8.50, status: 'active', availability: 'in-stock', image: 'https://picsum.photos/seed/l2/300/300', category: 'Bakery', views: 120 },
  
  { id: 'l3', businessId: 'b2', title: 'Student Weekend Soup Bundle', description: 'Perfect for a weekend. Includes pre-cut beef, blended pepper mix, palm oil, and cleaned vegetables.', price: 4500, status: 'active', availability: 'pre-order', image: 'https://images.unsplash.com/photo-1596649282367-e9a0346a0d4c?auto=format&fit=crop&q=80&w=300&h=300', category: 'Bundles', views: 1890 },
  { id: 'l4', businessId: 'b2', title: 'Family Monthly Bulk Foodstuff', description: 'Monthly supply of cleaned Rice (10kg), Beans (5kg), Yam (5 tubers), Oils, and Condiments.', price: 85000, status: 'active', availability: 'pre-order', image: 'https://images.unsplash.com/photo-1583258292688-d0213dc5a3a8?auto=format&fit=crop&q=80&w=300&h=300', category: 'Bundles', views: 3124 },
  { id: 'l5', businessId: 'b2', title: 'Cleaned & Cut Yam Chunks (2kg)', description: 'Ready to boil or fry. Vacuum sealed for freshness.', price: 2500, status: 'active', availability: 'in-stock', image: 'https://images.unsplash.com/photo-1606859345711-d00db7214739?auto=format&fit=crop&q=80&w=300&h=300', category: 'Produce', views: 856 },
  { id: 'l6', businessId: 'b2', title: 'Packaged Premium Garri (5kg)', description: 'Stone-free, crispy Ijebu garri in moisture-proof packaging.', price: 4000, status: 'active', availability: 'in-stock', image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&q=80&w=300&h=300', category: 'Grains', views: 1200 },
  { id: 'l7', businessId: 'b2', title: 'Fresh Pepper & Tomatoes Mix', description: 'Blended and frozen. No preservatives.', price: 1500, status: 'active', availability: 'out-of-stock', image: 'https://images.unsplash.com/photo-1582284540020-8acbe03f4924?auto=format&fit=crop&q=80&w=300&h=300', category: 'Produce', views: 2450 }
];

export const MOCK_OPPORTUNITIES: Opportunity[] = [
  { id: 'o1', businessId: 'b1', title: 'Need Barista', type: 'Hiring', description: 'Looking for a barista for weekend shifts.', status: 'active', createdAt: '2026-08-10T10:00:00Z', expiresAt: '2026-08-20T10:00:00Z', interactions: 5 },
  
  { id: 'o2', businessId: 'b2', title: 'Same-Day OAU Campus Delivery (4 PM Window)', type: 'Logistics', description: 'Heading to campus at 4 PM. We have 5 delivery slots left. Order anything in-stock now for guaranteed delivery.', status: 'active', createdAt: '2026-08-13T08:00:00Z', expiresAt: '2026-08-13T15:30:00Z', interactions: 42 },
  { id: 'o3', businessId: 'b2', title: 'Pre-order deadline for Weekend Student Baskets', type: 'Notice', description: 'Reminder: All student weekend bundles must be ordered by Thursday 6 PM for Friday morning delivery.', status: 'scheduled', createdAt: '2026-08-10T14:00:00Z', expiresAt: '2026-08-14T18:00:00Z', interactions: 112 },
  { id: 'o4', businessId: 'b2', title: 'Bulk Plantain Arrival - Flash Sale', type: 'Promotion', description: 'Fresh unripe plantains just arrived from the farm. 20% off for the next 24 hours.', status: 'active', createdAt: '2026-08-13T09:00:00Z', expiresAt: '2026-08-14T09:00:00Z', interactions: 89 },
  { id: 'o5', businessId: 'b2', title: 'Supplying Hostels - Need Rider', type: 'Hiring', description: 'Need an extra dispatch rider for the Asherifa route this weekend.', status: 'closed', createdAt: '2026-08-01T09:00:00Z', expiresAt: '2026-08-05T09:00:00Z', interactions: 14 }
];

export const MOCK_MESSAGES: Message[] = [
  { id: 'm1', businessId: 'b1', senderName: 'Sarah J.', preview: 'Are you open today?', contextType: 'general', status: 'unread', timestamp: '2026-08-12T10:30:00Z' },
  
  { id: 'm2', businessId: 'b2', senderName: 'Tolu (Alumni Hall)', preview: 'Can I swap the spaghetti for indomie in this weekend basket?', contextType: 'listing', contextTitle: 'Student Weekend Soup Bundle', status: 'unread', timestamp: '2026-08-13T10:15:00Z' },
  { id: 'm3', businessId: 'b2', senderName: 'Mrs. Adeyemi', preview: 'Please ensure the beef is cut into very small pieces for my monthly order. Last time it was perfect.', contextType: 'listing', contextTitle: 'Family Monthly Bulk Foodstuff', status: 'unread', timestamp: '2026-08-13T09:45:00Z' },
  { id: 'm4', businessId: 'b2', senderName: 'John (Maintenance)', preview: 'Is it too late to join the 4 PM campus delivery window? I need 2 packs of Garri.', contextType: 'opportunity', contextTitle: 'Same-Day OAU Campus Delivery (4 PM Window)', status: 'replied', timestamp: '2026-08-13T12:20:00Z' },
  { id: 'm5', businessId: 'b2', senderName: 'Kemi', preview: 'When will the blended pepper mix be back in stock?', contextType: 'listing', contextTitle: 'Fresh Pepper & Tomatoes Mix', status: 'read', timestamp: '2026-08-12T16:45:00Z' }
];
MOCK

# 3. Create Business Service
cat << 'SERVICE' > src/app/core/business.service.ts
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
SERVICE

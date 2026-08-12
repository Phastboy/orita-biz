import { Business, Listing, Opportunity, Message, Metric } from './types';

export const MOCK_BUSINESS: Business = {
  id: 'b1',
  name: 'Lakeside Cafe & Bakery',
  description: 'Artisan coffee, fresh pastries, and a cozy atmosphere. We source local ingredients and roast our own beans daily.',
  logo: 'https://picsum.photos/seed/bizlogo/200/200',
  coverImage: 'https://picsum.photos/seed/bizcover/1200/400',
  category: 'Food & Dining',
  email: 'hello@lakesidecafe.com',
  phone: '(555) 123-4567',
  address: '123 Main St, Springfield',
  openingHours: 'Mon-Sat: 7am - 6pm, Sun: 8am - 4pm',
  serviceAreas: ['Springfield', 'Shelbyville', 'Capital City']
};

export const MOCK_METRICS: Metric[] = [
  { label: 'Profile Views', value: '1,248', trend: 12.5 },
  { label: 'Listing Views', value: '3,842', trend: 8.2 },
  { label: 'Contact Clicks', value: '156', trend: -2.4 },
  { label: 'Messages', value: '42', trend: 18.0 }
];

export const MOCK_LISTINGS: Listing[] = [
  { id: 'l1', title: 'Signature Espresso Roast', description: 'Our house blend espresso beans (1lb)', price: 18.00, status: 'active', availability: 'in-stock', image: 'https://picsum.photos/seed/l1/300/300', category: 'Coffee Beans', views: 342 },
  { id: 'l2', title: 'Sourdough Loaf', description: 'Freshly baked artisan sourdough', price: 8.50, status: 'active', availability: 'in-stock', image: 'https://picsum.photos/seed/l2/300/300', category: 'Bakery', views: 890 },
  { id: 'l3', title: 'Catering: Breakfast Pastry Box', description: 'Assorted pastries for 10-12 people', price: 45.00, status: 'active', availability: 'pre-order', image: 'https://picsum.photos/seed/l3/300/300', category: 'Catering', views: 124 },
  { id: 'l4', title: 'Seasonal Pumpkin Spice Latte', description: 'Fall special', price: 5.50, status: 'archived', availability: 'out-of-stock', image: 'https://picsum.photos/seed/l4/300/300', category: 'Beverages', views: 1560 },
  { id: 'l5', title: 'Ceramic Coffee Mug', description: 'Locally made branded mug', price: 22.00, status: 'draft', availability: 'in-stock', image: 'https://picsum.photos/seed/l5/300/300', category: 'Merch', views: 0 }
];

export const MOCK_OPPORTUNITIES: Opportunity[] = [
  { id: 'o1', title: 'Need a Barista for Weekend Shifts', type: 'Hiring', description: 'Looking for an experienced barista to cover Saturday and Sunday morning shifts.', status: 'active', createdAt: '2026-08-10T10:00:00Z', expiresAt: '2026-08-20T10:00:00Z', interactions: 5 },
  { id: 'o2', title: 'Free Pastry with Large Coffee', type: 'Promotion', description: 'Today only! Buy any large coffee and get a free croissant or muffin.', status: 'active', createdAt: '2026-08-12T08:00:00Z', expiresAt: '2026-08-12T18:00:00Z', interactions: 42 },
  { id: 'o3', title: 'Upcoming Latte Art Workshop', type: 'Event', description: 'Join us next week for a beginner-friendly latte art class.', status: 'scheduled', createdAt: '2026-08-05T14:00:00Z', expiresAt: '2026-08-15T18:00:00Z', interactions: 12 },
  { id: 'o4', title: 'Looking for Local Honey Supplier', type: 'Sourcing', description: 'We want to partner with a local apiary for our new drink menu.', status: 'expired', createdAt: '2026-07-01T09:00:00Z', expiresAt: '2026-07-15T09:00:00Z', interactions: 3 }
];

export const MOCK_MESSAGES: Message[] = [
  { id: 'm1', senderName: 'Sarah Jenkins', preview: 'Is the barista position still open?', contextType: 'opportunity', contextTitle: 'Need a Barista for Weekend Shifts', status: 'unread', timestamp: '2026-08-12T10:30:00Z' },
  { id: 'm2', senderName: 'Mike Chen', preview: 'Can I pre-order 5 pastry boxes for next Tuesday?', contextType: 'listing', contextTitle: 'Catering: Breakfast Pastry Box', status: 'unread', timestamp: '2026-08-12T09:15:00Z' },
  { id: 'm3', senderName: 'Elena Rodriguez', preview: 'Do you guys have oat milk available today?', contextType: 'general', status: 'replied', timestamp: '2026-08-11T14:20:00Z' },
  { id: 'm4', senderName: 'David Smith', preview: 'Hi, I run a local apiary and saw your post.', contextType: 'opportunity', contextTitle: 'Looking for Local Honey Supplier', status: 'read', timestamp: '2026-07-05T11:45:00Z' }
];

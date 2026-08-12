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
  senderName: string;
  preview: string;
  contextType: 'listing' | 'opportunity' | 'general';
  contextTitle?: string;
  status: MessageStatus;
  timestamp: string;
}

export interface Metric {
  label: string;
  value: string | number;
  trend: number;
}

#!/bin/bash
set -e

# Dashboard
sed -i "s/standalone: true,/standalone: true,\n  host: { class: 'flex flex-col h-full w-full overflow-hidden' },/" src/app/pages/dashboard/dashboard.component.ts

# Business
sed -i "s/standalone: true,/standalone: true,\n  host: { class: 'flex flex-col h-full w-full overflow-hidden' },/" src/app/pages/business/business.component.ts

# Listings
sed -i "s/standalone: true,/standalone: true,\n  host: { class: 'flex flex-col h-full w-full overflow-hidden' },/" src/app/pages/listings/listings.component.ts

# Opportunities
sed -i "s/standalone: true,/standalone: true,\n  host: { class: 'flex flex-col h-full w-full overflow-hidden' },/" src/app/pages/opportunities/opportunities.component.ts

# Messages
sed -i "s/standalone: true,/standalone: true,\n  host: { class: 'flex flex-col h-full w-full overflow-hidden' },/" src/app/pages/messages/messages.component.ts

# Analytics
sed -i "s/standalone: true,/standalone: true,\n  host: { class: 'flex flex-col h-full w-full overflow-hidden' },/" src/app/pages/analytics/analytics.component.ts

# Settings
sed -i "s/standalone: true,/standalone: true,\n  host: { class: 'flex flex-col h-full w-full overflow-y-auto' },/" src/app/pages/settings/settings.component.ts


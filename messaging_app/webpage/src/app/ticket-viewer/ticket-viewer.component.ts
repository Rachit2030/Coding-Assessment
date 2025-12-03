import { Component } from '@angular/core';

type TicketStatus = 'Open' | 'In Progress' | 'Closed';
type TicketPriority = 'Low' | 'Medium' | 'High';

interface Ticket {
id: number;
subject: string;
status: TicketStatus;
priority: TicketPriority;
requester: string;
createdAt: Date;
lastUpdatedAt: Date;
}

@Component({
selector: 'app-ticket-viewer',
templateUrl: './ticket-viewer.component.html'
})
export class TicketViewerComponent {
filter: TicketStatus | 'All' = 'All';

tickets: Ticket[] = [
{
id: 101,
subject: 'Login issue from mobile app',
status: 'Open',
priority: 'High',
requester: 'alex.ross',
createdAt: new Date('2025-12-02T09:15:00'),
lastUpdatedAt: new Date('2025-12-02T09:45:00')
},
{
id: 102,
subject: 'Payment not captured but card charged',
status: 'In Progress',
priority: 'High',
requester: 'sara.williams',
createdAt: new Date('2025-12-02T08:05:00'),
lastUpdatedAt: new Date('2025-12-02T10:20:00')
},
{
id: 103,
subject: 'Feature request: dark mode for dashboard',
status: 'Closed',
priority: 'Low',
requester: 'dev-team',
createdAt: new Date('2025-11-30T14:30:00'),
lastUpdatedAt: new Date('2025-12-01T11:10:00')
},
{
id: 104,
subject: 'Email notifications delayed by 30+ minutes',
status: 'In Progress',
priority: 'Medium',
requester: 'ops.oncall',
createdAt: new Date('2025-12-01T21:10:00'),
lastUpdatedAt: new Date('2025-12-02T07:55:00')
},
{
id: 105,
subject: 'Broken link on onboarding checklist',
status: 'Open',
priority: 'Low',
requester: 'hr.team',
createdAt: new Date('2025-12-02T06:40:00'),
lastUpdatedAt: new Date('2025-12-02T06:40:00')
},
{
id: 106,
subject: 'API rate limit being hit in production',
status: 'Open',
priority: 'High',
requester: 'backend-api',
createdAt: new Date('2025-12-02T11:05:00'),
lastUpdatedAt: new Date('2025-12-02T11:05:00')
},
{
id: 107,
subject: 'Live logs panel not auto-scrolling',
status: 'Closed',
priority: 'Medium',
requester: 'qa.bot',
createdAt: new Date('2025-11-29T16:20:00'),
lastUpdatedAt: new Date('2025-11-30T09:00:00')
},
{
id: 108,
subject: 'SLA breach alerts not firing',
status: 'In Progress',
priority: 'High',
requester: 'support-lead',
createdAt: new Date('2025-12-01T18:45:00'),
lastUpdatedAt: new Date('2025-12-02T08:30:00')
},
{
id: 109,
subject: 'Knowledgebase search returns empty results',
status: 'Open',
priority: 'Medium',
requester: 'helpcenter',
createdAt: new Date('2025-12-02T10:50:00'),
lastUpdatedAt: new Date('2025-12-02T10:50:00')
},
{
id: 110,
subject: 'Internal tools dashboard very slow on VPN',
status: 'Closed',
priority: 'Medium',
requester: 'infra.team',
createdAt: new Date('2025-11-28T09:00:00'),
lastUpdatedAt: new Date('2025-11-29T12:25:00')
}
];

get filteredTickets(): Ticket[] {
if (this.filter === 'All') {
return this.tickets;
}
return this.tickets.filter(t => t.status === this.filter);
}
}
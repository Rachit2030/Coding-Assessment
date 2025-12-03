// import { Component } from '@angular/core';

// type TicketStatus = 'Open' | 'In Progress' | 'Closed';
// type TicketPriority = 'Low' | 'Medium' | 'High';

// interface Ticket {
//   id: number;
//   subject: string;
//   status: TicketStatus;
//   priority: TicketPriority;
//   requester: string;
//   createdAt: Date;
//   lastUpdatedAt: Date;
// }

// @Component({
//   selector: 'app-ticket-viewer',
//   templateUrl: './ticket-viewer.component.html'
// })
// export class TicketViewerComponent {
//   filter: TicketStatus | 'All' = 'All';
//   sortBy: 'createdAt' | 'priority' | 'status' = 'createdAt';
//   sortOrder: 'asc' | 'desc' = 'desc';

//   tickets: Ticket[] = [
//     // Your existing tickets data (unchanged)
//     {
//       id: 101,
//       subject: 'Login issue from mobile app',
//       status: 'Open',
//       priority: 'High',
//       requester: 'alex.ross',
//       createdAt: new Date('2025-12-02T09:15:00'),
//       lastUpdatedAt: new Date('2025-12-02T09:45:00')
//     },
//     // ... rest of your tickets
//   ];

//    // ✅ MISSING METHOD 1: Status filter options
//   getStatusOptions(): (TicketStatus | 'All')[] {
//     return ['All', 'Open', 'In Progress', 'Closed'];
//   }

//   // ✅ MISSING METHOD 2: Status count for badges
//   getStatusCount(status: TicketStatus | 'All'): number {
//     if (status === 'All') return this.tickets.length;
//     return this.tickets.filter(t => t.status === status).length;
//   }
//   get filteredTickets(): Ticket[] {
//     let result = this.tickets.filter(t => 
//       this.filter === 'All' || t.status === this.filter
//     );

//     // Apply sorting
//     result = result.sort((a, b) => {
//       let aVal = a[this.sortBy as keyof Ticket];
//       let bVal = b[this.sortBy as keyof Ticket];
      
//       if (this.sortBy === 'priority') {
//         const priorityOrder = { 'High': 3, 'Medium': 2, 'Low': 1 };
//         aVal = priorityOrder[aVal as TicketPriority] || 0;
//         bVal = priorityOrder[bVal as TicketPriority] || 0;
//       } else if (this.sortBy === 'status') {
//         const statusOrder = { 'Open': 3, 'In Progress': 2, 'Closed': 1 };
//         aVal = statusOrder[aVal as TicketStatus] || 0;
//         bVal = statusOrder[bVal as TicketStatus] || 0;
//       } else {
//         aVal = (aVal as Date).getTime();
//         bVal = (bVal as Date).getTime();
//       }

//       return this.sortOrder === 'asc' 
//         ? (aVal as number) - (bVal as number)
//         : (bVal as number) - (aVal as number);
//     });

//     return result;
//   }

//   get statusCounts(): Record<TicketStatus, number> {
//     return {
//       Open: this.tickets.filter(t => t.status === 'Open').length,
//       'In Progress': this.tickets.filter(t => t.status === 'In Progress').length,
//       Closed: this.tickets.filter(t => t.status === 'Closed').length
//     };
//   }

//   setFilter(status: TicketStatus | 'All'): void {
//     this.filter = status;
//   }

//   toggleSort(column: 'createdAt' | 'priority' | 'status'): void {
//     if (this.sortBy === column) {
//       this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc';
//     } else {
//       this.sortBy = column;
//       this.sortOrder = 'desc';
//     }
//   }
// }


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
  sortBy: 'createdAt' | 'priority' | 'status' = 'createdAt';
  sortOrder: 'asc' | 'desc' = 'desc';

  tickets: Ticket[] = [
    // 🔥 HIGH PRIORITY - CRITICAL ISSUES
    {
      id: 101, subject: '🚨 Login issue from mobile app - auth token expires immediately', status: 'Open', priority: 'High', requester: 'alex.ross@company.com', createdAt: new Date('2025-12-02T09:15:00'), lastUpdatedAt: new Date('2025-12-02T11:30:00')
    },
    {
      id: 102, subject: '💳 Payment not captured but card charged - Stripe webhook failure', status: 'In Progress', priority: 'High', requester: 'sara.williams@company.com', createdAt: new Date('2025-12-02T08:05:00'), lastUpdatedAt: new Date('2025-12-02T10:45:00')
    },
    {
      id: 106, subject: '⚡ API rate limit being hit in production - 429 errors everywhere', status: 'Open', priority: 'High', requester: 'backend-api@company.com', createdAt: new Date('2025-12-02T11:05:00'), lastUpdatedAt: new Date('2025-12-02T11:20:00')
    },
    {
      id: 108, subject: '🚨 SLA breach alerts not firing - missing 15+ notifications', status: 'In Progress', priority: 'High', requester: 'support-lead@company.com', createdAt: new Date('2025-12-01T18:45:00'), lastUpdatedAt: new Date('2025-12-02T09:15:00')
    },

    // 🔥 MEDIUM PRIORITY - IMPORTANT FEATURES
    {
      id: 104, subject: '📧 Email notifications delayed by 30+ minutes - queue backlog', status: 'In Progress', priority: 'Medium', requester: 'ops.oncall@company.com', createdAt: new Date('2025-12-01T21:10:00'), lastUpdatedAt: new Date('2025-12-02T08:55:00')
    },
    {
      id: 109, subject: '🔍 Knowledgebase search returns empty results - Elasticsearch down?', status: 'Open', priority: 'Medium', requester: 'helpcenter@company.com', createdAt: new Date('2025-12-02T10:50:00'), lastUpdatedAt: new Date('2025-12-02T11:10:00')
    },
    {
      id: 110, subject: '🌐 Internal tools dashboard very slow on VPN - timeout errors', status: 'Closed', priority: 'Medium', requester: 'infra.team@company.com', createdAt: new Date('2025-11-28T09:00:00'), lastUpdatedAt: new Date('2025-11-29T16:25:00')
    },
    {
      id: 111, subject: '📱 Push notifications not working on Android - FCM token invalid', status: 'Open', priority: 'Medium', requester: 'mobile.team@company.com', createdAt: new Date('2025-12-02T07:30:00'), lastUpdatedAt: new Date('2025-12-02T10:15:00')
    },

    // 🟡 LOW PRIORITY - UI/UX IMPROVEMENTS
    {
      id: 103, subject: '🌙 Feature request: dark mode for dashboard', status: 'Closed', priority: 'Low', requester: 'dev-team@company.com', createdAt: new Date('2025-11-30T14:30:00'), lastUpdatedAt: new Date('2025-12-01T15:45:00')
    },
    {
      id: 105, subject: '🔗 Broken link on onboarding checklist - 404 error', status: 'Open', priority: 'Low', requester: 'hr.team@company.com', createdAt: new Date('2025-12-02T06:40:00'), lastUpdatedAt: new Date('2025-12-02T07:10:00')
    },
    {
      id: 112, subject: '📊 Live logs panel not auto-scrolling to bottom', status: 'In Progress', priority: 'Low', requester: 'qa.team@company.com', createdAt: new Date('2025-12-01T16:20:00'), lastUpdatedAt: new Date('2025-12-02T09:30:00')
    },
    {
      id: 113, subject: '🎨 UI polish: ticket priority badges need better contrast', status: 'Open', priority: 'Low', requester: 'design@company.com', createdAt: new Date('2025-12-02T04:15:00'), lastUpdatedAt: new Date('2025-12-02T08:20:00')
    },

    // 🔥 NEW HIGH IMPACT TICKETS
    {
      id: 114, subject: '🚨 Production database connection pool exhausted', status: 'Open', priority: 'High', requester: 'db.admin@company.com', createdAt: new Date('2025-12-02T11:45:00'), lastUpdatedAt: new Date('2025-12-02T11:50:00')
    },
    {
      id: 115, subject: '💥 Redis cache outage - all sessions lost', status: 'In Progress', priority: 'High', requester: 'cache.ops@company.com', createdAt: new Date('2025-12-02T10:30:00'), lastUpdatedAt: new Date('2025-12-02T11:25:00')
    },

    // 🟡 SUPPORT TICKETS
    {
      id: 116, subject: '❓ User cannot reset password - link expires too fast', status: 'Open', priority: 'Medium', requester: 'user.support@company.com', createdAt: new Date('2025-12-01T22:10:00'), lastUpdatedAt: new Date('2025-12-02T09:05:00')
    },
    {
      id: 117, subject: '📈 Analytics dashboard shows 0 active users', status: 'Closed', priority: 'Medium', requester: 'data.team@company.com', createdAt: new Date('2025-11-30T11:20:00'), lastUpdatedAt: new Date('2025-12-01T14:30:00')
    },

    // 🛠️ INFRA TICKETS
    {
      id: 118, subject: '🔒 SSO integration with Okta failing intermittently', status: 'In Progress', priority: 'High', requester: 'security@company.com', createdAt: new Date('2025-12-02T08:45:00'), lastUpdatedAt: new Date('2025-12-02T10:55:00')
    },
    {
      id: 119, subject: '🐳 Docker image size too large - 2.8GB', status: 'Open', priority: 'Low', requester: 'devops@company.com', createdAt: new Date('2025-12-01T15:30:00'), lastUpdatedAt: new Date('2025-12-02T07:45:00')
    }
  ];

  // ✅ Your existing methods (unchanged)
  getStatusOptions(): (TicketStatus | 'All')[] {
    return ['All', 'Open', 'In Progress', 'Closed'];
  }

  getStatusCount(status: TicketStatus | 'All'): number {
    if (status === 'All') return this.tickets.length;
    return this.tickets.filter(t => t.status === status).length;
  }

  get filteredTickets(): Ticket[] {
    let result = this.tickets.filter(t => 
      this.filter === 'All' || t.status === this.filter
    );

    // Apply sorting
    result = result.sort((a, b) => {
      let aVal = a[this.sortBy as keyof Ticket];
      let bVal = b[this.sortBy as keyof Ticket];
      
      if (this.sortBy === 'priority') {
        const priorityOrder = { 'High': 3, 'Medium': 2, 'Low': 1 };
        aVal = priorityOrder[aVal as TicketPriority] || 0;
        bVal = priorityOrder[bVal as TicketPriority] || 0;
      } else if (this.sortBy === 'status') {
        const statusOrder = { 'Open': 3, 'In Progress': 2, 'Closed': 1 };
        aVal = statusOrder[aVal as TicketStatus] || 0;
        bVal = statusOrder[bVal as TicketStatus] || 0;
      } else {
        aVal = (aVal as Date).getTime();
        bVal = (bVal as Date).getTime();
      }

      return this.sortOrder === 'asc' 
        ? (aVal as number) - (bVal as number)
        : (bVal as number) - (aVal as number);
    });

    return result;
  }

  get statusCounts(): Record<TicketStatus, number> {
    return {
      Open: this.tickets.filter(t => t.status === 'Open').length,
      'In Progress': this.tickets.filter(t => t.status === 'In Progress').length,
      Closed: this.tickets.filter(t => t.status === 'Closed').length
    };
  }

  setFilter(status: TicketStatus | 'All'): void {
    this.filter = status;
  }

  toggleSort(column: 'createdAt' | 'priority' | 'status'): void {
    if (this.sortBy === column) {
      this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc';
    } else {
      this.sortBy = column;
      this.sortOrder = 'desc';
    }
  }
}

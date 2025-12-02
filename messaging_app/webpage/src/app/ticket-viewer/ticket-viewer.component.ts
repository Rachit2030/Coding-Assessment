import { Component } from '@angular/core';

type Ticket = { id: number; subject: string; status: 'Open'|'In Progress'|'Closed'; createdAt: string };

@Component({
selector: 'app-ticket-viewer',
templateUrl: './ticket-viewer.component.html'
})
export class TicketViewerComponent {
tickets: Ticket[] = [];
filter: 'All'|'Open'|'In Progress'|'Closed' = 'All';

constructor(){
// create dummy data
const statuses: Ticket['status'][] = ['Open','In Progress','Closed'];
for(let i=1;i<=25;i++){
this.tickets.push({
id: i,
subject: `Issue ${i}: Example subject line`,
status: statuses[i % 3],
createdAt: new Date(Date.now() - i*1000*60*60*24).toISOString().slice(0,10)
});
}
}

get filtered(){
if(this.filter === 'All') return this.tickets;
return this.tickets.filter(t => t.status === this.filter);
}
}
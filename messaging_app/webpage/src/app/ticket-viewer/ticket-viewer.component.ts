import { Component } from '@angular/core';

@Component({
  selector: 'app-ticket-viewer',
  templateUrl: './ticket-viewer.component.html'
})
export class TicketViewerComponent {
  filter: string = ''; // default all
  tickets = [
    { id: 1, subject: 'Login issue', status: 'Open', createdAt: new Date() },
    { id: 2, subject: 'Bug in form', status: 'In Progress', createdAt: new Date() },
    { id: 3, subject: 'Feature request', status: 'Closed', createdAt: new Date() },
  ];
}

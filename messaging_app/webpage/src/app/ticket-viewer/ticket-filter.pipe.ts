import { Pipe, PipeTransform } from '@angular/core';

@Pipe({ name: 'ticketFilter' })
export class TicketFilterPipe implements PipeTransform {
  transform(tickets: any[], status: string): any[] {
    if (!tickets) return [];
    if (!status || status === '') return tickets;
    return tickets.filter(ticket => ticket.status === status);
  }
}

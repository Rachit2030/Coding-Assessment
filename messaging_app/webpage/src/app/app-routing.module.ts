import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TicketViewerComponent } from './ticket-viewer/ticket-viewer.component';
import { LiveLogsComponent } from './live-logs/live-logs.component';
import { KnowledgebaseComponent } from './knowledgebase/knowledgebase.component';


const routes: Routes = [
  { path: '', redirectTo: 'tickets', pathMatch: 'full' },
  { path: 'tickets', component: TicketViewerComponent },
  { path: 'kb', component: KnowledgebaseComponent },
  { path: 'logs', component: LiveLogsComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}

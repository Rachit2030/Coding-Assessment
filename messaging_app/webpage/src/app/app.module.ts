import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { AppRoutingModule } from './app-routing.module';

import { AppComponent } from './app.component';
import { NavComponent } from './nav/nav.component';
import { TicketViewerComponent } from './ticket-viewer/ticket-viewer.component';
import { LiveLogsComponent } from './live-logs/live-logs.component';
import { TicketFilterPipe } from './ticket-viewer/ticket-filter.pipe';
import { KnowledgebaseComponent } from './knowledgebase/knowledgebase.component';

@NgModule({
  declarations: [
    AppComponent,
    NavComponent,
    TicketViewerComponent,
    KnowledgebaseComponent,
    LiveLogsComponent,
    TicketFilterPipe
  ],
  imports: [
    BrowserModule,
    FormsModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }

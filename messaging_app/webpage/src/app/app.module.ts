import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import { FormsModule } from '@angular/forms';
import { AppRoutingModule } from './app-routing.module'; 
// import { TicketViewerComponent } from './ticket-viewer/ticket-viewer.component';
// import { KnowledgebaseComponent } from './knowledgebase/knowledgebase.component';
// import { LiveLogsComponent } from './live-logs/live-logs.component';
// import { NavComponent } from './nav/nav.component';

@NgModule({
  declarations: [
    AppComponent,
    // TicketViewerComponent,
    // KnowledgebaseComponent,
    // LiveLogsComponent,
   
    // NavComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    // RouterModule.forRoot(appRoutes),
    AppRoutingModule,
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {}

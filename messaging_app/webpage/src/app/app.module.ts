import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';

import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import { NavComponent } from './nav/nav.component';
import { TicketViewerComponent } from './ticket-viewer/ticket-viewer.component';
import { LiveLogsComponent } from './live-logs/live-logs.component';
import { KnowledgebaseComponent } from './knowledgebase/knowledgebase.component';


@NgModule({
declarations: [
AppComponent,
NavComponent,
TicketViewerComponent,
KnowledgebaseComponent,
LiveLogsComponent,
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
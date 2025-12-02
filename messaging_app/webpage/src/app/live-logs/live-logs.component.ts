import { Component, ElementRef, OnDestroy, ViewChild } from '@angular/core';

@Component({
  selector: 'app-live-logs',
  templateUrl: './live-logs.component.html'
})
export class LiveLogsComponent implements OnDestroy {
  logs: string[] = [];
  timerId: any;
  @ViewChild('logBox') logBox!: ElementRef<HTMLDivElement>;

  constructor() {
    this.start();
  }

  start() {
    this.timerId = setInterval(() => {
      const now = new Date().toLocaleTimeString();
      const entry = `[${now}] EVENT: ${['heartbeat','user_login','db_write','cache_miss','api_call'][Math.floor(Math.random()*5)]} id=${Math.floor(Math.random()*9999)}`;
      this.logs.push(entry);
      if (this.logs.length > 500) this.logs.shift();
      setTimeout(() => {
        if (this.logBox) this.logBox.nativeElement.scrollTop = this.logBox.nativeElement.scrollHeight;
      }, 20);
    }, 2000);
  }

  clear() {
    this.logs = [];
  }

  ngOnDestroy() {
    clearInterval(this.timerId);
  }
}

import { Component, ElementRef, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { interval, Subscription } from 'rxjs';

@Component({
  selector: 'app-live-logs',
  templateUrl: './live-logs.component.html'
})
export class LiveLogsComponent implements OnInit, OnDestroy {
  logs: string[] = [];
  sub: Subscription | undefined;
  @ViewChild('logBox') logBox!: ElementRef<HTMLDivElement>;

  ngOnInit() {
    this.sub = interval(1500).subscribe(() => this.pushRandom());
  }

  ngOnDestroy() {
    this.sub?.unsubscribe();
  }

  pushRandom() {
    const levels = ['INFO','WARN','ERROR','DEBUG'];
    const level = levels[Math.floor(Math.random()*levels.length)];
    const message = `${new Date().toLocaleTimeString()} [${level}] Simulated event: ${Math.random().toString(36).slice(2,9)}`;
    this.logs.push(message);
    if(this.logs.length>200) this.logs.shift();
    setTimeout(()=> {
      try { this.logBox.nativeElement.scrollTop = this.logBox.nativeElement.scrollHeight; } catch(e) {}
    }, 50);
  }
}

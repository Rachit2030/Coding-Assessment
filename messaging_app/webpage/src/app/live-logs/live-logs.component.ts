import { Component, ElementRef, OnDestroy, OnInit, ViewChild, AfterViewInit, ChangeDetectorRef, HostListener } from '@angular/core';
import { interval, Subject, takeUntil } from 'rxjs';

interface LogEntry {
  timestamp: string;
  level: 'INFO' | 'WARN' | 'ERROR' | 'DEBUG' | 'SUCCESS';
  message: string;
  id: string;
}

@Component({
  selector: 'app-live-logs',
  templateUrl: './live-logs.component.html',
  styleUrls: ['./live-logs.component.css']
})
export class LiveLogsComponent implements OnInit, AfterViewInit, OnDestroy {
  @ViewChild('logBox', { static: false }) logBox!: ElementRef<HTMLDivElement>;
  
  logs: LogEntry[] = [];
  isPaused = false;
  autoScroll = true;
  isMobile = false;
  maxLogs = 200;

  private destroy$ = new Subject<void>();
  private scrollTimeout: any;

  private logTemplates = [
    '[API] POST /auth/login - 200 OK - user=alex.ross',
    '[API] GET /tickets - 200 OK - count=42 - took=23ms',
    '[ERROR] Stripe webhook timeout - retry=3/5',
    '[CACHE] Redis GET user:101 - HIT - ttl=3600s',
    '[HEALTH] Postgres healthy - latency=12ms',
    '[WARN] Rate limit hit - IP=192.168.1.100',
    '[QUEUE] RabbitMQ ticket-101 processed'
  ];

  constructor(private cdr: ChangeDetectorRef) {
    this.checkScreen();
  }

  ngOnInit(): void {
    for (let i = 0; i < 20; i++) this.generateLog();
    
    interval(1500).pipe(takeUntil(this.destroy$)).subscribe(() => {
      if (!this.isPaused) this.generateLog();
    });
  }

  ngAfterViewInit(): void {
    this.scrollToBottom();
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
    if (this.scrollTimeout) clearTimeout(this.scrollTimeout);
  }

  @HostListener('window:resize')
  checkScreen(): void {
    this.isMobile = window.innerWidth <= 768;
  }

  togglePause(): void { this.isPaused = !this.isPaused; }
  toggleAutoScroll(): void { 
    this.autoScroll = !this.autoScroll; 
    if (this.autoScroll) this.scrollToBottom(); 
  }
  clearLogs(): void { this.logs = []; }

  private generateLog(): void {
    const level = ['INFO','WARN','ERROR','DEBUG'][Math.floor(Math.random()*4)] as LogEntry['level'];
    const log: LogEntry = {
      timestamp: new Date().toLocaleTimeString('en-US', {hour12: false}),
      level,
      message: this.logTemplates[Math.floor(Math.random() * this.logTemplates.length)],
      id: Math.random().toString(36).slice(2, 9)
    };

    this.logs.push(log);
    if (this.logs.length > this.maxLogs) this.logs.shift();

    if (this.autoScroll) {
      this.scrollTimeout = setTimeout(() => this.scrollToBottom(), 100);
    }
    this.cdr.detectChanges();
  }

  private scrollToBottom(): void {
    try {
      this.logBox.nativeElement.scrollTop = this.logBox.nativeElement.scrollHeight;
    } catch (e) {}
  }

  shouldShowLog(log: LogEntry): boolean {
    return true; // Show all logs
  }
}

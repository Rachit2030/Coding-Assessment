import { Component, HostListener } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
})
export class AppComponent {
  menuOpen = false;
  isMobileView = window.innerWidth < 768;

  toggleMenu() {
    this.menuOpen = !this.menuOpen;
  }

  @HostListener('window:resize', ['$event'])
  onResize(event: any) {
    this.isMobileView = event.target.innerWidth < 768;
    if (!this.isMobileView) {
      this.menuOpen = false; // always show sidebar on desktop
    }
  }
}

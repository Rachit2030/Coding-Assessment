import { Component, HostListener } from '@angular/core';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';

@Component({
  selector: 'app-knowledgebase',
  templateUrl: './knowledgebase.component.html',
  styleUrls: ['./knowledgebase.component.css']
})
export class KnowledgebaseComponent {
  content: string = localStorage.getItem('kb_content') || '# Knowledgebase\n\nStart writing...';
  preview: boolean = false;
  formattedContent: SafeHtml = '';
  lastEdit: Date | null = null;
  isMobile = false;
  showMobileMenu = false;

  constructor(private sanitizer: DomSanitizer) {
    this.updatePreview();
    this.checkScreen();
  }

  @HostListener('window:resize')
  checkScreen(): void {
    this.isMobile = window.innerWidth <= 768;
    this.showMobileMenu = false;
  }

  save(): void {
    localStorage.setItem('kb_content', this.content);
    this.lastEdit = new Date();
    alert('Saved to localStorage!');
    this.updatePreview();
  }

  updatePreview(): void {
    this.formattedContent = this.sanitizer.bypassSecurityTrustHtml(
      this.content
        .replace(/\n\n/g, '<br><br>')
        .replace(/### (.*)\n/g, '<h3 style="color: #6366f1; margin-top: 1.5em;">$1</h3>')
        .replace(/## (.*)\n/g, '<h2 style="color: #4f46e5; margin-top: 2em;">$1</h2>')
        .replace(/# (.*)\n/g, '<h1 style="color: #3730a3; margin-top: 2.5em;">$1</h1>')
        .replace(/`(.*?)`/g, '<code style="background: #f3f4f6; padding: 0.25em 0.5em; border-radius: 0.375rem; color: #374151;">$1</code>')
        .replace(/\*\*(.*?)\*\*/g, '<strong style="color: #1f2937;">$1</strong>')
        .replace(/\*(.*?)\*/g, '<em style="color: #6b7280;">$1</em>')
        .replace(/^\s*>\s(.*)$/gm, '<blockquote style="border-left: 4px solid #e5e7eb; padding-left: 1rem; margin: 1rem 0; color: #6b7280;">$1</blockquote>')
    );
    this.lastEdit = new Date();
  }

  loadTemplate(type: string): void {
    switch (type) {
      case 'faq':
        this.content = `# FAQ Article\n\n## Frequently Asked Questions\n\n### Question 1?\n**Answer:** This is the answer to your first question.\n\n### Question 2?\n**Answer:** Another answer here with \`inline code\` example.\n\n> **Pro tip:** Use backticks \`like this\` for technical terms`;
        break;
      case 'guide':
        this.content = `# Step-by-Step Guide\n\n## Getting Started\n\n1. First step with **bold text**\n2. Second step\n\n### Prerequisites\n- Item 1\n- \`npm install package-name\` (technical command)\n\n> **Note:** Always test your changes before deploying`;
        break;
    }
    localStorage.setItem('kb_content', this.content);
    this.updatePreview();
  }

  clearAll(): void {
    if (confirm('Clear all content?')) {
      this.content = '';
      localStorage.removeItem('kb_content');
      this.updatePreview();
    }
  }

  copyToClipboard(): void {
    navigator.clipboard.writeText(this.content).then(() => {
      alert('Markdown copied to clipboard!');
    });
  }

  togglePreview(): void {
    this.preview = !this.preview;
    if (this.preview) this.updatePreview();
  }

  toggleMobileMenu(): void {
    this.showMobileMenu = !this.showMobileMenu;
  }
}

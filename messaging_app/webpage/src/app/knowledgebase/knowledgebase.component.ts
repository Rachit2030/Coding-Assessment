import { Component } from '@angular/core';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';

@Component({
  selector: 'app-knowledgebase',
  templateUrl: './knowledgebase.component.html'
})
export class KnowledgebaseComponent {
  content: string = localStorage.getItem('kb_content') || '# Knowledgebase\n\nStart writing...';
  preview: boolean = false;
  formattedContent: SafeHtml = '';
  lastEdit: Date | null = null;

  constructor(private sanitizer: DomSanitizer) {
    this.updatePreview();
  }

  // ✅ Your existing save method (enhanced)
  save() {
    localStorage.setItem('kb_content', this.content);
    this.lastEdit = new Date();
    alert('Saved to localStorage!');
    this.updatePreview();
  }

  // ✅ Preview formatter (basic Markdown)
  updatePreview(): void {
    this.formattedContent = this.sanitizer.bypassSecurityTrustHtml(
      this.content
        .replace(/\n\n/g, '<br><br>')
        .replace(/### (.*)\n/g, '<h3 style="color: #6366f1; margin-top: 1.5em;">$1</h3>')
        .replace(/## (.*)\n/g, '<h2 style="color: #4f46e5; margin-top: 2em;">$1</h2>')
        .replace(/# (.*)\n/g, '<h1 style="color: #3730a3; margin-top: 2.5em;">$1</h1>')
        .replace(/`(.*?)`/g, '<code style="background: #f3f4f6; padding: 0.25em 0.5em; border-radius: 0.375rem;">$1</code>')
        .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
        .replace(/\*(.*?)\*/g, '<em>$1</em>')
    );
    this.lastEdit = new Date();
  }

  // ✅ Template methods
  loadTemplate(type: string): void {
    switch (type) {
      case 'faq':
        this.content = `# FAQ Article\n\n## Frequently Asked Questions\n\n### Question 1?\n**Answer:** This is the answer...\n\n### Question 2?\n**Answer:** Another answer here.\n\n> Pro tip: Use \`code\` for technical terms`;
        break;
      case 'guide':
        this.content = `# Step-by-Step Guide\n\n## Getting Started\n\n1. First step\n2. Second step\n\n### Prerequisites\n- Item 1\n- \`Item 2\` (technical)\n\n> **Note:** Always test your changes`;
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
}

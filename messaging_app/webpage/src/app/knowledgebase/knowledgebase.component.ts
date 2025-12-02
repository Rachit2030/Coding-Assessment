import { Component } from '@angular/core';

@Component({
  selector: 'app-knowledgebase',
  templateUrl: './knowledgebase.component.html'
})
export class KnowledgebaseComponent {
  content = localStorage.getItem('kb_content') || '# Knowledgebase\n\nStart writing...';
  preview = false;

  save() {
    localStorage.setItem('kb_content', this.content);
    alert('Saved to localStorage (no backend)');
  }
}

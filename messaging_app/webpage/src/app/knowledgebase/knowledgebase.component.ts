import { Component } from '@angular/core';
import { marked } from 'marked';

@Component({
  selector: 'app-knowledgebase',
  templateUrl: './knowledgebase.component.html'
})
export class KnowledgebaseComponent {
  text = `# Knowledgebase\n\nWrite docs here...`;
  previewMode = false;

  setPreview(val: boolean) {
    this.previewMode = val;
  }

  get html() {
    return marked.parse(this.text || '');
  }

  save() {
    localStorage.setItem('kb-draft', this.text);
    alert('Saved locally.');
  }

  ngOnInit() {
    const saved = localStorage.getItem('kb-draft');
    if (saved) this.text = saved;
  }
}

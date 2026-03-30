/**
 * TipTap Editor — EasyAdmin Integration
 *
 * Editeur WYSIWYG full-page integre dans EasyAdmin.
 * Le contenu est stocke en JSON natif TipTap dans le champ `blocks`.
 * Le listener Doctrine compile le JSON en HTML cache dans `content`.
 */
import './tiptap-editor.scss';

import { Editor } from '@tiptap/core';
import StarterKit from '@tiptap/starter-kit';
import Image from '@tiptap/extension-image';
import Youtube from '@tiptap/extension-youtube';
import Placeholder from '@tiptap/extension-placeholder';
import Typography from '@tiptap/extension-typography';
import Link from '@tiptap/extension-link';
import Underline from '@tiptap/extension-underline';
import Highlight from '@tiptap/extension-highlight';
import TextAlign from '@tiptap/extension-text-align';
import CharacterCount from '@tiptap/extension-character-count';
import Table from '@tiptap/extension-table';
import TableRow from '@tiptap/extension-table-row';
import TableCell from '@tiptap/extension-table-cell';
import TableHeader from '@tiptap/extension-table-header';
import { Callout } from './extensions/callout';
import { Columns, Column } from './extensions/columns';

// ─── TipTap Editor Class ────────────────────────────────────────────────────

class TiptapEditor {
    constructor(textarea) {
        this.textarea = textarea;
        this.autosaveTimer = null;
        this.autosaveInterval = null;

        // Autosave key from URL context
        const params = new URLSearchParams(window.location.search);
        const controller = params.get('crudControllerFqcn') || 'content';
        const entityId = params.get('entityId') || 'new';
        const entityType = controller.split('\\').pop()?.replace('CrudController', '').toLowerCase() || 'content';
        this.autosaveKey = `tiptap_draft_${entityType}_${entityId}`;

        this.init();
    }

    init() {
        this.initialContent = this.parseContent(this.textarea.value);

        this.createWrapper();
        this.createToolbar();
        this.createEditorElement();
        this.createStatusBar();
        this.createEditor();
        this.setupAjaxSave();

        this.textarea.style.display = 'none';
    }

    parseContent(value) {
        if (!value || value === 'null' || value === '') return null;
        try {
            return JSON.parse(value);
        } catch (e) {
            return null;
        }
    }

    // ─── DOM Construction ────────────────────────────────────────────────

    createWrapper() {
        this.wrapper = document.createElement('div');
        this.wrapper.className = 'tiptap-wrapper';
        this.textarea.parentNode.insertBefore(this.wrapper, this.textarea);
    }

    createToolbar() {
        this.toolbar = document.createElement('div');
        this.toolbar.className = 'tiptap-toolbar';

        const groups = [
            // Text formatting
            [
                { cmd: 'bold', icon: 'fa-bold', title: 'Gras (Ctrl+B)' },
                { cmd: 'italic', icon: 'fa-italic', title: 'Italique (Ctrl+I)' },
                { cmd: 'underline', icon: 'fa-underline', title: 'Souligner (Ctrl+U)' },
                { cmd: 'strike', icon: 'fa-strikethrough', title: 'Barrer' },
                { cmd: 'highlight', icon: 'fa-highlighter', title: 'Surligner' },
            ],
            // Headings
            [
                { cmd: 'h2', text: 'H2', title: 'Titre 2' },
                { cmd: 'h3', text: 'H3', title: 'Titre 3' },
                { cmd: 'h4', text: 'H4', title: 'Titre 4' },
            ],
            // Alignment
            [
                { cmd: 'alignLeft', icon: 'fa-align-left', title: 'Aligner a gauche' },
                { cmd: 'alignCenter', icon: 'fa-align-center', title: 'Centrer' },
                { cmd: 'alignRight', icon: 'fa-align-right', title: 'Aligner a droite' },
            ],
            // Lists
            [
                { cmd: 'bulletList', icon: 'fa-list-ul', title: 'Liste a puces' },
                { cmd: 'orderedList', icon: 'fa-list-ol', title: 'Liste numerotee' },
            ],
            // Block types
            [
                { cmd: 'blockquote', icon: 'fa-quote-left', title: 'Citation' },
                { cmd: 'codeBlock', icon: 'fa-code', title: 'Bloc de code' },
                { cmd: 'callout', icon: 'fa-info-circle', title: 'Encart (info, alerte...)' },
                { cmd: 'columns', icon: 'fa-columns', title: '2 colonnes' },
            ],
            // Table
            [
                { cmd: 'insertTable', icon: 'fa-table', title: 'Inserer un tableau' },
            ],
            // Media
            [
                { cmd: 'link', icon: 'fa-link', title: 'Lien' },
                { cmd: 'image', icon: 'fa-image', title: 'Image' },
                { cmd: 'youtube', icon: 'fa-video', title: 'Video YouTube' },
            ],
            // Other
            [
                { cmd: 'horizontalRule', icon: 'fa-minus', title: 'Separateur' },
                { cmd: 'undo', icon: 'fa-undo', title: 'Annuler (Ctrl+Z)' },
                { cmd: 'redo', icon: 'fa-redo', title: 'Refaire (Ctrl+Y)' },
            ],
            // Responsive preview
            [
                { cmd: 'previewDesktop', icon: 'fa-desktop', title: 'Apercu bureau' },
                { cmd: 'previewTablet', icon: 'fa-tablet-alt', title: 'Apercu tablette' },
                { cmd: 'previewMobile', icon: 'fa-mobile-alt', title: 'Apercu mobile' },
            ],
        ];

        groups.forEach((group, i) => {
            if (i > 0) {
                const sep = document.createElement('span');
                sep.className = 'tiptap-toolbar-sep';
                this.toolbar.appendChild(sep);
            }

            group.forEach(btn => {
                const button = document.createElement('button');
                button.type = 'button';
                button.className = 'tiptap-toolbar-btn';
                button.title = btn.title;
                button.dataset.cmd = btn.cmd;

                if (btn.icon) {
                    button.innerHTML = `<i class="fas ${btn.icon}"></i>`;
                } else if (btn.text) {
                    button.textContent = btn.text;
                }

                button.addEventListener('click', (e) => {
                    e.preventDefault();
                    this.execCommand(btn.cmd);
                });

                this.toolbar.appendChild(button);
            });
        });

        this.wrapper.appendChild(this.toolbar);
    }

    createEditorElement() {
        this.editorElement = document.createElement('div');
        this.editorElement.className = 'tiptap-editor-content';
        this.wrapper.appendChild(this.editorElement);
    }

    createStatusBar() {
        this.statusBar = document.createElement('div');
        this.statusBar.className = 'tiptap-status-bar';

        this.charCounter = document.createElement('span');
        this.charCounter.className = 'tiptap-char-count';
        this.charCounter.textContent = '0 caracteres · 0 mots';

        this.indicator = document.createElement('span');
        this.indicator.className = 'tiptap-autosave-indicator';

        this.statusBar.appendChild(this.charCounter);
        this.statusBar.appendChild(this.indicator);
        this.wrapper.appendChild(this.statusBar);
    }

    updateCharCount() {
        if (!this.editor || !this.charCounter) return;
        const chars = this.editor.storage.characterCount.characters();
        const words = this.editor.storage.characterCount.words();
        this.charCounter.textContent = `${chars} caractere${chars > 1 ? 's' : ''} · ${words} mot${words > 1 ? 's' : ''}`;
    }

    // ─── TipTap Instance ─────────────────────────────────────────────────

    createEditor() {
        this.editor = new Editor({
            element: this.editorElement,
            extensions: [
                StarterKit.configure({
                    heading: { levels: [2, 3, 4] },
                }),
                Image.configure({
                    HTMLAttributes: { loading: 'lazy' },
                    allowBase64: false,
                }),
                Youtube.configure({
                    controls: true,
                    nocookie: true,
                }),
                Placeholder.configure({
                    placeholder: 'Commencez a ecrire votre contenu...',
                }),
                Typography,
                Link.configure({
                    openOnClick: false,
                    HTMLAttributes: { rel: 'noopener noreferrer' },
                }),
                Underline,
                Highlight.configure({
                    HTMLAttributes: { class: 'block-highlight' },
                }),
                TextAlign.configure({
                    types: ['heading', 'paragraph'],
                }),
                CharacterCount,
                Table.configure({
                    resizable: true,
                    HTMLAttributes: { class: 'tiptap-table' },
                }),
                TableRow,
                TableCell,
                TableHeader,
                Callout,
                Columns,
                Column,
            ],
            content: this.initialContent,
            onUpdate: () => {
                this.syncToTextarea();
                this.updateToolbarState();
                this.updateCharCount();
                this.handleSlashDetection();
                this.scheduleAjaxSave();
            },
            onSelectionUpdate: () => {
                this.updateToolbarState();
            },
            onCreate: () => {
                this.updateCharCount();
                this.setupSlashCommands();
            },
        });
    }

    // ─── Slash Commands (/menu) ───────────────────────────────────────────

    setupSlashCommands() {
        this.slashMenu = null;
        this.slashItems = [
            { label: 'Titre H2', icon: 'fa-heading', action: () => this.editor.chain().focus().toggleHeading({ level: 2 }).run() },
            { label: 'Titre H3', icon: 'fa-heading', action: () => this.editor.chain().focus().toggleHeading({ level: 3 }).run() },
            { label: 'Titre H4', icon: 'fa-heading', action: () => this.editor.chain().focus().toggleHeading({ level: 4 }).run() },
            { label: 'Image', icon: 'fa-image', action: () => this.openMediaModal() },
            { label: 'Video YouTube', icon: 'fa-video', action: () => this.insertVideo() },
            { label: 'Citation', icon: 'fa-quote-left', action: () => this.editor.chain().focus().toggleBlockquote().run() },
            { label: 'Liste a puces', icon: 'fa-list-ul', action: () => this.editor.chain().focus().toggleBulletList().run() },
            { label: 'Liste numerotee', icon: 'fa-list-ol', action: () => this.editor.chain().focus().toggleOrderedList().run() },
            { label: 'Encart Info', icon: 'fa-info-circle', action: () => this.editor.chain().focus().setCallout({ type: 'info' }).run() },
            { label: 'Encart Succes', icon: 'fa-check-circle', action: () => this.editor.chain().focus().setCallout({ type: 'success' }).run() },
            { label: 'Encart Attention', icon: 'fa-exclamation-triangle', action: () => this.editor.chain().focus().setCallout({ type: 'warning' }).run() },
            { label: 'Encart Danger', icon: 'fa-times-circle', action: () => this.editor.chain().focus().setCallout({ type: 'danger' }).run() },
            { label: '2 Colonnes', icon: 'fa-columns', action: () => this.editor.chain().focus().setColumns().run() },
            { label: 'Tableau', icon: 'fa-table', action: () => this.editor.chain().focus().insertTable({ rows: 3, cols: 3, withHeaderRow: true }).run() },
            { label: 'Code', icon: 'fa-code', action: () => this.editor.chain().focus().toggleCodeBlock().run() },
            { label: 'Separateur', icon: 'fa-minus', action: () => this.editor.chain().focus().setHorizontalRule().run() },
        ];

        this.editorElement.addEventListener('keydown', (e) => {
            if (this.slashMenu) {
                if (e.key === 'Escape') { e.preventDefault(); this.closeSlashMenu(); return; }
                if (e.key === 'ArrowDown') { e.preventDefault(); this.navigateSlashMenu(1); return; }
                if (e.key === 'ArrowUp') { e.preventDefault(); this.navigateSlashMenu(-1); return; }
                if (e.key === 'Enter') { e.preventDefault(); this.selectSlashItem(); return; }
            }
        });
    }

    // Called from onUpdate — detects / input and opens slash menu
    handleSlashDetection() {
        const { state } = this.editor;
        const { $from } = state.selection;
        const textBefore = $from.parent.textContent.slice(0, $from.parentOffset);

        if (textBefore.endsWith('/')) {
            const lineText = $from.parent.textContent;
            if (lineText === '/' || lineText.endsWith(' /')) {
                this.openSlashMenu();
                return;
            }
        }

        if (this.slashMenu) {
            const match = textBefore.match(/\/([a-zA-Z0-9\u00C0-\u024F ]*)$/);
            if (match) {
                this.filterSlashMenu(match[1]);
            } else {
                this.closeSlashMenu();
            }
        }
    }

    openSlashMenu() {
        this.closeSlashMenu();

        this.slashMenu = document.createElement('div');
        this.slashMenu.className = 'tiptap-slash-menu';
        this.slashSelectedIndex = 0;
        this.slashFilteredItems = [...this.slashItems];

        this.renderSlashItems();

        // Position near cursor
        const { view } = this.editor;
        const coords = view.coordsAtPos(view.state.selection.from);
        const wrapperRect = this.wrapper.getBoundingClientRect();

        this.slashMenu.style.left = `${coords.left - wrapperRect.left}px`;
        this.slashMenu.style.top = `${coords.bottom - wrapperRect.top + 4}px`;

        this.wrapper.appendChild(this.slashMenu);

        // Close on click outside
        this._slashOutsideClick = (e) => {
            if (this.slashMenu && !this.slashMenu.contains(e.target)) {
                this.closeSlashMenu();
            }
        };
        setTimeout(() => document.addEventListener('click', this._slashOutsideClick), 10);
    }

    renderSlashItems() {
        if (!this.slashMenu) return;
        this.slashMenu.innerHTML = '';

        if (this.slashFilteredItems.length === 0) {
            this.slashMenu.innerHTML = '<div class="tiptap-slash-empty">Aucun resultat</div>';
            return;
        }

        this.slashFilteredItems.forEach((item, i) => {
            const el = document.createElement('button');
            el.type = 'button';
            el.className = 'tiptap-slash-item' + (i === this.slashSelectedIndex ? ' active' : '');
            el.innerHTML = `<i class="fas ${item.icon}"></i> ${item.label}`;
            el.addEventListener('mouseenter', () => {
                this.slashSelectedIndex = i;
                this.renderSlashItems();
            });
            el.addEventListener('click', (e) => {
                e.preventDefault();
                this.slashSelectedIndex = i;
                this.selectSlashItem();
            });
            this.slashMenu.appendChild(el);
        });
    }

    filterSlashMenu(query) {
        const q = query.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
        this.slashFilteredItems = this.slashItems.filter(item => {
            const label = item.label.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
            return label.includes(q);
        });
        this.slashSelectedIndex = 0;
        this.renderSlashItems();
    }

    navigateSlashMenu(direction) {
        this.slashSelectedIndex = (this.slashSelectedIndex + direction + this.slashFilteredItems.length) % this.slashFilteredItems.length;
        this.renderSlashItems();
    }

    selectSlashItem() {
        if (!this.slashFilteredItems[this.slashSelectedIndex]) return;

        // Delete the /query text
        const { state } = this.editor;
        const { $from } = state.selection;
        const textBefore = $from.parent.textContent.slice(0, $from.parentOffset);
        const slashIndex = textBefore.lastIndexOf('/');
        if (slashIndex >= 0) {
            const deleteFrom = $from.start() + slashIndex;
            const deleteTo = $from.pos;
            this.editor.chain().focus().deleteRange({ from: deleteFrom, to: deleteTo }).run();
        }

        // Execute the action
        this.slashFilteredItems[this.slashSelectedIndex].action();
        this.closeSlashMenu();
    }

    closeSlashMenu() {
        if (this.slashMenu) {
            this.slashMenu.remove();
            this.slashMenu = null;
        }
        if (this._slashOutsideClick) {
            document.removeEventListener('click', this._slashOutsideClick);
            this._slashOutsideClick = null;
        }
    }

    // ─── Commands ────────────────────────────────────────────────────────

    execCommand(cmd) {
        const chain = this.editor.chain().focus();

        switch (cmd) {
            case 'bold':         chain.toggleBold().run(); break;
            case 'italic':       chain.toggleItalic().run(); break;
            case 'underline':    chain.toggleUnderline().run(); break;
            case 'strike':       chain.toggleStrike().run(); break;
            case 'highlight':    chain.toggleHighlight().run(); break;
            case 'h2':           chain.toggleHeading({ level: 2 }).run(); break;
            case 'h3':           chain.toggleHeading({ level: 3 }).run(); break;
            case 'h4':           chain.toggleHeading({ level: 4 }).run(); break;
            case 'alignLeft':    chain.setTextAlign('left').run(); break;
            case 'alignCenter':  chain.setTextAlign('center').run(); break;
            case 'alignRight':   chain.setTextAlign('right').run(); break;
            case 'bulletList':   chain.toggleBulletList().run(); break;
            case 'orderedList':  chain.toggleOrderedList().run(); break;
            case 'blockquote':   chain.toggleBlockquote().run(); break;
            case 'codeBlock':    chain.toggleCodeBlock().run(); break;
            case 'callout':      this.openCalloutMenu(); break;
            case 'columns':      this.editor.chain().focus().setColumns().run(); break;
            case 'insertTable':  chain.insertTable({ rows: 3, cols: 3, withHeaderRow: true }).run(); break;
            case 'addColumnBefore': chain.addColumnBefore().run(); break;
            case 'addColumnAfter':  chain.addColumnAfter().run(); break;
            case 'addRowBefore':    chain.addRowBefore().run(); break;
            case 'addRowAfter':     chain.addRowAfter().run(); break;
            case 'toggleHeaderRow': chain.toggleHeaderRow().run(); break;
            case 'toggleHeaderColumn': chain.toggleHeaderColumn().run(); break;
            case 'mergeCells':      chain.mergeCells().run(); break;
            case 'splitCell':       chain.splitCell().run(); break;
            case 'deleteColumn':    chain.deleteColumn().run(); break;
            case 'deleteRow':       chain.deleteRow().run(); break;
            case 'deleteTable':     chain.deleteTable().run(); break;
            case 'horizontalRule': chain.setHorizontalRule().run(); break;
            case 'undo':         chain.undo().run(); break;
            case 'redo':         chain.redo().run(); break;
            case 'link':         this.toggleLink(); break;
            case 'image':        this.openMediaModal(); break;
            case 'youtube':      this.insertVideo(); break;
            case 'previewDesktop':  this.setPreviewMode('desktop'); break;
            case 'previewTablet':   this.setPreviewMode('tablet'); break;
            case 'previewMobile':   this.setPreviewMode('mobile'); break;
        }
    }

    // ─── Sync & State ────────────────────────────────────────────────────

    syncToTextarea() {
        const json = this.editor.getJSON();

        // Don't save empty documents (preserves old content on unedited articles)
        if (this.isEmptyDoc(json)) {
            this.textarea.value = '';
            return;
        }

        this.textarea.value = JSON.stringify(json);
        this.textarea.dispatchEvent(new Event('input', { bubbles: true }));
    }

    isEmptyDoc(doc) {
        const content = doc.content || [];
        if (content.length === 0) return true;
        return content.every(node =>
            node.type === 'paragraph' && (!node.content || node.content.length === 0)
        );
    }

    updateToolbarState() {
        this.toolbar.querySelectorAll('.tiptap-toolbar-btn').forEach(btn => {
            const cmd = btn.dataset.cmd;
            let active = false;

            switch (cmd) {
                case 'bold':        active = this.editor.isActive('bold'); break;
                case 'italic':      active = this.editor.isActive('italic'); break;
                case 'underline':   active = this.editor.isActive('underline'); break;
                case 'strike':      active = this.editor.isActive('strike'); break;
                case 'highlight':   active = this.editor.isActive('highlight'); break;
                case 'h2':          active = this.editor.isActive('heading', { level: 2 }); break;
                case 'h3':          active = this.editor.isActive('heading', { level: 3 }); break;
                case 'h4':          active = this.editor.isActive('heading', { level: 4 }); break;
                case 'alignLeft':   active = this.editor.isActive({ textAlign: 'left' }); break;
                case 'alignCenter': active = this.editor.isActive({ textAlign: 'center' }); break;
                case 'alignRight':  active = this.editor.isActive({ textAlign: 'right' }); break;
                case 'bulletList':  active = this.editor.isActive('bulletList'); break;
                case 'orderedList': active = this.editor.isActive('orderedList'); break;
                case 'blockquote':  active = this.editor.isActive('blockquote'); break;
                case 'codeBlock':   active = this.editor.isActive('codeBlock'); break;
                case 'callout':     active = this.editor.isActive('callout'); break;
                case 'columns':     active = this.editor.isActive('columns'); break;
                case 'insertTable': active = this.editor.isActive('table'); break;
                case 'link':        active = this.editor.isActive('link'); break;
            }

            btn.classList.toggle('is-active', active);
        });

        // Show/hide floating table context menu
        this.updateTableFloatingMenu();
    }

    // ─── Preview Mode ────────────────────────────────────────────────────

    setPreviewMode(mode) {
        // Toggle: clicking same mode reverts to desktop
        if (this.currentPreviewMode === mode && mode !== 'desktop') {
            mode = 'desktop';
        }
        this.currentPreviewMode = mode;

        // Remove all preview classes
        this.editorElement.classList.remove('tiptap-preview-desktop', 'tiptap-preview-tablet', 'tiptap-preview-mobile');
        this.editorElement.classList.add(`tiptap-preview-${mode}`);

        // Update toolbar button states
        this.toolbar.querySelectorAll('.tiptap-toolbar-btn').forEach(btn => {
            if (['previewDesktop', 'previewTablet', 'previewMobile'].includes(btn.dataset.cmd)) {
                btn.classList.toggle('is-active', btn.dataset.cmd === `preview${mode.charAt(0).toUpperCase() + mode.slice(1)}`);
            }
        });
    }

    // ─── Link ────────────────────────────────────────────────────────────

    toggleLink() {
        if (this.editor.isActive('link')) {
            this.editor.chain().focus().unsetLink().run();
            return;
        }
        this.openLinkModal();
    }

    openLinkModal() {
        if (this.linkModal) return;

        this.linkModal = document.createElement('div');
        this.linkModal.className = 'tiptap-modal';
        this.linkModal.innerHTML = `
            <div class="tiptap-modal-backdrop"></div>
            <div class="tiptap-modal-dialog" style="max-width:550px">
                <div class="tiptap-modal-header">
                    <h3>Inserer un lien</h3>
                    <button type="button" class="tiptap-modal-close">&times;</button>
                </div>
                <div class="tiptap-modal-body" style="padding:0">
                    <div style="padding:0.75rem 1.25rem;border-bottom:1px solid #dee2e6;">
                        <input type="text" class="form-control form-control-sm tiptap-link-search" placeholder="Rechercher une page, un article... ou collez une URL">
                    </div>
                    <div class="tiptap-link-results" style="max-height:300px;overflow-y:auto;padding:0.5rem"></div>
                </div>
                <div class="tiptap-modal-footer" style="display:flex;gap:0.5rem;align-items:center">
                    <label style="font-size:0.8rem;display:flex;align-items:center;gap:0.3rem;margin:0;cursor:pointer">
                        <input type="checkbox" class="tiptap-link-newtab"> Nouvel onglet
                    </label>
                    <div style="flex:1"></div>
                    <button type="button" class="btn btn-sm btn-primary tiptap-link-insert">Inserer</button>
                </div>
            </div>
        `;

        document.body.appendChild(this.linkModal);

        const searchInput = this.linkModal.querySelector('.tiptap-link-search');
        const resultsDiv = this.linkModal.querySelector('.tiptap-link-results');
        const insertBtn = this.linkModal.querySelector('.tiptap-link-insert');
        const newTabCheck = this.linkModal.querySelector('.tiptap-link-newtab');
        this.selectedLinkUrl = '';

        // Close
        this.linkModal.querySelector('.tiptap-modal-backdrop').addEventListener('click', () => this.closeLinkModal());
        this.linkModal.querySelector('.tiptap-modal-close').addEventListener('click', () => this.closeLinkModal());

        // Escape
        this._linkEscHandler = (e) => { if (e.key === 'Escape') this.closeLinkModal(); };
        document.addEventListener('keydown', this._linkEscHandler);

        // Insert button
        insertBtn.addEventListener('click', () => {
            const url = this.selectedLinkUrl || searchInput.value.trim();
            if (url) {
                const attrs = { href: url };
                if (newTabCheck.checked) attrs.target = '_blank';
                this.editor.chain().focus().extendMarkRange('link').setLink(attrs).run();
                this.closeLinkModal();
            }
        });

        // Enter to insert
        searchInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                insertBtn.click();
            }
        });

        // Load internal links
        this.loadInternalLinks(resultsDiv, searchInput);

        // Search filter with debounce
        let searchTimer = null;
        searchInput.addEventListener('input', () => {
            const val = searchInput.value.trim();
            // If it looks like an URL, select it directly
            if (val.startsWith('http') || val.startsWith('/') || val.startsWith('mailto:')) {
                this.selectedLinkUrl = val;
                resultsDiv.innerHTML = '<div style="padding:0.5rem;color:#6c757d;font-size:0.8rem">Appuyez sur Entree pour inserer ce lien externe</div>';
                return;
            }
            this.selectedLinkUrl = '';
            if (searchTimer) clearTimeout(searchTimer);
            searchTimer = setTimeout(() => this.loadInternalLinks(resultsDiv, searchInput), 200);
        });

        setTimeout(() => searchInput.focus(), 50);
    }

    async loadInternalLinks(resultsDiv, searchInput) {
        const q = searchInput.value.trim();
        const params = q ? `?q=${encodeURIComponent(q)}` : '';

        try {
            const response = await fetch(`/admin/api/links${params}`);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            const links = await response.json();

            resultsDiv.innerHTML = '';
            if (links.length === 0) {
                resultsDiv.innerHTML = '<div style="padding:1rem;color:#6c757d;text-align:center;font-size:0.85rem">Aucun resultat</div>';
                return;
            }

            let currentType = '';
            links.forEach(link => {
                if (link.type !== currentType) {
                    currentType = link.type;
                    const header = document.createElement('div');
                    header.style.cssText = 'padding:0.3rem 0.5rem;font-size:0.7rem;font-weight:600;color:#6c757d;text-transform:uppercase;letter-spacing:0.05em';
                    header.textContent = currentType + 's';
                    resultsDiv.appendChild(header);
                }

                const item = document.createElement('button');
                item.type = 'button';
                item.className = 'tiptap-link-item';
                item.innerHTML = `<span class="tiptap-link-item__title">${this.escapeHtml(link.title)}</span><span class="tiptap-link-item__url">${this.escapeHtml(link.url)}</span>`;
                item.addEventListener('click', () => {
                    resultsDiv.querySelectorAll('.tiptap-link-item').forEach(el => el.classList.remove('is-selected'));
                    item.classList.add('is-selected');
                    this.selectedLinkUrl = link.url;
                    searchInput.value = link.title;
                });
                item.addEventListener('dblclick', () => {
                    this.selectedLinkUrl = link.url;
                    this.linkModal.querySelector('.tiptap-link-insert').click();
                });
                resultsDiv.appendChild(item);
            });
        } catch (err) {
            resultsDiv.innerHTML = '<div style="padding:1rem;color:#dc3545;text-align:center;font-size:0.85rem">Erreur de chargement</div>';
        }
    }

    closeLinkModal() {
        if (this.linkModal) {
            this.linkModal.remove();
            this.linkModal = null;
        }
        if (this._linkEscHandler) {
            document.removeEventListener('keydown', this._linkEscHandler);
            this._linkEscHandler = null;
        }
        this.editor.commands.focus();
    }

    // ─── Video ───────────────────────────────────────────────────────────

    insertVideo() {
        const url = prompt('URL de la video (YouTube ou Vimeo) :');
        if (url && url.trim()) {
            this.editor.commands.setYoutubeVideo({ src: url.trim() });
        }
    }

    // ─── Callout Menu ─────────────────────────────────────────────────

    openCalloutMenu() {
        // If already in a callout, remove it
        if (this.editor.isActive('callout')) {
            this.editor.chain().focus().unsetCallout().run();
            return;
        }

        // Create dropdown menu
        const btn = this.toolbar.querySelector('[data-cmd="callout"]');
        const rect = btn.getBoundingClientRect();

        const menu = document.createElement('div');
        menu.className = 'tiptap-callout-menu';
        menu.style.position = 'fixed';
        menu.style.left = rect.left + 'px';
        menu.style.top = rect.bottom + 4 + 'px';
        menu.style.zIndex = '10000';

        const types = [
            { type: 'info', icon: 'fa-info-circle', label: 'Information', color: '#3b82f6' },
            { type: 'warning', icon: 'fa-exclamation-triangle', label: 'Attention', color: '#f59e0b' },
            { type: 'success', icon: 'fa-check-circle', label: 'Succes', color: '#22c55e' },
            { type: 'danger', icon: 'fa-times-circle', label: 'Danger', color: '#ef4444' },
        ];

        types.forEach(t => {
            const item = document.createElement('button');
            item.type = 'button';
            item.className = 'tiptap-callout-menu__item';
            item.innerHTML = `<i class="fas ${t.icon}" style="color:${t.color}"></i> ${t.label}`;
            item.addEventListener('click', (e) => {
                e.preventDefault();
                this.editor.chain().focus().toggleCallout({ type: t.type }).run();
                menu.remove();
                this._calloutMenuCleanup?.();
            });
            menu.appendChild(item);
        });

        document.body.appendChild(menu);

        // Close on click outside
        const closeMenu = (e) => {
            if (!menu.contains(e.target) && e.target !== btn) {
                menu.remove();
                document.removeEventListener('click', closeMenu);
            }
        };
        this._calloutMenuCleanup = () => document.removeEventListener('click', closeMenu);
        setTimeout(() => document.addEventListener('click', closeMenu), 0);
    }

    // ─── Table Floating Menu ─────────────────────────────────────────────

    updateTableFloatingMenu() {
        const inTable = this.editor.isActive('table');

        if (!inTable) {
            this.removeTableFloatingMenu();
            return;
        }

        // Already showing — just reposition
        if (this.tableFloatingMenu) {
            this.positionTableMenu();
            return;
        }

        this.createTableFloatingMenu();
    }

    createTableFloatingMenu() {
        this.tableFloatingMenu = document.createElement('div');
        this.tableFloatingMenu.className = 'tiptap-table-contextbar';

        const actions = [
            { cmd: 'addColumnBefore', icon: 'fa-arrow-left', label: 'Col. avant' },
            { cmd: 'addColumnAfter', icon: 'fa-arrow-right', label: 'Col. apres' },
            { cmd: 'addRowBefore', icon: 'fa-arrow-up', label: 'Ligne avant' },
            { cmd: 'addRowAfter', icon: 'fa-arrow-down', label: 'Ligne apres' },
            { cmd: 'divider' },
            { cmd: 'toggleHeaderRow', icon: 'fa-heading', label: 'En-tete' },
            { cmd: 'mergeCells', icon: 'fa-compress-alt', label: 'Fusionner' },
            { cmd: 'splitCell', icon: 'fa-expand-alt', label: 'Scinder' },
            { cmd: 'divider' },
            { cmd: 'deleteColumn', icon: 'fa-times', label: 'Suppr. col.', danger: true },
            { cmd: 'deleteRow', icon: 'fa-times', label: 'Suppr. ligne', danger: true },
            { cmd: 'deleteTable', icon: 'fa-trash', label: 'Suppr. tableau', danger: true },
        ];

        actions.forEach(action => {
            if (action.cmd === 'divider') {
                const sep = document.createElement('span');
                sep.className = 'tiptap-table-contextbar__sep';
                this.tableFloatingMenu.appendChild(sep);
                return;
            }

            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'tiptap-table-contextbar__btn' + (action.danger ? ' is-danger' : '');
            btn.title = action.label;
            btn.innerHTML = `<i class="fas ${action.icon}"></i><span>${action.label}</span>`;
            btn.addEventListener('mousedown', (e) => {
                e.preventDefault();
                this.execCommand(action.cmd);
            });
            this.tableFloatingMenu.appendChild(btn);
        });

        // Insert between toolbar and editor content — fixed contextual bar
        this.wrapper.insertBefore(this.tableFloatingMenu, this.editorElement);
    }

    removeTableFloatingMenu() {
        if (this.tableFloatingMenu) {
            this.tableFloatingMenu.remove();
            this.tableFloatingMenu = null;
        }
    }

    // ─── Media Modal ─────────────────────────────────────────────────────

    openMediaModal() {
        if (this.mediaModal) return; // prevent double-open

        this.mediaModal = document.createElement('div');
        this.mediaModal.className = 'tiptap-modal';
        this.mediaModal.innerHTML = `
            <div class="tiptap-modal-backdrop"></div>
            <div class="tiptap-modal-dialog">
                <div class="tiptap-modal-header">
                    <h3>Bibliotheque de medias</h3>
                    <button type="button" class="tiptap-modal-close">&times;</button>
                </div>
                <div class="tiptap-modal-body">
                    <div class="tiptap-media-loading">Chargement des medias...</div>
                    <div class="tiptap-media-grid" style="display:none"></div>
                    <div class="tiptap-media-empty" style="display:none">Aucun media disponible</div>
                </div>
                <div class="tiptap-modal-footer">
                    <div class="tiptap-url-insert">
                        <input type="text" placeholder="Ou collez une URL d'image..." class="form-control form-control-sm">
                        <button type="button" class="btn btn-sm btn-primary">Inserer</button>
                    </div>
                </div>
            </div>
        `;

        document.body.appendChild(this.mediaModal);

        // Close events
        this.mediaModal.querySelector('.tiptap-modal-backdrop')
            .addEventListener('click', () => this.closeMediaModal());
        this.mediaModal.querySelector('.tiptap-modal-close')
            .addEventListener('click', () => this.closeMediaModal());

        // URL insert
        const urlInput = this.mediaModal.querySelector('.tiptap-url-insert input');
        const urlBtn = this.mediaModal.querySelector('.tiptap-url-insert button');
        urlBtn.addEventListener('click', () => {
            const url = urlInput.value.trim();
            if (url) {
                this.editor.chain().focus().setImage({ src: url }).run();
                this.closeMediaModal();
            }
        });
        urlInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                urlBtn.click();
            }
        });

        // Escape to close
        this._escHandler = (e) => {
            if (e.key === 'Escape') this.closeMediaModal();
        };
        document.addEventListener('keydown', this._escHandler);

        // Load media list
        this.loadMediaList();
    }

    async loadMediaList() {
        const grid = this.mediaModal.querySelector('.tiptap-media-grid');
        const loading = this.mediaModal.querySelector('.tiptap-media-loading');
        const empty = this.mediaModal.querySelector('.tiptap-media-empty');

        try {
            const response = await fetch('/admin/api/media/list');
            if (!response.ok) throw new Error(`HTTP ${response.status}`);

            const data = await response.json();
            loading.style.display = 'none';

            if (!data.length) {
                empty.style.display = 'block';
                return;
            }

            grid.style.display = 'grid';

            data.forEach(media => {
                const item = document.createElement('div');
                item.className = 'tiptap-media-item';
                const src = `/documents/medias/${media.file_name}`;
                item.innerHTML = `
                    <img src="${src}" alt="${this.escapeHtml(media.name)}" loading="lazy">
                    <span class="tiptap-media-name">${this.escapeHtml(media.name)}</span>
                `;
                item.addEventListener('click', () => {
                    this.editor.chain().focus().setImage({
                        src: src,
                        alt: media.name,
                    }).run();
                    this.closeMediaModal();
                });
                grid.appendChild(item);
            });
        } catch (err) {
            loading.textContent = 'Erreur de chargement des medias';
            console.error('[TipTap] Media list error:', err);
        }
    }

    closeMediaModal() {
        if (this.mediaModal) {
            this.mediaModal.remove();
            this.mediaModal = null;
        }
        if (this._escHandler) {
            document.removeEventListener('keydown', this._escHandler);
            this._escHandler = null;
        }
    }

    // ─── Save Helpers ──────────────────────────────────────────────────

    setupAjaxSave() {
        this.isDirty = false;

        // Ctrl+S / Cmd+S triggers form submit
        document.addEventListener('keydown', (e) => {
            if ((e.ctrlKey || e.metaKey) && e.key === 's') {
                e.preventDefault();
                this.saveForm();
            }
        });

        // Warn before leaving with unsaved changes
        window.addEventListener('beforeunload', (e) => {
            if (this.isDirty) {
                e.preventDefault();
                e.returnValue = '';
            }
        });

        // On form submit, mark as clean
        const form = this.textarea.closest('form');
        if (form) {
            form.addEventListener('submit', () => {
                this.isDirty = false;
            });
        }
    }

    scheduleAjaxSave() {
        // Just track dirty state — no auto-submit
        this.isDirty = true;
        this.showIndicator('Modifications non enregistrees');
    }

    saveForm() {
        this.syncToTextarea();
        const form = this.textarea.closest('form');
        if (form) {
            this.isDirty = false;
            // Click the EasyAdmin submit button
            const submitBtn = form.querySelector('button[type="submit"], .action-saveAndReturn button, .btn-primary[type="submit"]');
            if (submitBtn) {
                submitBtn.click();
            } else {
                form.submit();
            }
        }
    }

    showIndicator(text) {
        this.indicator.textContent = text;
        this.indicator.classList.add('visible');
        setTimeout(() => this.indicator.classList.remove('visible'), 2500);
    }

    // ─── Utilities ───────────────────────────────────────────────────────

    escapeHtml(str) {
        const div = document.createElement('div');
        div.textContent = str;
        return div.innerHTML;
    }

    destroy() {
        if (this.ajaxSaveTimer) clearTimeout(this.ajaxSaveTimer);
        if (this.editor) this.editor.destroy();
        this.removeTableFloatingMenu();
        this.closeMediaModal();
    }
}

// ─── Auto-init ───────────────────────────────────────────────────────────────
// EasyAdmin 4 uses Turbo — DOMContentLoaded only fires once.
// We need turbo:load for subsequent navigations + DOMContentLoaded for first load.

function initTiptapEditors() {
    document.querySelectorAll('[data-tiptap-editor]').forEach(textarea => {
        // Avoid double-init
        if (textarea.dataset.tiptapInitialized) return;
        textarea.dataset.tiptapInitialized = 'true';
        new TiptapEditor(textarea);
    });
}

document.addEventListener('DOMContentLoaded', initTiptapEditors);
document.addEventListener('turbo:load', initTiptapEditors);
document.addEventListener('turbo:render', initTiptapEditors);

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
        this.createAutosaveIndicator();
        this.createEditor();
        this.checkDraft();
        this.setupAutosave();

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

    createAutosaveIndicator() {
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
                Callout,
                Columns,
                Column,
            ],
            content: this.initialContent,
            onUpdate: () => {
                this.syncToTextarea();
                this.updateToolbarState();
                this.updateCharCount();
                this.scheduleDraftSave();
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

        // Listen for / character input
        this.editor.on('update', () => {
            const { state } = this.editor;
            const { $from } = state.selection;
            const textBefore = $from.parent.textContent.slice(0, $from.parentOffset);

            if (textBefore.endsWith('/')) {
                // Check we're in an empty paragraph or the line starts with /
                const lineText = $from.parent.textContent;
                if (lineText === '/' || lineText.endsWith(' /')) {
                    this.openSlashMenu();
                    return;
                }
            }

            if (this.slashMenu) {
                // Filter items based on text after /
                const match = textBefore.match(/\/([a-zA-Z0-9\u00C0-\u024F ]*)$/);
                if (match) {
                    this.filterSlashMenu(match[1]);
                } else {
                    this.closeSlashMenu();
                }
            }
        });
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
            case 'horizontalRule': chain.setHorizontalRule().run(); break;
            case 'undo':         chain.undo().run(); break;
            case 'redo':         chain.redo().run(); break;
            case 'link':         this.toggleLink(); break;
            case 'image':        this.openMediaModal(); break;
            case 'youtube':      this.insertVideo(); break;
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
                case 'link':        active = this.editor.isActive('link'); break;
            }

            btn.classList.toggle('is-active', active);
        });
    }

    // ─── Link ────────────────────────────────────────────────────────────

    toggleLink() {
        // If already a link, unset it
        if (this.editor.isActive('link')) {
            this.editor.chain().focus().unsetLink().run();
            return;
        }

        const url = prompt('URL du lien :');
        if (url && url.trim()) {
            this.editor.chain().focus()
                .extendMarkRange('link')
                .setLink({ href: url.trim() })
                .run();
        }
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

    // ─── Autosave ────────────────────────────────────────────────────────

    setupAutosave() {
        // Periodic save every 30s
        this.autosaveInterval = setInterval(() => this.saveDraft(), 30000);

        // Save on page unload
        window.addEventListener('beforeunload', () => this.saveDraft());

        // Clear draft on successful form submit
        const form = this.textarea.closest('form');
        if (form) {
            form.addEventListener('submit', () => this.clearDraft());
        }
    }

    scheduleDraftSave() {
        if (this.autosaveTimer) clearTimeout(this.autosaveTimer);
        this.autosaveTimer = setTimeout(() => this.saveDraft(), 5000);
    }

    saveDraft() {
        try {
            const json = this.editor.getJSON();
            if (this.isEmptyDoc(json)) return; // Don't save empty drafts

            localStorage.setItem(this.autosaveKey, JSON.stringify({
                content: json,
                savedAt: Date.now(),
            }));
            this.showIndicator('Brouillon sauvegarde');
        } catch (e) {
            // localStorage full or unavailable — fail silently
        }
    }

    checkDraft() {
        try {
            const raw = localStorage.getItem(this.autosaveKey);
            if (!raw) return;

            const data = JSON.parse(raw);
            if (!data.content || !data.savedAt) return;

            // Discard drafts older than 24h
            if (Date.now() - data.savedAt > 86400000) {
                this.clearDraft();
                return;
            }

            // Show restore banner
            const banner = document.createElement('div');
            banner.className = 'tiptap-draft-banner';

            const date = new Date(data.savedAt);
            const timeStr = date.toLocaleString('fr-FR', {
                day: '2-digit', month: '2-digit', year: 'numeric',
                hour: '2-digit', minute: '2-digit',
            });

            banner.innerHTML = `
                <span>Brouillon trouve (${timeStr})</span>
                <div>
                    <button type="button" class="btn btn-sm btn-outline-primary tiptap-draft-restore">Restaurer</button>
                    <button type="button" class="btn btn-sm btn-outline-secondary tiptap-draft-dismiss">Ignorer</button>
                </div>
            `;

            this.wrapper.insertBefore(banner, this.toolbar);

            banner.querySelector('.tiptap-draft-restore').addEventListener('click', () => {
                this.editor.commands.setContent(data.content);
                this.syncToTextarea();
                banner.remove();
                this.showIndicator('Brouillon restaure');
            });

            banner.querySelector('.tiptap-draft-dismiss').addEventListener('click', () => {
                this.clearDraft();
                banner.remove();
            });
        } catch (e) {
            // Corrupt data — ignore
        }
    }

    clearDraft() {
        localStorage.removeItem(this.autosaveKey);
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
        if (this.autosaveInterval) clearInterval(this.autosaveInterval);
        if (this.autosaveTimer) clearTimeout(this.autosaveTimer);
        if (this.editor) this.editor.destroy();
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

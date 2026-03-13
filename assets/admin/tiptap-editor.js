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
                { cmd: 'strike', icon: 'fa-strikethrough', title: 'Barrer' },
            ],
            // Headings
            [
                { cmd: 'h2', text: 'H2', title: 'Titre 2' },
                { cmd: 'h3', text: 'H3', title: 'Titre 3' },
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
        this.indicator = document.createElement('div');
        this.indicator.className = 'tiptap-autosave-indicator';
        this.wrapper.appendChild(this.indicator);
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
            ],
            content: this.initialContent,
            onUpdate: () => {
                this.syncToTextarea();
                this.updateToolbarState();
                this.scheduleDraftSave();
            },
            onSelectionUpdate: () => {
                this.updateToolbarState();
            },
        });
    }

    // ─── Commands ────────────────────────────────────────────────────────

    execCommand(cmd) {
        const chain = this.editor.chain().focus();

        switch (cmd) {
            case 'bold':         chain.toggleBold().run(); break;
            case 'italic':       chain.toggleItalic().run(); break;
            case 'strike':       chain.toggleStrike().run(); break;
            case 'h2':           chain.toggleHeading({ level: 2 }).run(); break;
            case 'h3':           chain.toggleHeading({ level: 3 }).run(); break;
            case 'bulletList':   chain.toggleBulletList().run(); break;
            case 'orderedList':  chain.toggleOrderedList().run(); break;
            case 'blockquote':   chain.toggleBlockquote().run(); break;
            case 'codeBlock':    chain.toggleCodeBlock().run(); break;
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
                case 'strike':      active = this.editor.isActive('strike'); break;
                case 'h2':          active = this.editor.isActive('heading', { level: 2 }); break;
                case 'h3':          active = this.editor.isActive('heading', { level: 3 }); break;
                case 'bulletList':  active = this.editor.isActive('bulletList'); break;
                case 'orderedList': active = this.editor.isActive('orderedList'); break;
                case 'blockquote':  active = this.editor.isActive('blockquote'); break;
                case 'codeBlock':   active = this.editor.isActive('codeBlock'); break;
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

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('[data-tiptap-editor]').forEach(textarea => {
        new TiptapEditor(textarea);
    });
});

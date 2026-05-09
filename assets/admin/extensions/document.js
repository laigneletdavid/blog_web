/**
 * TipTap Document Node — Carte cliquable pour fichiers (PDF, DOCX, ZIP, etc.)
 *
 * Stockage en JSON natif TipTap. Le rendu HTML cote serveur (BlockRenderer.php)
 * doit produire la meme structure pour rester sanitizer-friendly.
 */
import { Node, mergeAttributes } from '@tiptap/core';

export const Document = Node.create({
    name: 'document',

    group: 'block',

    atom: true,

    selectable: true,

    draggable: true,

    addAttributes() {
        return {
            documentId: { default: null },
            name: { default: '' },
            fileName: { default: '' },
            extension: { default: '' },
            size: { default: null },
            sizeHuman: { default: '' },
            icon: { default: 'fa-file' },
            url: { default: '' },
        };
    },

    parseHTML() {
        return [
            { tag: 'a.block-document' },
        ];
    },

    renderHTML({ node }) {
        const attrs = node.attrs;
        return [
            'a',
            mergeAttributes({
                class: 'block-document',
                href: attrs.url || '#',
                target: '_blank',
                rel: 'noopener noreferrer',
                download: attrs.name || attrs.fileName || '',
                'data-document-id': attrs.documentId ?? '',
                'data-extension': attrs.extension || '',
            }),
            ['span', { class: 'block-document__icon' }, ['i', { class: `fas ${attrs.icon || 'fa-file'}` }]],
            ['span', { class: 'block-document__body' },
                ['span', { class: 'block-document__name' }, attrs.name || attrs.fileName || 'Document'],
                ['span', { class: 'block-document__meta' },
                    `${(attrs.extension || '').toUpperCase()}${attrs.sizeHuman ? ' · ' + attrs.sizeHuman : ''}`,
                ],
            ],
            ['span', { class: 'block-document__action' }, ['i', { class: 'fas fa-download' }]],
        ];
    },

    addCommands() {
        return {
            insertDocument: (attributes) => ({ commands }) => {
                return commands.insertContent({
                    type: this.name,
                    attrs: attributes,
                });
            },
        };
    },
});

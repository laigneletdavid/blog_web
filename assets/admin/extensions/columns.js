/**
 * TipTap Columns Node — Layout 2 colonnes
 */
import { Node, mergeAttributes } from '@tiptap/core';

export const Columns = Node.create({
    name: 'columns',

    group: 'block',

    content: 'column column',

    defining: true,

    parseHTML() {
        return [
            { tag: 'div[data-columns]' },
        ];
    },

    renderHTML({ HTMLAttributes }) {
        return ['div', mergeAttributes(HTMLAttributes, {
            'data-columns': '',
            class: 'block-columns',
        }), 0];
    },

    addCommands() {
        return {
            setColumns: () => ({ commands, editor }) => {
                return commands.insertContent({
                    type: 'columns',
                    content: [
                        {
                            type: 'column',
                            content: [{ type: 'paragraph' }],
                        },
                        {
                            type: 'column',
                            content: [{ type: 'paragraph' }],
                        },
                    ],
                });
            },
        };
    },
});

export const Column = Node.create({
    name: 'column',

    group: '',

    content: 'block+',

    defining: true,

    parseHTML() {
        return [
            { tag: 'div[data-column]' },
        ];
    },

    renderHTML({ HTMLAttributes }) {
        return ['div', mergeAttributes(HTMLAttributes, {
            'data-column': '',
            class: 'block-column',
        }), 0];
    },
});

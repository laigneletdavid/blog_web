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
            /**
             * Supprime le bloc columns englobant la selection courante en
             * preservant son contenu : les enfants des deux colonnes sont
             * concatenes et remplacent le bloc columns.
             */
            unsetColumns: () => ({ state, dispatch }) => {
                const { $from } = state.selection;

                // Remonter jusqu'a trouver un noeud 'columns' parent
                for (let depth = $from.depth; depth > 0; depth--) {
                    const node = $from.node(depth);
                    if (node.type.name === 'columns') {
                        if (!dispatch) {
                            return true;
                        }
                        // Collecter le contenu de chaque colonne
                        const fragments = [];
                        node.forEach((col) => {
                            col.forEach((child) => fragments.push(child));
                        });
                        const before = $from.before(depth);
                        const after = $from.after(depth);
                        const tr = state.tr.replaceWith(before, after, fragments);
                        dispatch(tr);
                        return true;
                    }
                }
                return false;
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

/**
 * TipTap Callout Node — Encarts info/warning/success/danger
 */
import { Node, mergeAttributes } from '@tiptap/core';

export const Callout = Node.create({
    name: 'callout',

    group: 'block',

    content: 'block+',

    defining: true,

    addAttributes() {
        return {
            type: {
                default: 'info',
                parseHTML: element => element.getAttribute('data-callout') || 'info',
                renderHTML: attributes => ({
                    'data-callout': attributes.type,
                    class: `block-callout block-callout--${attributes.type}`,
                }),
            },
        };
    },

    parseHTML() {
        return [
            { tag: 'div[data-callout]' },
        ];
    },

    renderHTML({ HTMLAttributes }) {
        return ['div', mergeAttributes(HTMLAttributes), 0];
    },

    addCommands() {
        return {
            setCallout: (attributes) => ({ commands }) => {
                return commands.wrapIn(this.name, attributes);
            },
            toggleCallout: (attributes) => ({ commands }) => {
                // If already in a callout, lift it out
                if (this.editor.isActive('callout', attributes)) {
                    return commands.lift(this.name);
                }
                // If in a different callout type, update it
                if (this.editor.isActive('callout')) {
                    return commands.updateAttributes(this.name, attributes);
                }
                return commands.wrapIn(this.name, attributes);
            },
            unsetCallout: () => ({ commands }) => {
                return commands.lift(this.name);
            },
        };
    },
});

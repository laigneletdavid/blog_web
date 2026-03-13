import Sortable from 'sortablejs';
import './menu-sortable.scss';

class MenuSortableManager {
    constructor(container) {
        this.container = container;
        this.reorderUrl = container.dataset.reorderUrl;
        this.csrfToken = container.dataset.csrfToken;
        this.toggleBaseUrl = container.dataset.toggleUrl; // ends with /0
        this.init();
    }

    init() {
        const rootList = this.container.querySelector('[data-sortable-root]');
        if (!rootList) return;

        // Root sortable
        Sortable.create(rootList, {
            group: { name: 'menu', pull: true, put: true },
            animation: 150,
            handle: '.drag-handle',
            draggable: '.menu-sortable-item',
            ghostClass: 'menu-sortable-ghost',
            chosenClass: 'menu-sortable-chosen',
            onEnd: () => this.saveOrder(),
            onMove: (evt) => {
                // Prevent 3+ levels of nesting
                if (evt.to.closest('.menu-sortable-children') &&
                    evt.to.parentElement.closest('.menu-sortable-children')) {
                    return false;
                }
                return true;
            },
        });

        // Child sortables
        this.container.querySelectorAll('[data-sortable-children]').forEach((childList) => {
            Sortable.create(childList, {
                group: { name: 'menu', pull: true, put: true },
                animation: 150,
                handle: '.drag-handle',
                draggable: '.menu-sortable-item',
                ghostClass: 'menu-sortable-ghost',
                chosenClass: 'menu-sortable-chosen',
                onEnd: () => this.saveOrder(),
                onMove: (evt) => {
                    // Don't allow items with children to become children
                    const draggedChildren = evt.dragged.querySelector('[data-sortable-children]');
                    if (draggedChildren && draggedChildren.children.length > 0 &&
                        evt.to.hasAttribute('data-sortable-children')) {
                        return false;
                    }
                    return true;
                },
            });
        });

        // Visibility toggle buttons
        this.container.addEventListener('click', (e) => {
            const btn = e.target.closest('[data-toggle-visibility]');
            if (btn) {
                e.preventDefault();
                this.toggleVisibility(btn);
            }
        });
    }

    async saveOrder() {
        const items = [];
        const rootList = this.container.querySelector('[data-sortable-root]');

        rootList.querySelectorAll(':scope > .menu-sortable-item').forEach((el, index) => {
            items.push({
                id: parseInt(el.dataset.id),
                position: index,
                parentId: null,
            });

            const childrenZone = el.querySelector('[data-sortable-children]');
            if (childrenZone) {
                childrenZone.querySelectorAll(':scope > .menu-sortable-item').forEach((childEl, childIndex) => {
                    items.push({
                        id: parseInt(childEl.dataset.id),
                        position: childIndex,
                        parentId: parseInt(el.dataset.id),
                    });
                });
            }
        });

        try {
            const response = await fetch(this.reorderUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': this.csrfToken,
                },
                body: JSON.stringify({ items }),
            });

            if (!response.ok) {
                console.error('Menu reorder failed:', await response.text());
            }
        } catch (err) {
            console.error('Menu reorder error:', err);
        }
    }

    async toggleVisibility(btn) {
        const id = btn.dataset.id;
        // Replace trailing /0 with /{id}
        const url = this.toggleBaseUrl.replace(/\/0$/, `/${id}`);

        try {
            const response = await fetch(url, {
                method: 'POST',
                headers: {
                    'X-CSRF-Token': this.csrfToken,
                },
            });

            if (response.ok) {
                const data = await response.json();
                const icon = btn.querySelector('i');

                if (data.visible) {
                    btn.classList.remove('btn-outline-secondary');
                    btn.classList.add('btn-success');
                    btn.title = 'Visible';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                } else {
                    btn.classList.remove('btn-success');
                    btn.classList.add('btn-outline-secondary');
                    btn.title = 'Masqué';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                }
            }
        } catch (err) {
            console.error('Toggle visibility error:', err);
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const container = document.querySelector('[data-menu-sortable]');
    if (container) {
        new MenuSortableManager(container);
    }
});

import Sortable from 'sortablejs';
import './menu-sortable.scss';

class MenuManager {
    constructor(el) {
        this.el = el;
        this.csrfToken = el.dataset.csrfToken;
        this.urls = {
            reorder: el.dataset.urlReorder,
            toggle: el.dataset.urlToggle,
            add: el.dataset.urlAdd,
            delete: el.dataset.urlDelete,
            rename: el.dataset.urlRename,
        };
        this.activeLocation = 'header';
        this.sortables = [];

        this.initTabs();
        this.initSortables();
        this.initSourceButtons();
        this.initCustomLink();
        this.initParent();
        this.initVisibilityToggles();
        this.initDeleteButtons();
        this.initInlineEdit();
    }

    // ─── TABS ───
    initTabs() {
        this.el.querySelectorAll('.menu-zone-tabs .nav-link').forEach(tab => {
            tab.addEventListener('shown.bs.tab', () => {
                this.activeLocation = tab.dataset.location;
                this.initSortables();
            });
        });
    }

    // ─── SORTABLE ───
    initSortables() {
        this.sortables.forEach(s => s.destroy());
        this.sortables = [];

        const activePane = this.el.querySelector(`#zone-${this.activeLocation}`);
        if (!activePane) return;

        const rootList = activePane.querySelector('[data-sortable-zone]');
        if (rootList) {
            this.sortables.push(Sortable.create(rootList, {
                group: { name: 'menu-' + this.activeLocation, pull: true, put: true },
                handle: '.drag-handle',
                animation: 200,
                ghostClass: 'menu-sortable-ghost',
                chosenClass: 'menu-sortable-chosen',
                onEnd: () => this.saveOrder(),
                onMove: (evt) => this.validateNesting(evt),
            }));
        }

        activePane.querySelectorAll('[data-sortable-children]').forEach(childList => {
            this.sortables.push(Sortable.create(childList, {
                group: { name: 'menu-' + this.activeLocation, pull: true, put: true },
                handle: '.drag-handle',
                animation: 200,
                ghostClass: 'menu-sortable-ghost',
                chosenClass: 'menu-sortable-chosen',
                onEnd: () => this.saveOrder(),
                onMove: (evt) => this.validateNesting(evt),
            }));
        });
    }

    validateNesting(evt) {
        if (evt.to.hasAttribute('data-sortable-children')) {
            const childZone = evt.dragged.querySelector('[data-sortable-children]');
            if (childZone && childZone.children.length > 0) return false;
        }
        return true;
    }

    saveOrder() {
        const activePane = this.el.querySelector(`#zone-${this.activeLocation}`);
        if (!activePane) return;

        const items = [];
        const rootList = activePane.querySelector('[data-sortable-zone]');
        if (!rootList) return;

        rootList.querySelectorAll(':scope > .menu-sortable-item').forEach((item, index) => {
            items.push({ id: parseInt(item.dataset.id), position: index, parentId: null });
            const childZone = item.querySelector('[data-sortable-children]');
            if (childZone) {
                childZone.querySelectorAll(':scope > .menu-sortable-item').forEach((child, ci) => {
                    items.push({ id: parseInt(child.dataset.id), position: ci, parentId: parseInt(item.dataset.id) });
                });
            }
        });

        fetch(this.urls.reorder, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': this.csrfToken },
            body: JSON.stringify({ items }),
        }).catch(err => console.error('Reorder failed:', err));
    }

    // ─── SOURCE BUTTONS ───
    initSourceButtons() {
        this.el.querySelectorAll('.source-add-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const container = btn.closest('.source-items');
                const checked = container.querySelectorAll('input[type="checkbox"]:checked');
                if (checked.length === 0) return;

                checked.forEach(cb => {
                    const data = { name: cb.value, location: this.activeLocation, target: cb.dataset.target || 'url' };
                    if (cb.dataset.route) data.route = cb.dataset.route;
                    if (cb.dataset.pageId) data.pageId = parseInt(cb.dataset.pageId);
                    if (cb.dataset.categorieId) data.categorieId = parseInt(cb.dataset.categorieId);
                    this.addItem(data);
                    cb.checked = false;
                });
            });
        });
    }

    // ─── CUSTOM LINK ───
    initCustomLink() {
        const btn = document.getElementById('addCustomLink');
        if (!btn) return;
        btn.addEventListener('click', () => {
            const nameInput = document.getElementById('customLinkName');
            const urlInput = document.getElementById('customLinkUrl');
            const name = nameInput.value.trim();
            const url = urlInput.value.trim();
            if (!name || !url) return;
            this.addItem({ name, location: this.activeLocation, url, target: 'url' });
            nameInput.value = '';
            urlInput.value = '';
        });
    }

    // ─── PARENT ───
    initParent() {
        const btn = document.getElementById('addParent');
        if (!btn) return;
        btn.addEventListener('click', () => {
            const nameInput = document.getElementById('parentName');
            const name = nameInput.value.trim() || 'Sous-menu';
            this.addItem({ name, location: this.activeLocation, target: 'parent' });
            nameInput.value = '';
        });
    }

    // ─── ADD ITEM ───
    async addItem(data) {
        try {
            const res = await fetch(this.urls.add, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': this.csrfToken },
                body: JSON.stringify(data),
            });
            const result = await res.json();
            if (!result.success) return;
            this.appendItemToDOM(result.item);
            this.updateCount(this.activeLocation);
            this.hideEmptyState(this.activeLocation);
        } catch (err) {
            console.error('Add failed:', err);
        }
    }

    appendItemToDOM(item) {
        const zone = this.el.querySelector(`#zone-${this.activeLocation} [data-sortable-zone]`);
        if (!zone) return;

        const badgeClass = item.target === 'page' ? 'bg-success' :
                           item.target === 'categorie' ? 'bg-warning' :
                           item.route ? 'bg-primary' : 'bg-secondary';
        const badgeText = item.target === 'page' ? 'Page' :
                          item.target === 'categorie' ? 'Catégorie' :
                          item.route ? 'Module' : 'Lien';

        const div = document.createElement('div');
        div.className = 'menu-sortable-item';
        div.dataset.id = item.id;
        div.dataset.system = '0';
        div.innerHTML = `
            <div class="menu-item-row">
                <span class="drag-handle"><i class="fas fa-grip-vertical"></i></span>
                <span class="menu-item-name" data-id="${item.id}">${this.esc(item.name)}</span>
                <span class="badge ${badgeClass} badge-type">${badgeText}</span>
                <div class="menu-item-actions">
                    <button type="button" class="btn btn-sm btn-toggle-visibility" data-id="${item.id}" title="Masquer">
                        <i class="fas fa-eye"></i>
                    </button>
                    <button type="button" class="btn btn-sm btn-delete-item" data-id="${item.id}" title="Supprimer">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </div>
            <div class="menu-sortable-children" data-sortable-children="${item.id}"></div>
        `;

        zone.appendChild(div);
        this.bindVisibility(div.querySelector('.btn-toggle-visibility'));
        this.bindDelete(div.querySelector('.btn-delete-item'));
        this.bindNameEdit(div.querySelector('.menu-item-name'));

        const childZone = div.querySelector('[data-sortable-children]');
        this.sortables.push(Sortable.create(childZone, {
            group: { name: 'menu-' + this.activeLocation, pull: true, put: true },
            handle: '.drag-handle',
            animation: 200,
            ghostClass: 'menu-sortable-ghost',
            chosenClass: 'menu-sortable-chosen',
            onEnd: () => this.saveOrder(),
            onMove: (evt) => this.validateNesting(evt),
        }));
    }

    // ─── VISIBILITY ───
    initVisibilityToggles() {
        this.el.querySelectorAll('.btn-toggle-visibility').forEach(btn => this.bindVisibility(btn));
    }

    bindVisibility(btn) {
        if (!btn) return;
        btn.addEventListener('click', async () => {
            const id = btn.dataset.id;
            const url = this.urls.toggle.replace('/0', '/' + id);
            try {
                const res = await fetch(url, { method: 'POST', headers: { 'X-CSRF-Token': this.csrfToken } });
                const result = await res.json();
                if (!result.success) return;
                const icon = btn.querySelector('i');
                const item = btn.closest('.menu-sortable-item');
                if (result.visible) { icon.className = 'fas fa-eye'; item.classList.remove('is-hidden'); }
                else { icon.className = 'fas fa-eye-slash'; item.classList.add('is-hidden'); }
            } catch (err) { console.error('Toggle failed:', err); }
        });
    }

    // ─── DELETE ───
    initDeleteButtons() {
        this.el.querySelectorAll('.btn-delete-item').forEach(btn => this.bindDelete(btn));
    }

    bindDelete(btn) {
        if (!btn) return;
        btn.addEventListener('click', async () => {
            if (!confirm('Supprimer cet élément du menu ?')) return;
            const id = btn.dataset.id;
            const url = this.urls.delete.replace('/0', '/' + id);
            try {
                const res = await fetch(url, { method: 'POST', headers: { 'X-CSRF-Token': this.csrfToken } });
                const result = await res.json();
                if (!result.success) { alert(result.error || 'Erreur'); return; }
                const item = btn.closest('.menu-sortable-item');
                const childZone = item.querySelector('[data-sortable-children]');
                if (childZone) {
                    const parentZone = item.parentElement;
                    childZone.querySelectorAll(':scope > .menu-sortable-item').forEach(child => parentZone.insertBefore(child, item));
                }
                item.remove();
                this.updateCount(this.activeLocation);
                this.saveOrder();
            } catch (err) { console.error('Delete failed:', err); }
        });
    }

    // ─── INLINE EDIT ───
    initInlineEdit() {
        this.el.querySelectorAll('.menu-item-name').forEach(el => this.bindNameEdit(el));
    }

    bindNameEdit(nameEl) {
        if (!nameEl) return;
        nameEl.addEventListener('dblclick', () => {
            const id = nameEl.dataset.id;
            const current = nameEl.textContent.trim();
            const input = document.createElement('input');
            input.type = 'text';
            input.value = current;
            input.className = 'menu-inline-edit';
            nameEl.replaceWith(input);
            input.focus();
            input.select();

            const save = async () => {
                const newName = input.value.trim();
                if (!newName || newName === current) { input.replaceWith(nameEl); return; }
                const url = this.urls.rename.replace('/0', '/' + id);
                try {
                    const res = await fetch(url, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': this.csrfToken },
                        body: JSON.stringify({ name: newName }),
                    });
                    const result = await res.json();
                    if (result.success) nameEl.textContent = result.name;
                } catch (err) { console.error('Rename failed:', err); }
                input.replaceWith(nameEl);
            };

            input.addEventListener('blur', save);
            input.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') { e.preventDefault(); input.blur(); }
                if (e.key === 'Escape') { input.value = current; input.blur(); }
            });
        });
    }

    // ─── HELPERS ───
    updateCount(location) {
        const badge = this.el.querySelector(`.menu-count[data-location="${location}"]`);
        const zone = this.el.querySelector(`#zone-${location} [data-sortable-zone]`);
        if (badge && zone) badge.textContent = zone.querySelectorAll(':scope > .menu-sortable-item').length;
    }

    hideEmptyState(location) {
        const empty = this.el.querySelector(`#zone-${location} .menu-empty-state`);
        if (empty) empty.remove();
    }

    esc(text) {
        const d = document.createElement('div');
        d.textContent = text;
        return d.innerHTML;
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const el = document.querySelector('.menu-manager');
    if (el) new MenuManager(el);
});

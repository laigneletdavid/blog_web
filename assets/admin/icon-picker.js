import './icon-picker.scss';

/**
 * Icon Picker — pour les champs IconPickerField des CRUDs EasyAdmin.
 *
 * S'attache automatiquement aux inputs avec data-icon-picker="true".
 * Ajoute un bouton "Choisir" + une zone preview a cote de l'input.
 * Au clic du bouton, ouvre un modal qui charge /admin/api/icons.
 *
 * Stocke uniquement le nom de l'icone (ex: "search") dans l'input.
 */

let cachedIcons = null;

async function fetchIcons() {
    if (cachedIcons) return cachedIcons;
    const response = await fetch('/admin/api/icons');
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    cachedIcons = await response.json();
    return cachedIcons;
}

function escapeHtml(s) {
    return String(s).replace(/[&<>"']/g, c => ({
        '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
    }[c]));
}

function updatePreview(preview, name) {
    const trimmed = (name || '').trim();
    if (!trimmed) {
        preview.innerHTML = '<span class="icon-picker__empty">Aucune icone</span>';
        return;
    }
    preview.innerHTML = `<img src="/icons/${encodeURIComponent(trimmed)}.svg" alt="${escapeHtml(trimmed)}" onerror="this.style.display='none';this.nextElementSibling.style.display='inline'"><span class="icon-picker__missing" style="display:none">Icone introuvable</span>`;
}

function openModal(input, preview) {
    const modal = document.createElement('div');
    modal.className = 'icon-picker-modal';
    modal.innerHTML = `
        <div class="icon-picker-modal__backdrop"></div>
        <div class="icon-picker-modal__dialog">
            <div class="icon-picker-modal__header">
                <h3>Choisir une icone</h3>
                <button type="button" class="icon-picker-modal__close" aria-label="Fermer">&times;</button>
            </div>
            <div class="icon-picker-modal__body">
                <input type="text" class="form-control form-control-sm icon-picker-modal__search" placeholder="Rechercher...">
                <div class="icon-picker-modal__grid"></div>
                <div class="icon-picker-modal__empty" style="display:none">Aucune icone trouvee</div>
                <div class="icon-picker-modal__loading">Chargement...</div>
            </div>
        </div>
    `;
    document.body.appendChild(modal);

    const close = () => {
        modal.remove();
        document.removeEventListener('keydown', escHandler);
    };
    const escHandler = (e) => { if (e.key === 'Escape') close(); };
    document.addEventListener('keydown', escHandler);
    modal.querySelector('.icon-picker-modal__backdrop').addEventListener('click', close);
    modal.querySelector('.icon-picker-modal__close').addEventListener('click', close);

    const grid = modal.querySelector('.icon-picker-modal__grid');
    const empty = modal.querySelector('.icon-picker-modal__empty');
    const loading = modal.querySelector('.icon-picker-modal__loading');
    const searchInput = modal.querySelector('.icon-picker-modal__search');

    let allIcons = [];

    function render(list) {
        grid.innerHTML = '';
        if (!list.length) {
            grid.style.display = 'none';
            empty.style.display = 'block';
            return;
        }
        grid.style.display = 'grid';
        empty.style.display = 'none';
        list.forEach(icon => {
            const item = document.createElement('button');
            item.type = 'button';
            item.className = 'icon-picker-modal__item';
            item.title = icon.name;
            item.innerHTML = `
                <img src="${icon.url}" alt="${escapeHtml(icon.name)}" width="24" height="24">
                <span>${escapeHtml(icon.name)}</span>
            `;
            item.addEventListener('click', () => {
                input.value = icon.name;
                input.dispatchEvent(new Event('change', { bubbles: true }));
                updatePreview(preview, icon.name);
                close();
            });
            grid.appendChild(item);
        });
    }

    fetchIcons().then(icons => {
        loading.style.display = 'none';
        allIcons = icons;
        render(icons);
    }).catch(err => {
        loading.textContent = 'Erreur de chargement des icones';
        console.error('[IconPicker]', err);
    });

    searchInput.addEventListener('input', () => {
        const q = searchInput.value.trim().toLowerCase();
        const filtered = q ? allIcons.filter(i => i.name.toLowerCase().includes(q)) : allIcons;
        render(filtered);
    });

    setTimeout(() => searchInput.focus(), 50);
}

function attachToInput(input) {
    if (input.dataset.iconPickerAttached === '1') return;
    input.dataset.iconPickerAttached = '1';

    const wrapper = document.createElement('div');
    wrapper.className = 'icon-picker';

    // Insere wrapper avant l'input, puis deplace l'input dedans
    input.parentNode.insertBefore(wrapper, input);

    const inputGroup = document.createElement('div');
    inputGroup.className = 'icon-picker__input-group';

    const preview = document.createElement('div');
    preview.className = 'icon-picker__preview';

    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'btn btn-secondary btn-sm icon-picker__btn';
    button.textContent = 'Choisir';
    button.addEventListener('click', () => openModal(input, preview));

    inputGroup.appendChild(input);
    inputGroup.appendChild(button);

    wrapper.appendChild(inputGroup);
    wrapper.appendChild(preview);

    updatePreview(preview, input.value);

    input.addEventListener('input', () => updatePreview(preview, input.value));
}

function init() {
    document.querySelectorAll('input[data-icon-picker="true"]').forEach(attachToInput);
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

// Re-scan apres ouverture de modaux EasyAdmin (autocomplete, etc.)
document.addEventListener('ea.collection.item-added', init);

import './admin-simple.scss';

// ────────────────────────────────────────
// Apercu Google : sur tout formulaire qui a des champs seoTitle / seoDescription,
// affiche le resultat tel qu'il apparaitra dans Google, mis a jour a la frappe,
// avec un compteur de caracteres.
// ────────────────────────────────────────
const TITLE_MAX = 60;
const DESC_MAX = 160;

function fieldWrapper(input) {
    return input.closest('.form-group, .field-text, .field-textarea, .mb-3') || input.parentElement;
}

function addCounter(input, max) {
    const label = fieldWrapper(input)?.querySelector('label');
    if (!label) return null;
    const counter = document.createElement('span');
    counter.className = 'bw-counter';
    label.appendChild(counter);
    return () => {
        const len = input.value.length;
        counter.textContent = ` (${len} / ${max})`;
        counter.classList.toggle('is-over', len > max);
    };
}

function initGooglePreview() {
    const seoTitle = document.querySelector('input[name$="[seoTitle]"]');
    const seoDesc = document.querySelector('textarea[name$="[seoDescription]"], input[name$="[seoDescription]"]');
    if (!seoTitle || !seoDesc) return;

    const title = document.querySelector('input[name$="[title]"], input[name$="[name]"]');
    const summary = document.querySelector('input[name$="[featuredText]"], textarea[name$="[shortDescription]"]');
    const slug = document.querySelector('input[name$="[slug]"]');
    // Mode simple : pas de champ d'adresse, on reprend le lien "Voir sur le site" de la page
    const viewOnSite = document.querySelector('a.action-viewOnSite[href]');
    const publicPath = viewOnSite ? new URL(viewOnSite.href, window.location.origin).pathname : '';

    const box = document.createElement('div');
    box.className = 'bw-google';
    box.setAttribute('aria-live', 'polite');
    box.innerHTML = '<p class="bw-google__label">Aperçu dans Google</p>'
        + '<div class="bw-google__result">'
        + '<div class="bw-google__url"></div>'
        + '<div class="bw-google__title"></div>'
        + '<div class="bw-google__desc"></div>'
        + '</div>';
    fieldWrapper(seoTitle).before(box);

    const urlEl = box.querySelector('.bw-google__url');
    const titleEl = box.querySelector('.bw-google__title');
    const descEl = box.querySelector('.bw-google__desc');
    const updateTitleCount = addCounter(seoTitle, TITLE_MAX);
    const updateDescCount = addCounter(seoDesc, DESC_MAX);

    const update = () => {
        // Repli identique au site : titre SEO, sinon titre du contenu ; description, sinon resume
        const t = seoTitle.value.trim() || title?.value.trim() || 'Titre de la page';
        const d = seoDesc.value.trim() || summary?.value.trim() || 'Ajoutez une description pour donner envie de cliquer.';
        titleEl.textContent = t.length > TITLE_MAX ? t.slice(0, TITLE_MAX - 1) + '…' : t;
        descEl.textContent = d.length > DESC_MAX ? d.slice(0, DESC_MAX - 1) + '…' : d;
        const path = slug?.value || publicPath.replace(/^\/+|\/+$/g, '');
        urlEl.textContent = window.location.host + (path ? ' › ' + path.split('/').join(' › ') : '');
        updateTitleCount?.();
        updateDescCount?.();
    };

    [seoTitle, seoDesc, title, summary, slug].forEach((el) => el?.addEventListener('input', update));
    update();
}

// ────────────────────────────────────────
// Bouton "Creer" (<details>) : se referme au clic ailleurs ou sur Echap
// ────────────────────────────────────────
function initCreateMenus() {
    const menus = document.querySelectorAll('details.bw-create');
    if (!menus.length) return;

    document.addEventListener('click', (e) => {
        menus.forEach((menu) => {
            if (menu.open && !menu.contains(e.target)) menu.open = false;
        });
    });
    document.addEventListener('keydown', (e) => {
        if (e.key !== 'Escape') return;
        menus.forEach((menu) => {
            if (menu.open) {
                menu.open = false;
                menu.querySelector('summary')?.focus();
            }
        });
    });
}

document.addEventListener('DOMContentLoaded', () => {
    initGooglePreview();
    initCreateMenus();
});

import { Controller } from '@hotwired/stimulus';

/**
 * Badge compteur panier dans le header.
 * Charge le count au connect + ecoute l'event custom 'cart:updated'.
 */
export default class extends Controller {
    static targets = ['count'];
    static values = { url: String };

    connect() {
        this.refresh();
        window.addEventListener('cart:updated', () => this.refresh());
    }

    async refresh() {
        try {
            const response = await fetch(this.urlValue);
            const data = await response.json();
            this.updateBadge(data.count);
        } catch (e) {
            // Silent fail
        }
    }

    updateBadge(count) {
        const el = this.countTarget;
        if (count > 0) {
            el.textContent = count > 99 ? '99+' : count;
            el.style.display = '';
        } else {
            el.style.display = 'none';
        }
    }
}

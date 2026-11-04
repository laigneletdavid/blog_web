/* stimulusFetch: 'lazy' */
import { Controller } from '@hotwired/stimulus';
import { awaitsEntry, onEntry } from '../js/motion';

/**
 * Fait compter les chiffres jusqu'a leur valeur quand le bloc entre a l'ecran.
 *
 *   <div data-controller="count-up"> ... <span data-count-up-target="value">6</span>
 *
 * La valeur finale est dans le HTML : sans JavaScript elle s'affiche telle
 * quelle. Seuls les entiers comptent (« ½ j » reste tel quel) ; un separateur
 * de milliers (« 1 530 ») est garde pendant le compte.
 */
const SEPARATEUR = /[\s  ]/;

export default class extends Controller {
    static targets = ['value'];
    static values = { duration: { type: Number, default: 600 } };

    connect() {
        if (!awaitsEntry(this.element)) return;
        this.counters = this.valueTargets
            .map((el) => [el, el.textContent.trim()])
            .filter(([, texte]) => /^\d{1,3}([\s  ]\d{3})*$/.test(texte))
            .map(([el, texte]) => [el, parseInt(texte.replace(/\D/g, ''), 10), texte.match(SEPARATEUR)?.[0] ?? '']);
        this.counters.forEach(([el]) => { el.textContent = '0'; });
        this.observer = onEntry(this.element, () => this.count());
    }

    count() {
        const start = performance.now();
        const ecrire = (n, sep) => (sep ? String(n).replace(/\B(?=(\d{3})+(?!\d))/g, sep) : String(n));
        const step = (now) => {
            const t = Math.min((now - start) / this.durationValue, 1);
            this.counters.forEach(([el, end, sep]) => { el.textContent = ecrire(Math.round(end * (1 - (1 - t) ** 3)), sep); });
            if (t < 1) requestAnimationFrame(step);
        };
        requestAnimationFrame(step);
    }

    disconnect() {
        this.observer?.disconnect();
    }
}

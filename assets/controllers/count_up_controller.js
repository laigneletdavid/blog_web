/* stimulusFetch: 'lazy' */
import { Controller } from '@hotwired/stimulus';
import { awaitsEntry, onEntry } from '../js/motion';

/**
 * Fait compter les chiffres jusqu'a leur valeur quand le bloc entre a l'ecran.
 *
 *   <div data-controller="count-up"> ... <span data-count-up-target="value">6</span>
 *
 * La valeur finale est dans le HTML : sans JavaScript elle s'affiche telle
 * quelle. Seuls les entiers comptent (« ½ j » reste tel quel).
 */
export default class extends Controller {
    static targets = ['value'];
    static values = { duration: { type: Number, default: 600 } };

    connect() {
        if (!awaitsEntry(this.element)) return;
        this.counters = this.valueTargets
            .filter((el) => /^\d+$/.test(el.textContent.trim()))
            .map((el) => [el, parseInt(el.textContent, 10)]);
        this.counters.forEach(([el]) => { el.textContent = '0'; });
        this.observer = onEntry(this.element, () => this.count());
    }

    count() {
        const start = performance.now();
        const step = (now) => {
            const t = Math.min((now - start) / this.durationValue, 1);
            this.counters.forEach(([el, end]) => { el.textContent = Math.round(end * (1 - (1 - t) ** 3)); });
            if (t < 1) requestAnimationFrame(step);
        };
        requestAnimationFrame(step);
    }

    disconnect() {
        this.observer?.disconnect();
    }
}

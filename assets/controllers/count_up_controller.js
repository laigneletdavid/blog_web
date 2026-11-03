/* stimulusFetch: 'lazy' */
import { Controller } from '@hotwired/stimulus';

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
        if (!('IntersectionObserver' in window) || matchMedia('(prefers-reduced-motion: reduce)').matches) return;
        const box = this.element.getBoundingClientRect();
        if (box.top < window.innerHeight && box.bottom > 0) return;

        this.counters = this.valueTargets
            .filter((el) => /^\d+$/.test(el.textContent.trim()))
            .map((el) => ({ el, end: parseInt(el.textContent, 10) }));
        if (!this.counters.length) return;

        this.counters.forEach(({ el }) => { el.textContent = '0'; });
        this.observer = new IntersectionObserver((entries) => {
            if (!entries[0].isIntersecting) return;
            this.observer.disconnect();
            this.count();
        }, { rootMargin: '0px 0px -10% 0px' });
        this.observer.observe(this.element);
    }

    count() {
        const start = performance.now();
        const step = (now) => {
            const t = Math.min((now - start) / this.durationValue, 1);
            const eased = 1 - (1 - t) ** 3;
            this.counters.forEach(({ el, end }) => { el.textContent = String(Math.round(end * eased)); });
            if (t < 1) requestAnimationFrame(step);
        };
        requestAnimationFrame(step);
    }

    disconnect() {
        this.observer?.disconnect();
        this.counters?.forEach(({ el, end }) => { el.textContent = String(end); });
    }
}

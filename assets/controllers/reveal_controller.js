/* stimulusFetch: 'lazy' */
import { Controller } from '@hotwired/stimulus';

/**
 * Apparition douce au defilement, une seule fois (montee ou glissement + fondu).
 *
 *   <div data-controller="reveal">                          l'element lui-meme
 *   <div data-controller="reveal" data-reveal-stagger-value="70">   ses enfants, en decale
 *   <div data-controller="reveal" data-reveal-from-value="left">    glisse depuis la gauche
 *
 * Ce qui est deja a l'ecran au chargement ne bouge pas. Sans JavaScript ou en
 * mouvement reduit, rien n'est cache. Styles : assets/css/base/motion.scss.
 */
export default class extends Controller {
    static values = {
        stagger: { type: Number, default: 0 },
        from: { type: String, default: 'up' },
    };

    connect() {
        if (!('IntersectionObserver' in window) || matchMedia('(prefers-reduced-motion: reduce)').matches) return;
        const box = this.element.getBoundingClientRect();
        if (box.top < window.innerHeight && box.bottom > 0) return;

        this.items = this.staggerValue ? [...this.element.children] : [this.element];
        this.items.forEach((el, i) => {
            el.classList.add('reveal', `reveal--${this.fromValue}`);
            if (i) el.style.transitionDelay = `${i * this.staggerValue}ms`;
        });

        this.observer = new IntersectionObserver((entries) => {
            if (!entries[0].isIntersecting) return;
            this.items.forEach((el) => el.classList.add('is-revealed'));
            this.element.classList.add('is-revealed');
            this.observer.disconnect();
        }, { rootMargin: '0px 0px -10% 0px' });
        this.observer.observe(this.element);
    }

    disconnect() {
        this.observer?.disconnect();
    }
}

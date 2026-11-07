/* stimulusFetch: 'lazy' */
import { Controller } from '@hotwired/stimulus';
import { awaitsEntry, onEntry } from '../js/motion';

/**
 * Apparition douce au defilement, une seule fois (montee ou glissement + fondu).
 *
 *   <div data-controller="reveal">                                  l'element lui-meme
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
        if (!awaitsEntry(this.element)) return;
        const items = this.staggerValue ? [...this.element.children] : [this.element];
        items.forEach((el, i) => {
            el.classList.add('reveal', `reveal--${this.fromValue}`);
            if (i) el.style.transitionDelay = `${i * this.staggerValue}ms`;
        });
        this.observer = onEntry(this.element, () => {
            [this.element, ...items].forEach((el) => el.classList.add('is-revealed'));
        });
    }

    disconnect() {
        this.observer?.disconnect();
    }
}

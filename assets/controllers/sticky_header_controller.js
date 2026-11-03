/* stimulusFetch: 'lazy' */
import { Controller } from '@hotwired/stimulus';

/**
 * Pose la classe « is-scrolled » sur le header des que la page defile : le
 * CSS du site en fait un header compact avec une ombre fine.
 *
 *   <header data-controller="sticky-header">
 */
export default class extends Controller {
    static values = { offset: { type: Number, default: 8 } };

    connect() {
        this.update = this.update.bind(this);
        window.addEventListener('scroll', this.update, { passive: true });
        this.update();
    }

    update() {
        if (this.frame) return;
        this.frame = requestAnimationFrame(() => {
            this.frame = null;
            this.element.classList.toggle('is-scrolled', window.scrollY > this.offsetValue);
        });
    }

    disconnect() {
        window.removeEventListener('scroll', this.update);
    }
}

/* stimulusFetch: 'lazy' */
import { Controller } from '@hotwired/stimulus';

/**
 * Pose la classe « is-scrolled » sur le header des que la page defile : le
 * CSS du site en fait un header compact avec une ombre fine.
 *
 *   <header data-controller="sticky-header">
 */
export default class extends Controller {
    connect() {
        // scrollY ne force aucun calcul de mise en page : pas besoin de temporiser
        this.update = () => this.element.classList.toggle('is-scrolled', window.scrollY > 8);
        window.addEventListener('scroll', this.update, { passive: true });
        this.update();
    }

    disconnect() {
        window.removeEventListener('scroll', this.update);
    }
}

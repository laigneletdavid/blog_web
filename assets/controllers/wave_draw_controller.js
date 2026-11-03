/* stimulusFetch: 'lazy' */
import { Controller } from '@hotwired/stimulus';
import { awaitsEntry, onEntry } from '../js/motion';

/**
 * Trace un soulignement SVG de gauche a droite quand il entre a l'ecran.
 *
 *   <span data-controller="wave-draw"> ... <svg> ... </svg></span>
 *
 * Pose « is-wave-pending » (trait masque) puis « is-wave-drawn » : l'animation
 * du stroke-dashoffset est decrite dans le CSS du site. Deja a l'ecran au
 * chargement, sans JavaScript ou en mouvement reduit : le trait est la d'emblee.
 */
export default class extends Controller {
    connect() {
        if (!awaitsEntry(this.element)) return;
        this.element.classList.add('is-wave-pending');
        this.observer = onEntry(this.element, () => this.element.classList.add('is-wave-drawn'), '-15%');
    }

    disconnect() {
        this.observer?.disconnect();
    }
}

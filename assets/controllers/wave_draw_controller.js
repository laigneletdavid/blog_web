/* stimulusFetch: 'lazy' */
import { Controller } from '@hotwired/stimulus';

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
        if (!('IntersectionObserver' in window) || matchMedia('(prefers-reduced-motion: reduce)').matches) return;
        const box = this.element.getBoundingClientRect();
        if (box.top < window.innerHeight && box.bottom > 0) return;

        this.element.classList.add('is-wave-pending');
        this.observer = new IntersectionObserver((entries) => {
            if (!entries[0].isIntersecting) return;
            this.element.classList.add('is-wave-drawn');
            this.observer.disconnect();
        }, { rootMargin: '0px 0px -15% 0px' });
        this.observer.observe(this.element);
    }

    disconnect() {
        this.observer?.disconnect();
    }
}

import { Controller } from '@hotwired/stimulus';

/**
 * Soumet le formulaire des qu'un champ change (listes deroulantes de filtres).
 * Le bouton de soumission reste present pour les navigateurs sans JS.
 */
export default class extends Controller {
    submit() {
        if (typeof this.element.requestSubmit === 'function') {
            this.element.requestSubmit();

            return;
        }

        this.element.submit();
    }
}

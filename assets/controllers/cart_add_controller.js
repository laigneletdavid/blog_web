import { Controller } from '@hotwired/stimulus';

/**
 * Ajout au panier en AJAX depuis la fiche produit.
 * Fallback : soumission classique du form si JS desactive.
 */
export default class extends Controller {
    static targets = ['variantId'];

    async submit(event) {
        event.preventDefault();

        const form = this.element;
        const formData = new FormData(form);
        const button = form.querySelector('button[type="submit"]');
        const originalText = button.innerHTML;

        // Feedback visuel
        button.disabled = true;
        button.innerHTML = `
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
            Ajoute !
        `;

        try {
            const response = await fetch(form.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                },
            });

            if (response.ok) {
                // Notifier le badge header
                window.dispatchEvent(new CustomEvent('cart:updated'));

                // Reset le bouton apres 1.5s
                setTimeout(() => {
                    button.disabled = false;
                    button.innerHTML = originalText;
                }, 1500);
            } else {
                throw new Error('Erreur serveur');
            }
        } catch (e) {
            button.disabled = false;
            button.innerHTML = originalText;
            // Fallback: soumettre le form classiquement
            form.submit();
        }
    }
}

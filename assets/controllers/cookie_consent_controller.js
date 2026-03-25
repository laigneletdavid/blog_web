import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    static targets = ['banner'];

    connect() {
        const consent = localStorage.getItem('cookie_consent');
        if (!consent) {
            this.bannerTarget.classList.remove('d-none');
        } else if (consent === 'accepted') {
            this.loadAnalytics();
        }
    }

    accept() {
        localStorage.setItem('cookie_consent', 'accepted');
        this.bannerTarget.classList.add('d-none');
        this.loadAnalytics();
    }

    refuse() {
        localStorage.setItem('cookie_consent', 'refused');
        this.bannerTarget.classList.add('d-none');
    }

    loadAnalytics() {
        const gaId = this.element.dataset.cookieConsentGaIdValue;
        if (!gaId) return;

        // Avoid loading twice
        if (window._gaLoaded) return;
        window._gaLoaded = true;

        const script = document.createElement('script');
        script.async = true;
        script.src = `https://www.googletagmanager.com/gtag/js?id=${gaId}`;
        document.head.appendChild(script);

        window.dataLayer = window.dataLayer || [];
        function gtag() { window.dataLayer.push(arguments); }
        gtag('js', new Date());
        gtag('config', gaId);
    }
}

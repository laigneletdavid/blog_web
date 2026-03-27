import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ['q', 'results', 'form'];

    doSearch() {
        if (!this.hasFormTarget || !this.hasQTarget || !this.hasResultsTarget) {
            return;
        }

        const query = this.qTarget.value.trim();
        if (query.length < 2) {
            this.resultsTarget.classList.remove('show');
            return;
        }

        this.resultsTarget.innerHTML = '';

        const apiUrl = this.formTarget.dataset.apiUrl || this.formTarget.action;
        fetch(apiUrl + '?q=' + encodeURIComponent(query))
            .then(response => {
                this.resultsTarget.classList.remove('show');
                if (!response.ok) return;

                response.json().then(data => {
                    this.resultsTarget.innerHTML = '';

                    if (data.results && data.results.length > 0) {
                        data.results.forEach(result => {
                            const link = document.createElement('a');
                            link.href = result.url;
                            link.innerText = result.text;
                            link.className = 'dropdown-item';
                            this.resultsTarget.appendChild(link);
                        });

                        // Lien "Voir tous les resultats"
                        if (data.seeAllUrl) {
                            const seeAll = document.createElement('a');
                            seeAll.href = data.seeAllUrl;
                            seeAll.innerHTML = 'Voir tous les r&eacute;sultats &rarr;';
                            seeAll.className = 'dropdown-item fw-bold text-primary border-top mt-1 pt-2';
                            this.resultsTarget.appendChild(seeAll);
                        }
                    } else {
                        const msg = document.createElement('div');
                        msg.innerText = 'Aucun résultat !';
                        msg.className = 'dropdown-item text-muted';
                        this.resultsTarget.appendChild(msg);
                    }

                    this.resultsTarget.classList.add('show');
                });
            });
    }
}

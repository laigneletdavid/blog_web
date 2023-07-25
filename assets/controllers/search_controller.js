import {Controller} from "@hotwired/stimulus";
import {easingEffects} from "chart.js/helpers";

export default class extends Controller {

    static targets = ['q', 'results', 'form'];
    doSearch() {
        if (this.hasFormTarget && this.hasQTarget && this.hasResultsTarget) {
            this.resultsTarget.innerHTML = '';

            fetch(this.formTarget.action+'?q='+encodeURIComponent(this.qTarget.value))
                .then(response => {
                    this.resultsTarget.classList.remove('show');
                    if (response.ok) {
                        response.json()
                            .then(data => {
                                this.resultsTarget.innerHTML = '';

                                if (data.results && data.results.length > 0 ) {
                                    data.results.forEach(result => {
                                        const link = document.createElement('a');
                                        link.href = result.url;
                                        link.innerText = result.text;
                                        link.className = 'dropdown-item';
                                        this.resultsTarget.appendChild(link);
                                    });
                                }
                                else {
                                    const msg = document.createElement('div');
                                    msg.innerText = 'Aucun résultat !';
                                    msg.className = 'dropdown-item text-muted';
                                    this.resultsTarget.appendChild(msg);
                                }
                                this.resultsTarget.classList.add('show');
                            });
                    }
                })

        }
    }

    dosSearch() {
        if (this.hasFormTarget && this.hasQTarget && this.hasResultsTarget) {
            this.resultsTarget.innerHTML = ''; //je vide le contenu du résultat

            fetch(this.formTarget.action+'?q='+encodeURIComponent(this.qTarget.value))    // Je cible l'action du formulaire dans une promise
                .then(response => { // quand il y a eu un succes réseau
                    this.resultsTarget.classList.remove('show'); // je cache mon dropdown menu si erreur
                    if (response.ok) {  // seulement si le résultat est OK ou bon entre 200 et 299 soit 2xx
                        response.json() // On va décaplsuler la réponse avec une promise
                            .then(data => {  // je reçois les datas, le résultat du json
                                this.resultsTarget.innerHTML = ''; //je vide le contenu du résultat précedent

                                if (data.results && data.results.length > 0 ) { // si j'ai des résultats
                                    data.results.forEach(result => {  // je boucle et je cré une fonction anonyme qui génère mon code html
                                        const link = document.createElement('a');  //je créé mon lien <a>
                                        link.href = result.url;  // je créé mon href
                                        link.innerText = result.type + ' / ' + result.text; // je créé le texte qui s'affiche
                                        link.className = 'dropdown-item';  /// J'ajoute une class
                                        this.resultsTarget.appendChild(link); //Il va ajouter le lien créé à la fin de la liste
                                    });
                                }
                                else {  // si pas de résultat je cré une div qui le dit
                                    const msg = document.createElement('div');
                                    msg.innerText = 'Aucun résultat !';
                                    msg.className = 'dropdown-item text-muted';
                                    this.resultsTarget.appendChild(msg);
                                }
                                this.resultsTarget.classList.add('show'); // j'affiche mon dropdown menu
                            });
                    }
                })

        }
    }
}
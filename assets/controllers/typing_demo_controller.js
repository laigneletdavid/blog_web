/* stimulusFetch: 'lazy' */
import { Controller } from '@hotwired/stimulus';

/**
 * Mini-demo d'editeur : les champs se tapent lettre par lettre et l'apercu
 * suit, en boucle lente. Pause au survol et sur le bouton pause.
 *
 *   <figure data-controller="typing-demo" data-typing-demo-examples-value='[{"titre":"…","texte":"…"}]'
 *           data-action="mouseenter->typing-demo#hold mouseleave->typing-demo#release">
 *     <div data-typing-demo-target="field" data-key="titre">…</div>
 *     <span data-typing-demo-target="preview" data-key="titre">…</span>
 *     <button data-typing-demo-target="toggle" data-action="typing-demo#toggle" hidden>Pause</button>
 *
 * Le HTML porte deja le premier exemple : sans JavaScript ou en mouvement
 * reduit, la maquette reste figee dessus.
 */
export default class extends Controller {
    static targets = ['field', 'preview', 'toggle'];
    static values = {
        examples: Array,
        speed: { type: Number, default: 45 },
        hold: { type: Number, default: 2600 },
    };

    connect() {
        if (this.examplesValue.length < 2 || matchMedia('(prefers-reduced-motion: reduce)').matches) return;
        this.index = 0;
        this.steps = [];
        if (this.hasToggleTarget) this.toggleTarget.hidden = false;
        this.later(this.holdValue);
    }

    // Prepare l'exemple suivant : on vide les champs, puis une etape par lettre
    next() {
        this.index = (this.index + 1) % this.examplesValue.length;
        const example = this.examplesValue[this.index];
        const keys = this.fieldTargets.map((f) => f.dataset.key);
        this.steps = keys.map((k) => [k, '']);
        keys.forEach((k) => {
            const text = example[k] || '';
            for (let i = 1; i <= text.length; i++) this.steps.push([k, text.slice(0, i)]);
        });
    }

    tick() {
        if (this.paused || this.hovered) return this.later(200);
        if (!this.steps.length) {
            this.next();
            return this.later(this.speedValue);
        }
        const [key, text] = this.steps.shift();
        [...this.fieldTargets, ...this.previewTargets].forEach((el) => {
            if (el.dataset.key === key) el.textContent = text;
        });
        this.later(this.steps.length ? this.speedValue : this.holdValue);
    }

    later(ms) {
        this.timer = setTimeout(() => this.tick(), ms);
    }

    hold() { this.hovered = true; }

    release() { this.hovered = false; }

    toggle() {
        this.paused = !this.paused;
        this.toggleTarget.setAttribute('aria-pressed', String(this.paused));
        this.toggleTarget.textContent = this.paused ? 'Lecture' : 'Pause';
    }

    disconnect() {
        clearTimeout(this.timer);
    }
}

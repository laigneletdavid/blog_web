/* stimulusFetch: 'lazy' */
import { Controller } from '@hotwired/stimulus';

/**
 * Mini-demo d'editeur : les champs se tapent lettre par lettre et l'apercu
 * suit. Boucle lente, pause au survol, au focus et sur le bouton pause ; arret
 * hors de l'ecran.
 *
 *   <figure data-controller="typing-demo" data-typing-demo-examples-value='[{"titre":"…","texte":"…"}]'>
 *     <div data-typing-demo-target="field" data-key="titre">…</div>
 *     <span data-typing-demo-target="preview" data-key="titre">…</span>
 *     <button data-typing-demo-target="toggle" data-action="typing-demo#toggle" hidden>Pause</button>
 *
 * Le HTML porte deja un exemple complet : sans JavaScript ou en mouvement
 * reduit, la maquette reste figee sur celui-ci.
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
        this.userPaused = false;
        this.hover = false;
        this.visible = true;
        if (this.hasToggleTarget) this.toggleTarget.hidden = false;

        this.onEnter = () => { this.hover = true; };
        this.onLeave = () => { this.hover = false; };
        this.element.addEventListener('mouseenter', this.onEnter);
        this.element.addEventListener('mouseleave', this.onLeave);
        this.element.addEventListener('focusin', this.onEnter);
        this.element.addEventListener('focusout', this.onLeave);
        this.observer = new IntersectionObserver((e) => { this.visible = e[0].isIntersecting; });
        this.observer.observe(this.element);

        this.alive = true;
        this.wait(this.holdValue).then(() => this.loop());
    }

    async loop() {
        while (this.alive) {
            this.index = (this.index + 1) % this.examplesValue.length;
            const example = this.examplesValue[this.index];
            for (const field of this.fieldTargets) this.write(field.dataset.key, '');
            for (const field of this.fieldTargets) {
                const text = example[field.dataset.key] || '';
                for (let i = 1; i <= text.length && this.alive; i++) {
                    await this.wait(this.speedValue);
                    this.write(field.dataset.key, text.slice(0, i));
                }
            }
            await this.wait(this.holdValue);
        }
    }

    write(key, text) {
        [...this.fieldTargets, ...this.previewTargets]
            .filter((el) => el.dataset.key === key)
            .forEach((el) => { el.textContent = text; });
    }

    // Attend « ms » de temps actif : le compteur s'arrete pendant les pauses
    wait(ms) {
        return new Promise((resolve) => {
            let left = ms;
            let last = performance.now();
            const tick = (now) => {
                if (!this.alive) return resolve();
                if (!this.userPaused && !this.hover && this.visible && !document.hidden) left -= now - last;
                last = now;
                if (left <= 0) resolve(); else requestAnimationFrame(tick);
            };
            requestAnimationFrame(tick);
        });
    }

    toggle() {
        this.userPaused = !this.userPaused;
        this.toggleTarget.setAttribute('aria-pressed', String(this.userPaused));
        this.toggleTarget.textContent = this.userPaused ? 'Lecture' : 'Pause';
    }

    disconnect() {
        this.alive = false;
        this.observer?.disconnect();
        this.element.removeEventListener('mouseenter', this.onEnter);
        this.element.removeEventListener('mouseleave', this.onLeave);
        this.element.removeEventListener('focusin', this.onEnter);
        this.element.removeEventListener('focusout', this.onLeave);
    }
}

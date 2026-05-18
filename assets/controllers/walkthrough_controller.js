import { Controller } from '@hotwired/stimulus';
import { driver } from 'driver.js';
import 'driver.js/dist/driver.css';

export default class extends Controller {
    static values = {
        steps: Array,
        completeUrl: String,
    };

    connect() {
        this.tourDriver = null;
    }

    start() {
        const steps = this.stepsValue.filter(step =>
            document.querySelector(step.element)
        );

        if (steps.length === 0) return;

        this.tourDriver = driver({
            showProgress: true,
            animate: true,
            overlayColor: 'rgba(0, 0, 0, 0.6)',
            stagePadding: 8,
            stageRadius: 8,
            popoverClass: 'bw-tour-popover',
            nextBtnText: 'Suivant',
            prevBtnText: 'Précédent',
            doneBtnText: 'Terminer',
            progressText: '{{current}} / {{total}}',
            steps: steps,
            onDestroyStarted: () => {
                if (this.tourDriver.hasNextStep()) {
                    this.tourDriver.destroy();
                    return;
                }
                this._markComplete();
                this.tourDriver.destroy();
            },
        });

        this.tourDriver.drive();
    }

    async _markComplete() {
        if (!this.completeUrlValue) return;
        try {
            await fetch(this.completeUrlValue, {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                },
            });
        } catch (e) {
            // silently ignore
        }
    }
}

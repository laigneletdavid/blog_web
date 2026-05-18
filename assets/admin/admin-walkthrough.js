import { driver } from 'driver.js';
import 'driver.js/dist/driver.css';
import './admin-walkthrough.scss';

document.addEventListener('DOMContentLoaded', () => {
    const container = document.querySelector('[data-walkthrough-steps]');
    if (!container) return;

    let steps;
    try {
        steps = JSON.parse(container.dataset.walkthroughSteps);
    } catch (e) {
        return;
    }

    const completeUrl = container.dataset.walkthroughCompleteUrl || '';

    const expandedMenus = [];

    function expandAllTargetedSubmenus() {
        steps.forEach(step => {
            if (!step.expandSubmenu) return;
            const el = document.querySelector(step.element);
            if (!el) return;
            const menuItem = el.closest('.menu-item.has-submenu')
                || el.parentElement?.closest('.menu-item.has-submenu');
            if (menuItem && !menuItem.classList.contains('expanded')) {
                const toggle = menuItem.querySelector('.submenu-toggle');
                if (toggle) {
                    toggle.click();
                    expandedMenus.push(toggle);
                }
            }
        });
    }

    function collapseOpenedSubmenus() {
        expandedMenus.forEach(toggle => toggle.click());
        expandedMenus.length = 0;
    }

    function startTour() {
        expandAllTargetedSubmenus();

        const visibleSteps = steps
            .filter(step => {
                const el = document.querySelector(step.element);
                return el && el.offsetParent !== null;
            })
            .map(({ expandSubmenu, ...rest }) => rest);

        if (visibleSteps.length === 0) return;

        const tourDriver = driver({
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
            steps: visibleSteps,
            onDestroyStarted: () => {
                if (!tourDriver.hasNextStep() && completeUrl) {
                    fetch(completeUrl, {
                        method: 'POST',
                        headers: { 'X-Requested-With': 'XMLHttpRequest' },
                    }).catch(() => {});
                }
                collapseOpenedSubmenus();
                tourDriver.destroy();
            },
        });

        tourDriver.drive();
    }

    document.querySelectorAll('[data-action="walkthrough-start"]').forEach(btn => {
        btn.addEventListener('click', startTour);
    });
});

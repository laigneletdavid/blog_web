import { Controller } from '@hotwired/stimulus';

/**
 * Scroll-spy TOC: highlights the active heading link as user scrolls.
 * Smooth-scrolls on click.
 */
export default class extends Controller {
    static targets = ['link'];

    connect() {
        this.headings = [];
        this.linkTargets.forEach((link) => {
            const id = link.dataset.sectionId;
            const heading = document.getElementById(id);
            if (heading) {
                this.headings.push({ id, el: heading, link });
            }
        });

        if (this.headings.length === 0) return;

        // Smooth scroll on click
        this.linkTargets.forEach((link) => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const id = link.dataset.sectionId;
                const target = document.getElementById(id);
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    history.replaceState(null, '', '#' + id);
                }
            });
        });

        // Scroll spy with IntersectionObserver
        this.activeId = null;
        this.observer = new IntersectionObserver(
            (entries) => {
                // Find the topmost visible heading
                const visible = entries
                    .filter((e) => e.isIntersecting)
                    .sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top);

                if (visible.length > 0) {
                    this.setActive(visible[0].target.id);
                }
            },
            {
                rootMargin: '-80px 0px -60% 0px',
                threshold: 0,
            }
        );

        this.headings.forEach(({ el }) => this.observer.observe(el));
    }

    setActive(id) {
        if (this.activeId === id) return;
        this.activeId = id;

        this.linkTargets.forEach((link) => {
            link.classList.toggle('widget-toc__link--active', link.dataset.sectionId === id);
        });
    }

    disconnect() {
        if (this.observer) {
            this.observer.disconnect();
        }
    }
}

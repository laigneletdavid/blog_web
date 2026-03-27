import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    static targets = ['main', 'mainImg', 'lightbox', 'lightboxImg'];

    currentIndex = 0;
    images = [];

    connect() {
        this.images = this.collectImages();

        // Click on main image → open lightbox
        const mainImg = this.hasMainImgTarget ? this.mainImgTarget : null;
        if (mainImg) {
            mainImg.style.cursor = 'zoom-in';
            mainImg.addEventListener('click', () => this.openLightbox());
        }

        // Keyboard nav
        this.handleKeydown = this.handleKeydown.bind(this);
    }

    collectImages() {
        const imgs = [];
        const thumbs = this.element.querySelectorAll('.product-gallery__thumb');
        thumbs.forEach((btn) => {
            imgs.push({
                src: btn.dataset.productGallerySrcParam,
                alt: btn.dataset.productGalleryAltParam || '',
            });
        });
        // If no thumbs but main image exists
        if (imgs.length === 0 && this.hasMainImgTarget) {
            imgs.push({
                src: this.mainImgTarget.src,
                alt: this.mainImgTarget.alt || '',
            });
        }
        return imgs;
    }

    switchImage(event) {
        const btn = event.currentTarget;
        const src = btn.dataset.productGallerySrcParam;
        const alt = btn.dataset.productGalleryAltParam || '';

        if (this.hasMainImgTarget) {
            this.mainImgTarget.src = src;
            this.mainImgTarget.alt = alt;
        }

        // Update active thumb
        this.element.querySelectorAll('.product-gallery__thumb').forEach((t, i) => {
            t.classList.toggle('active', t === btn);
            if (t === btn) this.currentIndex = i;
        });
    }

    openLightbox() {
        if (!this.hasLightboxTarget || this.images.length === 0) return;

        this.lightboxTarget.hidden = false;
        document.body.style.overflow = 'hidden';
        this.showLightboxImage(this.currentIndex);

        document.addEventListener('keydown', this.handleKeydown);
    }

    closeLightbox() {
        if (!this.hasLightboxTarget) return;
        this.lightboxTarget.hidden = true;
        document.body.style.overflow = '';
        document.removeEventListener('keydown', this.handleKeydown);
    }

    nextImage() {
        if (this.images.length === 0) return;
        this.currentIndex = (this.currentIndex + 1) % this.images.length;
        this.showLightboxImage(this.currentIndex);
    }

    prevImage() {
        if (this.images.length === 0) return;
        this.currentIndex = (this.currentIndex - 1 + this.images.length) % this.images.length;
        this.showLightboxImage(this.currentIndex);
    }

    showLightboxImage(index) {
        if (!this.hasLightboxImgTarget) return;
        const img = this.images[index];
        if (img) {
            this.lightboxImgTarget.src = img.src;
            this.lightboxImgTarget.alt = img.alt;
        }
    }

    handleKeydown(e) {
        if (e.key === 'Escape') this.closeLightbox();
        if (e.key === 'ArrowRight') this.nextImage();
        if (e.key === 'ArrowLeft') this.prevImage();
    }
}

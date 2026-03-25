import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    select(event) {
        const btn = event.currentTarget;

        // Toggle active state
        this.element.querySelectorAll('.product-variant-btn').forEach((b) => {
            b.classList.toggle('active', b === btn);
        });

        // Update visible price in product-info__pricing
        const pricingEl = document.querySelector('.product-info__pricing');
        if (!pricingEl) return;

        const priceHT = parseFloat(btn.dataset.productVariantPriceHtParam);
        const priceTTC = parseFloat(btn.dataset.productVariantPriceTtcParam);
        const oldHT = parseFloat(btn.dataset.productVariantOldHtParam);
        const oldTTC = parseFloat(btn.dataset.productVariantOldTtcParam);

        const isDisplayHT = document.querySelector('.product-info__price-tax')?.textContent.trim() === 'HT';
        const mainPrice = isDisplayHT ? priceHT : priceTTC;
        const secondaryPrice = isDisplayHT ? priceTTC : priceHT;
        const secondaryLabel = isDisplayHT ? 'TTC' : 'HT';

        // Update main price
        const priceEl = pricingEl.querySelector('.product-info__price');
        if (priceEl && !isNaN(mainPrice)) {
            const taxLabel = priceEl.querySelector('.product-info__price-tax')?.outerHTML || '';
            priceEl.innerHTML = formatPrice(mainPrice) + ' € ' + taxLabel;
        }

        // Update secondary
        const secondaryEl = pricingEl.querySelector('.product-info__price-secondary');
        if (secondaryEl && !isNaN(secondaryPrice)) {
            secondaryEl.textContent = `soit ${formatPrice(secondaryPrice)} € ${secondaryLabel}`;
        }

        // Update old price
        const oldPriceEl = pricingEl.querySelector('.product-info__price-old');
        const oldPrice = isDisplayHT ? oldHT : oldTTC;
        if (oldPriceEl) {
            if (!isNaN(oldPrice) && oldPrice > 0) {
                oldPriceEl.textContent = `${formatPrice(oldPrice)} €`;
                oldPriceEl.style.display = '';
            } else {
                oldPriceEl.style.display = 'none';
            }
        }
    }
}

function formatPrice(value) {
    return value.toFixed(2).replace('.', ',').replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
}

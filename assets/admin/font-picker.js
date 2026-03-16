import './font-picker.scss';

/**
 * Font Picker — transforms font <select> fields into visual dropdowns
 * where each option is displayed in its own font.
 *
 * Targets: select[name*="fontFamily"], select[name*="fontFamilySecondary"]
 */

// All 20 fonts with their CSS values and Google Fonts URL names
const FONTS = {
    "'Inter', sans-serif": { label: 'Inter', google: 'Inter' },
    "'Poppins', sans-serif": { label: 'Poppins', google: 'Poppins' },
    "'Source Sans 3', sans-serif": { label: 'Source Sans 3', google: 'Source+Sans+3' },
    "'DM Sans', sans-serif": { label: 'DM Sans', google: 'DM+Sans' },
    "'Lato', sans-serif": { label: 'Lato', google: 'Lato' },
    "'Playfair Display', serif": { label: 'Playfair Display', google: 'Playfair+Display' },
    "'Space Grotesk', sans-serif": { label: 'Space Grotesk', google: 'Space+Grotesk' },
    "'Roboto', sans-serif": { label: 'Roboto', google: 'Roboto' },
    "'Open Sans', sans-serif": { label: 'Open Sans', google: 'Open+Sans' },
    "'Montserrat', sans-serif": { label: 'Montserrat', google: 'Montserrat' },
    "'Nunito', sans-serif": { label: 'Nunito', google: 'Nunito' },
    "'Raleway', sans-serif": { label: 'Raleway', google: 'Raleway' },
    "'Work Sans', sans-serif": { label: 'Work Sans', google: 'Work+Sans' },
    "'Oswald', sans-serif": { label: 'Oswald', google: 'Oswald' },
    "'Merriweather', serif": { label: 'Merriweather', google: 'Merriweather' },
    "'Lora', serif": { label: 'Lora', google: 'Lora' },
    "'Libre Baskerville', serif": { label: 'Libre Baskerville', google: 'Libre+Baskerville' },
    "'Manrope', sans-serif": { label: 'Manrope', google: 'Manrope' },
    "'Plus Jakarta Sans', sans-serif": { label: 'Plus Jakarta Sans', google: 'Plus+Jakarta+Sans' },
    "'Outfit', sans-serif": { label: 'Outfit', google: 'Outfit' },
};

// Load all 20 Google Fonts for preview
function loadAllFonts() {
    const families = Object.values(FONTS)
        .map(f => 'family=' + f.google + ':wght@400;700')
        .join('&');

    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = 'https://fonts.googleapis.com/css2?' + families + '&display=swap';
    document.head.appendChild(link);
}

// Build the custom font picker
function createFontPicker(select) {
    const wrapper = document.createElement('div');
    wrapper.className = 'font-picker';

    const selected = document.createElement('div');
    selected.className = 'font-picker__selected';
    selected.setAttribute('tabindex', '0');

    const dropdown = document.createElement('div');
    dropdown.className = 'font-picker__dropdown';

    // Get current value
    const currentValue = select.value;

    // Build options
    const options = select.querySelectorAll('option');
    options.forEach(option => {
        const item = document.createElement('div');
        item.className = 'font-picker__item';
        const cssValue = option.value;
        const font = FONTS[cssValue];

        if (cssValue === '') {
            // "Identique a la police principale" option
            item.textContent = option.textContent;
            item.style.fontStyle = 'italic';
            item.style.color = '#6b7280';
        } else if (font) {
            // Font preview
            const fontName = font.label;
            const category = cssValue.includes('serif') && !cssValue.includes('sans-serif')
                ? 'Serif'
                : cssValue.includes('sans-serif')
                    ? 'Sans-serif'
                    : 'Display';

            item.style.fontFamily = cssValue.replace(/'/g, '');

            const nameSpan = document.createElement('span');
            nameSpan.className = 'font-picker__name';
            nameSpan.textContent = fontName;

            const previewSpan = document.createElement('span');
            previewSpan.className = 'font-picker__preview';
            previewSpan.textContent = 'Aa Bb Cc 123';
            previewSpan.style.fontFamily = cssValue.replace(/'/g, '');

            const catSpan = document.createElement('span');
            catSpan.className = 'font-picker__category';
            catSpan.textContent = category;

            item.appendChild(nameSpan);
            item.appendChild(previewSpan);
            item.appendChild(catSpan);
        } else {
            item.textContent = option.textContent;
        }

        if (cssValue === currentValue) {
            item.classList.add('font-picker__item--active');
        }

        item.addEventListener('click', () => {
            // Update native select
            select.value = cssValue;
            select.dispatchEvent(new Event('change', { bubbles: true }));

            // Update selected display
            updateSelected(selected, cssValue);

            // Update active state
            dropdown.querySelectorAll('.font-picker__item').forEach(i =>
                i.classList.remove('font-picker__item--active')
            );
            item.classList.add('font-picker__item--active');

            // Close dropdown
            wrapper.classList.remove('font-picker--open');
        });

        dropdown.appendChild(item);
    });

    // Set initial selected display
    updateSelected(selected, currentValue);

    // Toggle dropdown
    selected.addEventListener('click', (e) => {
        e.stopPropagation();
        // Close other pickers
        document.querySelectorAll('.font-picker--open').forEach(fp => {
            if (fp !== wrapper) fp.classList.remove('font-picker--open');
        });
        wrapper.classList.toggle('font-picker--open');

        // Scroll to active item
        if (wrapper.classList.contains('font-picker--open')) {
            const active = dropdown.querySelector('.font-picker__item--active');
            if (active) {
                active.scrollIntoView({ block: 'center', behavior: 'instant' });
            }
        }
    });

    // Keyboard support
    selected.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            selected.click();
        }
    });

    wrapper.appendChild(selected);
    wrapper.appendChild(dropdown);

    // Hide native select and its EasyAdmin wrapper
    select.style.display = 'none';
    select.setAttribute('aria-hidden', 'true');
    // EasyAdmin wraps selects in a div — hide the whole wrapper
    const parentWrapper = select.closest('.form-widget') || select.parentNode;
    parentWrapper.insertBefore(wrapper, parentWrapper.firstChild);
    // Hide any sibling elements (the original select + its container)
    Array.from(parentWrapper.children).forEach(child => {
        if (child !== wrapper) {
            child.style.display = 'none';
        }
    });
}

function updateSelected(selectedEl, cssValue) {
    const font = FONTS[cssValue];
    if (!cssValue || cssValue === '') {
        selectedEl.textContent = 'Identique a la police principale';
        selectedEl.style.fontFamily = '';
        selectedEl.style.fontStyle = 'italic';
        selectedEl.style.color = '#6b7280';
    } else if (font) {
        selectedEl.textContent = font.label;
        selectedEl.style.fontFamily = cssValue.replace(/'/g, '');
        selectedEl.style.fontStyle = '';
        selectedEl.style.color = '';
    } else {
        selectedEl.textContent = cssValue;
        selectedEl.style.fontFamily = '';
        selectedEl.style.fontStyle = '';
        selectedEl.style.color = '';
    }
}

// Close all dropdowns on outside click
document.addEventListener('click', () => {
    document.querySelectorAll('.font-picker--open').forEach(fp =>
        fp.classList.remove('font-picker--open')
    );
});

// Init
document.addEventListener('DOMContentLoaded', () => {
    const fontSelects = document.querySelectorAll(
        'select[name*="fontFamily"], select[name*="fontFamilySecondary"]'
    );

    if (fontSelects.length > 0) {
        loadAllFonts();
        fontSelects.forEach(select => createFontPicker(select));
    }
});

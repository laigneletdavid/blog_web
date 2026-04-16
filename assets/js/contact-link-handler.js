/**
 * Contact link handler — desktop-only.
 *
 * Sur desktop (hover + pointer fin), intercepte les clics sur a[href^="mailto:"]
 * et a[href^="tel:"] : copie l'email/telephone dans le presse-papier au lieu
 * de declencher le client mail systeme ou le dialer (qui peuvent etre
 * intrusifs / mal configures sur poste de travail).
 *
 * Sur mobile/tablette tactile, comportement natif preserve.
 */

const isDesktop = () =>
    window.matchMedia('(hover: hover) and (pointer: fine)').matches;

function showToast(message) {
    const toast = document.createElement('div');
    toast.className = 'contact-link-toast';
    toast.textContent = message;
    toast.style.cssText = [
        'position:fixed',
        'bottom:24px',
        'left:50%',
        'transform:translateX(-50%) translateY(20px)',
        'background:#212529',
        'color:#fff',
        'padding:0.6rem 1.2rem',
        'border-radius:6px',
        'box-shadow:0 4px 12px rgba(0,0,0,0.2)',
        'font-size:0.9rem',
        'z-index:10100',
        'opacity:0',
        'transition:opacity 0.2s, transform 0.2s',
        'pointer-events:none',
    ].join(';');
    document.body.appendChild(toast);

    requestAnimationFrame(() => {
        toast.style.opacity = '1';
        toast.style.transform = 'translateX(-50%) translateY(0)';
    });

    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(-50%) translateY(20px)';
        setTimeout(() => toast.remove(), 250);
    }, 1800);
}

async function copyToClipboard(text) {
    try {
        await navigator.clipboard.writeText(text);
        return true;
    } catch {
        // Fallback execCommand pour vieux navigateurs / contextes non-securises
        const ta = document.createElement('textarea');
        ta.value = text;
        ta.setAttribute('readonly', '');
        ta.style.cssText = 'position:absolute;left:-9999px';
        document.body.appendChild(ta);
        ta.select();
        try {
            document.execCommand('copy');
            return true;
        } catch {
            return false;
        } finally {
            ta.remove();
        }
    }
}

function handleClick(event) {
    if (!isDesktop()) return;

    const link = event.target.closest('a[href^="mailto:"], a[href^="tel:"]');
    if (!link) return;

    event.preventDefault();

    const href = link.getAttribute('href');
    const isMail = href.startsWith('mailto:');
    const value = href.replace(/^(mailto:|tel:)/, '').split('?')[0];

    copyToClipboard(value).then(ok => {
        if (ok) {
            showToast(isMail ? `Email copie : ${value}` : `Numero copie : ${value}`);
        } else {
            showToast('Impossible de copier');
        }
    });
}

document.addEventListener('click', handleClick);

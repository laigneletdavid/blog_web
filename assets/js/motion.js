// Outils communs aux controleurs d'animation (reveal, wave-draw, count-up).

// Vrai si l'element merite une animation d'entree : il est hors de l'ecran,
// le navigateur sait l'observer et le visiteur n'a pas demande moins de mouvement.
export function awaitsEntry(el) {
    if (!('IntersectionObserver' in window) || matchMedia('(prefers-reduced-motion: reduce)').matches) return false;
    const box = el.getBoundingClientRect();
    return box.top >= window.innerHeight || box.bottom <= 0;
}

// Appelle « done » une seule fois, quand l'element entre a l'ecran.
// Renvoie l'observer, a deconnecter dans disconnect().
export function onEntry(el, done, margin = '-10%') {
    const observer = new IntersectionObserver((entries) => {
        if (!entries[0].isIntersecting) return;
        observer.disconnect();
        done();
    }, { rootMargin: `0px 0px ${margin} 0px` });
    observer.observe(el);
    return observer;
}

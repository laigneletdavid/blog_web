/**
 * stat-tracker.js — Tracking comportemental first-party (RGPD : interet legitime)
 *
 * Fonctions :
 * - Heartbeat 15s → POST /api/stat/ping (duration_seconds)
 * - Scroll tracking → POST /api/stat/scroll (scroll_max_pct) au beforeunload
 * - Click tracking → POST /api/stat/conversion (tel: / mailto:)
 *
 * Le session token est lu depuis le cookie _bw_sid pose par le serveur.
 */
(function () {
    'use strict';

    // --- Lire le cookie _bw_sid ---
    var token = (function () {
        var match = document.cookie.match(/(?:^|;\s*)_bw_sid=([^;]+)/);
        return match ? match[1] : null;
    })();

    if (!token) return; // Pas de session, on ne track rien

    var pageEnteredAt = Date.now();

    // =============================================
    // 1. HEARTBEAT — ping toutes les 15s
    // =============================================
    var heartbeatInterval = setInterval(function () {
        if (document.hidden) return;

        var duration = Math.round((Date.now() - pageEnteredAt) / 1000);
        navigator.sendBeacon('/api/stat/ping', JSON.stringify({
            token: token,
            duration: duration
        }));
    }, 15000);

    // =============================================
    // 2. SCROLL TRACKING — envoie le max au depart
    // =============================================
    var maxScroll = 0;

    function updateMaxScroll() {
        var scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight;
        if (scrollHeight <= 0) return;

        var pct = Math.round(
            (window.scrollY + window.innerHeight) / scrollHeight * 100
        );
        if (pct > maxScroll) {
            maxScroll = Math.min(pct, 100);
        }
    }

    // Calcul initial (pages courtes = 100% sans scroll)
    updateMaxScroll();

    window.addEventListener('scroll', updateMaxScroll, { passive: true });

    // Envoyer au depart de la page (beforeunload + visibilitychange pour mobile)
    function sendScroll() {
        navigator.sendBeacon('/api/stat/scroll', JSON.stringify({
            token: token,
            scrollPct: maxScroll
        }));
    }

    window.addEventListener('beforeunload', sendScroll);
    document.addEventListener('visibilitychange', function () {
        if (document.visibilityState === 'hidden') {
            sendScroll();
            // Aussi envoyer le dernier ping de duree
            var duration = Math.round((Date.now() - pageEnteredAt) / 1000);
            navigator.sendBeacon('/api/stat/ping', JSON.stringify({
                token: token,
                duration: duration
            }));
        }
    });

    // =============================================
    // 3. CONVERSION TRACKING — clics tel: / mailto:
    // =============================================
    document.addEventListener('click', function (e) {
        var link = e.target.closest('a[href^="tel:"], a[href^="mailto:"]');
        if (!link) return;

        var type = link.href.startsWith('tel:') ? 'phone_click' : 'email_click';
        navigator.sendBeacon('/api/stat/conversion', JSON.stringify({
            token: token,
            type: type,
            pageUrl: window.location.pathname
        }));
    });
})();

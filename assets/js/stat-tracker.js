/**
 * stat-tracker.js — Tracking comportemental first-party (RGPD : interet legitime)
 *
 * Fonctions :
 * - Confirmation de la visite → POST /api/vue au chargement (c'est elle qui
 *   enregistre la page : un robot qui n'execute pas ce script ne compte pas)
 * - Heartbeat 15s → POST /api/stat/ping (duration_seconds)
 * - Scroll tracking → POST /api/stat/scroll (scroll_max_pct) au beforeunload
 * - Click tracking → POST /api/stat/conversion (tel: / mailto: / liens de carte)
 *
 * Le ticket de visite est lu dans <meta name="bw-visit">, signe par le serveur
 * (PageViewSubscriber). Le session token est lu ensuite depuis le cookie
 * _bw_sid, pose par la reponse de /api/vue.
 */
(function () {
    'use strict';

    var ticket = document.querySelector('meta[name="bw-visit"]');
    if (!ticket || !window.fetch) return; // Page non mesuree (robot reconnu, admin...)

    var pageEnteredAt = Date.now();

    // =============================================
    // 0. CONFIRMATION DE LA VISITE
    // =============================================
    fetch('/api/vue', {
        method: 'POST',
        credentials: 'same-origin',
        keepalive: true,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            ticket: ticket.content,
            referrer: document.referrer,
            query: window.location.search,
            webdriver: navigator.webdriver === true
        })
    }).then(function () {
        // --- Lire le cookie _bw_sid ---
        var match = document.cookie.match(/(?:^|;\s*)_bw_sid=([^;]+)/);
        if (match) start(match[1]); // Pas de session (robot), on ne track rien
    }).catch(function () {});

    function start(token) {
        // =============================================
        // 1. HEARTBEAT — ping toutes les 15s
        // =============================================
        setInterval(function () {
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
        // 3. CONVERSION TRACKING — clics tel: / mailto: / itineraire
        // =============================================
        var mapLink = /(google\.[a-z.]+\/maps|maps\.google\.|maps\.app\.goo\.gl|goo\.gl\/maps|openstreetmap\.org|waze\.com|maps\.apple\.com)/i;

        document.addEventListener('click', function (e) {
            var link = e.target.closest('a[href]');
            if (!link) return;

            var type = null;
            if (link.href.startsWith('tel:')) type = 'phone_click';
            else if (link.href.startsWith('mailto:')) type = 'email_click';
            else if (mapLink.test(link.href)) type = 'directions_click';
            if (!type) return;

            navigator.sendBeacon('/api/stat/conversion', JSON.stringify({
                token: token,
                type: type,
                pageUrl: window.location.pathname
            }));
        });
    }
})();

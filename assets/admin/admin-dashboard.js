import './admin-dashboard.scss';

// ────────────────────────────────────────
// Chart.js — Visites 30 derniers jours
// ────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
    initChart();
    initTips();
});

async function initChart() {
    const canvas = document.getElementById('visitsChart');
    if (!canvas) return;

    const rawData = JSON.parse(canvas.dataset.stats || '[]');
    if (rawData.length === 0) {
        canvas.parentElement.innerHTML = '<p class="text-muted text-center py-4">Pas encore de donnees de visites.</p>';
        return;
    }

    // Dynamic import to keep bundle light on non-dashboard pages
    const { Chart, registerables } = await import('chart.js');
    Chart.register(...registerables);

    const labels = rawData.map(d => {
        const date = new Date(d.date);
        return date.toLocaleDateString('fr-FR', { day: '2-digit', month: 'short' });
    });

    const views = rawData.map(d => parseInt(d.views, 10));
    const visitors = rawData.map(d => parseInt(d.visitors, 10));

    new Chart(canvas, {
        type: 'line',
        data: {
            labels,
            datasets: [
                {
                    label: 'Pages vues',
                    data: views,
                    borderColor: '#2563eb',
                    backgroundColor: 'rgba(37, 99, 235, 0.08)',
                    fill: true,
                    tension: 0.3,
                    pointRadius: 2,
                    pointHoverRadius: 5,
                    borderWidth: 2,
                },
                {
                    label: 'Visiteurs uniques',
                    data: visitors,
                    borderColor: '#7c3aed',
                    backgroundColor: 'rgba(124, 58, 237, 0.05)',
                    fill: true,
                    tension: 0.3,
                    pointRadius: 2,
                    pointHoverRadius: 5,
                    borderWidth: 2,
                    borderDash: [5, 3],
                },
            ],
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                mode: 'index',
                intersect: false,
            },
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                        usePointStyle: true,
                        padding: 16,
                        font: { size: 12 },
                    },
                },
                tooltip: {
                    backgroundColor: '#1e293b',
                    titleFont: { size: 13 },
                    bodyFont: { size: 12 },
                    padding: 10,
                    cornerRadius: 8,
                },
            },
            scales: {
                x: {
                    grid: { display: false },
                    ticks: { font: { size: 11 }, maxRotation: 0 },
                },
                y: {
                    beginAtZero: true,
                    grid: { color: '#f1f5f9' },
                    ticks: { font: { size: 11 }, precision: 0 },
                },
            },
        },
    });
}

// ────────────────────────────────────────
// Tips contextuels rotatifs
// ────────────────────────────────────────
const TIPS = [
    "Pensez a remplir les champs SEO de vos articles pour ameliorer votre referencement Google.",
    "Vous pouvez reorganiser votre menu via Reglages \u2192 Navigation par glisser-deposer.",
    "Les images sont automatiquement converties en WebP pour un chargement plus rapide.",
    "Un bon titre SEO fait entre 50 et 70 caracteres. Soyez precis et accrocheur !",
    "Ajoutez un texte alternatif (alt) a vos images : c'est important pour le SEO et l'accessibilite.",
    "Utilisez les categories pour organiser vos articles et faciliter la navigation.",
    "La meta-description ideale fait entre 120 et 160 caracteres. Elle apparait dans les resultats Google.",
    "Vous pouvez mettre un article en avant via le champ 'Article vedette' dans le formulaire d'edition.",
    "Le sitemap XML est genere automatiquement. Soumettez-le dans Google Search Console pour un meilleur indexage.",
    "Les brouillons ne sont pas visibles par vos visiteurs. Prenez le temps de peaufiner avant de publier !",
    "Ajoutez des tags a vos articles pour ameliorer la navigation et le maillage interne.",
    "Vous pouvez changer les couleurs et polices de votre site dans Reglages \u2192 Apparence.",
    "Le formulaire de contact envoie les messages directement a l'adresse email configuree dans l'identite du site.",
    "Les commentaires sont visibles en temps reel. Consultez-les regulierement pour interagir avec vos lecteurs.",
    "Besoin d'aide ? Consultez le Guide complet accessible depuis le menu Aide.",
];

function initTips() {
    const container = document.getElementById('dashboardTip');
    const textEl = document.getElementById('tipText');
    const nextBtn = document.getElementById('tipNext');
    const closeBtn = document.getElementById('tipClose');

    if (!container || !textEl) return;

    const hidden = localStorage.getItem('bw_tips_hidden') === '1';
    if (hidden) return;

    let index = parseInt(localStorage.getItem('bw_tips_index') || '0', 10);
    if (index >= TIPS.length) index = 0;

    textEl.textContent = TIPS[index];
    container.style.display = '';

    nextBtn?.addEventListener('click', () => {
        index = (index + 1) % TIPS.length;
        localStorage.setItem('bw_tips_index', String(index));
        textEl.textContent = TIPS[index];
    });

    closeBtn?.addEventListener('click', () => {
        localStorage.setItem('bw_tips_hidden', '1');
        container.style.display = 'none';
    });

    // Auto-advance for next visit
    localStorage.setItem('bw_tips_index', String((index + 1) % TIPS.length));
}

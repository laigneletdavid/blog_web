/**
 * admin-stats.js — Charts Chart.js pour les pages stats admin.
 */
import './admin-stats.scss';
import { Chart, registerables } from 'chart.js';
Chart.register(...registerables);

document.addEventListener('DOMContentLoaded', function () {

    // =============================================
    // DONUT : Sources de trafic
    // =============================================
    const sourcesCanvas = document.getElementById('sourcesChart');
    if (sourcesCanvas) {
        const sources = JSON.parse(sourcesCanvas.dataset.sources || '[]');
        if (sources.length > 0) {
            const labels = sources.map(s => s.source.replace(/_/g, ' '));
            const data = sources.map(s => parseInt(s.cnt, 10));

            const palette = [
                '#2563eb', '#16a34a', '#d97706', '#7c3aed',
                '#db2777', '#0891b2', '#ca8a04', '#64748b',
            ];

            new Chart(sourcesCanvas, {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        data: data,
                        backgroundColor: palette.slice(0, data.length),
                        borderWidth: 2,
                        borderColor: '#fff',
                    }],
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: { font: { size: 12 }, padding: 12 },
                        },
                        tooltip: {
                            callbacks: {
                                label: function (ctx) {
                                    var total = ctx.dataset.data.reduce(function (a, b) { return a + b; }, 0);
                                    var pct = total > 0 ? (ctx.raw / total * 100).toFixed(1) : 0;
                                    return ctx.label + ': ' + ctx.raw + ' (' + pct + '%)';
                                },
                            },
                        },
                    },
                },
            });
        }
    }

    // =============================================
    // DONUT : Appareils (desktop / mobile / tablet)
    // =============================================
    const devicesCanvas = document.getElementById('devicesChart');
    if (devicesCanvas) {
        const devices = JSON.parse(devicesCanvas.dataset.devices || '[]');
        if (devices.length > 0) {
            const deviceLabels = {
                desktop: 'Desktop',
                mobile: 'Mobile',
                tablet: 'Tablette',
                unknown: 'Inconnu',
            };
            const deviceColors = {
                desktop: '#2563eb',
                mobile: '#16a34a',
                tablet: '#d97706',
                unknown: '#94a3b8',
            };

            const labels = devices.map(d => deviceLabels[d.device_type] || d.device_type);
            const data = devices.map(d => parseInt(d.cnt, 10));
            const colors = devices.map(d => deviceColors[d.device_type] || '#64748b');

            new Chart(devicesCanvas, {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        data: data,
                        backgroundColor: colors,
                        borderWidth: 2,
                        borderColor: '#fff',
                    }],
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: { font: { size: 12 }, padding: 10 },
                        },
                        tooltip: {
                            callbacks: {
                                label: function (ctx) {
                                    var total = ctx.dataset.data.reduce(function (a, b) { return a + b; }, 0);
                                    var pct = total > 0 ? (ctx.raw / total * 100).toFixed(1) : 0;
                                    return ctx.label + ': ' + ctx.raw + ' (' + pct + '%)';
                                },
                            },
                        },
                    },
                },
            });
        }
    }

    // =============================================
    // LINE : Comportement timeline
    // =============================================
    const behaviorCanvas = document.getElementById('behaviorChart');
    if (behaviorCanvas) {
        const timeline = JSON.parse(behaviorCanvas.dataset.timeline || '[]');
        if (timeline.length > 0) {
            const labels = timeline.map(t => {
                var d = new Date(t.date);
                return d.getDate() + '/' + (d.getMonth() + 1);
            });
            const data = timeline.map(t => parseFloat(t.value) || 0);

            new Chart(behaviorCanvas, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        data: data,
                        borderColor: '#2563eb',
                        backgroundColor: 'rgba(37, 99, 235, 0.08)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.3,
                        pointRadius: 2,
                        pointHoverRadius: 5,
                    }],
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                    },
                    scales: {
                        y: { beginAtZero: true, grid: { color: '#f1f5f9' } },
                        x: { grid: { display: false } },
                    },
                },
            });
        }
    }

});

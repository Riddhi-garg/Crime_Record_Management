/* ============================================================================
   Crime Record Management System (CRMS) - Interactive JavaScript
   Includes Chart.js graph renders, password toggles, sidebar handlers
   ============================================================================ */

document.addEventListener('DOMContentLoaded', function () {
    // ------------------------------------------------------------------------
    // 1. Sidebar Toggle Handler for Mobile Viewports
    // ------------------------------------------------------------------------
    const sidebarToggleBtn = document.getElementById('sidebarToggleBtn');
    const sidebar = document.getElementById('sidebar');

    if (sidebarToggleBtn && sidebar) {
        sidebarToggleBtn.addEventListener('click', function () {
            sidebar.classList.toggle('show');
        });
    }

    // ------------------------------------------------------------------------
    // 2. Show / Hide Password Toggle
    // ------------------------------------------------------------------------
    const togglePasswordBtn = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');

    if (togglePasswordBtn && passwordInput) {
        togglePasswordBtn.addEventListener('click', function () {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.querySelector('i').classList.toggle('bi-eye');
            this.querySelector('i').classList.toggle('bi-eye-slash');
        });
    }

    // ------------------------------------------------------------------------
    // 3. Auto-Dismiss Bootstrap Alerts after 5 seconds
    // ------------------------------------------------------------------------
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // ------------------------------------------------------------------------
    // 4. Initialize Chart.js Graphs on Dashboard Page
    // ------------------------------------------------------------------------
    initDashboardCharts();
});

function initDashboardCharts() {
    // Check if chart elements exist on current page
    const monthChartCtx = document.getElementById('crimesByMonthChart');
    const categoryChartCtx = document.getElementById('crimesByCategoryChart');
    const statusChartCtx = document.getElementById('solvedVsUnsolvedChart');
    const locationChartCtx = document.getElementById('crimesByLocationChart');

    // Chart 1: Crimes By Month (Line Chart)
    if (monthChartCtx && window.crmsChartData) {
        const monthData = window.crmsChartData.months || {};
        new Chart(monthChartCtx, {
            type: 'line',
            data: {
                labels: Object.keys(monthData),
                datasets: [{
                    label: 'Incidents Reported',
                    data: Object.values(monthData),
                    borderColor: '#2563eb',
                    backgroundColor: 'rgba(37, 99, 235, 0.1)',
                    fill: true,
                    tension: 0.35,
                    borderWidth: 2,
                    pointRadius: 4,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: { beginAtZero: true, ticks: { precision: 0 } }
                }
            }
        });
    }

    // Chart 2: Crimes By Category (Doughnut / Bar Chart)
    if (categoryChartCtx && window.crmsChartData) {
        const categoryData = window.crmsChartData.categories || {};
        new Chart(categoryChartCtx, {
            type: 'doughnut',
            data: {
                labels: Object.keys(categoryData),
                datasets: [{
                    data: Object.values(categoryData),
                    backgroundColor: [
                        '#2563eb', '#dc2626', '#d97706', '#16a34a', 
                        '#9333ea', '#0891b2', '#475569', '#ca8a04'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });
    }

    // Chart 3: Solved vs Unsolved Cases (Pie Chart)
    if (statusChartCtx && window.crmsChartData) {
        const statusData = window.crmsChartData.status || {};
        new Chart(statusChartCtx, {
            type: 'pie',
            data: {
                labels: Object.keys(statusData),
                datasets: [{
                    data: Object.values(statusData),
                    backgroundColor: ['#16a34a', '#2563eb', '#d97706', '#dc2626', '#64748b']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });
    }

    // Chart 4: Crimes By Location / City (Bar Chart)
    if (locationChartCtx && window.crmsChartData) {
        const locData = window.crmsChartData.locations || {};
        new Chart(locationChartCtx, {
            type: 'bar',
            data: {
                labels: Object.keys(locData),
                datasets: [{
                    label: 'Crimes Registered',
                    data: Object.values(locData),
                    backgroundColor: '#0f172a',
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: { beginAtZero: true, ticks: { precision: 0 } }
                }
            }
        });
    }
}

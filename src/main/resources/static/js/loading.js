document.addEventListener('DOMContentLoaded', function() {
    const loadingScreen = document.getElementById('loadingScreen');
    const progressBar = document.getElementById('progressBar');
    const loadingPercentage = document.getElementById('loadingPercentage');

    let progress = 0;

    // Имитация загрузки ресурсов
    function updateProgress() {
        // Реальное отслеживание загрузки
        const resources = document.querySelectorAll('img, script, link, iframe');
        const total = resources.length;
        let loaded = 0;

        // Проверяем загрузку каждого ресурса
        resources.forEach(resource => {
            if (resource.complete || resource.readyState === 4) {
                loaded++;
            } else {
                resource.addEventListener('load', () => {
                    loaded++;
                    calculateProgress();
                });
                resource.addEventListener('error', () => {
                    loaded++; // Все равно считаем как загруженное
                    calculateProgress();
                });
            }
        });

        function calculateProgress() {
            progress = Math.min(100, Math.round((loaded / total) * 100));
            progressBar.style.width = progress + '%';
            loadingPercentage.textContent = progress + '%';

            if (progress >= 100) {
                setTimeout(() => {
                    loadingScreen.style.opacity = '0';
                    setTimeout(() => {
                        loadingScreen.style.display = 'none';
                    }, 500);
                }, 300);
            }
        }

        // Инициализация
        calculateProgress();

        // На всякий случай - завершаем через 3 секунды
        setTimeout(() => {
            if (progress < 100) {
                progressBar.style.width = '100%';
                loadingPercentage.textContent = '100%';
                setTimeout(() => {
                    loadingScreen.style.opacity = '0';
                    setTimeout(() => {
                        loadingScreen.style.display = 'none';
                    }, 500);
                }, 300);
            }
        }, 3000);
    }

    updateProgress();
});

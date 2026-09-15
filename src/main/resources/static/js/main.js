function tableSearch_emp() {
    const searchText = document.getElementById('search-emp').value.trim();
    const table = document.getElementById('addr-table');
    const searchRegex = new RegExp(searchText, 'i');

    // Обработка пустого поиска
    if (!searchText) {
        Array.from(table.rows).forEach(row => row.style.display = "");
        return;
    }

    // Поиск по строкам (начиная со второй строки - индекса 1)
    for (let i = 1; i < table.rows.length; i++) {
        const row = table.rows[i];
        let found = false;

        // Поиск по ячейкам (начиная со второй ячейки - индекса 1)
        for (let j = 1; j < row.cells.length; j++) {
            if (searchRegex.test(row.cells[j].textContent)) {
                found = true;
                break;
            }
        }

        row.style.display = found ? "" : "none";
    }
}

function tableSearch_docs() {
    const searchText = document.getElementById('search-docs').value.trim();
    const table = document.getElementById('text-table');
    const searchRegex = new RegExp(searchText, 'i');

    // Обработка пустого поиска
    if (!searchText) {
        Array.from(table.rows).forEach(row => row.style.display = "");
        return;
    }

    // Поиск по строкам (начиная со второй строки - индекса 1)
    for (let i = 1; i < table.rows.length; i++) {
        const row = table.rows[i];
        let found = false;

        // Поиск по ячейкам (начиная с первой ячейки - индекса 0)
        for (let j = 0; j < row.cells.length; j++) {
            if (searchRegex.test(row.cells[j].textContent)) {
                found = true;
                break;
            }
        }

        row.style.display = found ? "" : "none";
    }
}

var countOfFields = 1;
var curFieldNameId = 1;
function deleteField(a) {

        a = document.getElementById("col").remove();


    return false;
}

function goUpOneLevel() {
    window.location.href = "/lna";
}

function goUpOneLevelTempl() {
    window.location.href = "/templates_new";
}

function downloadFile(bucket, path) {
    // Создаем скрытую ссылку для скачивания
    const link = document.createElement('a');
    link.href = `/download?bucket=${bucket}&path=${encodeURIComponent(path)}`;
    link.download = path.substring(path.lastIndexOf('/') + 1);
    link.style.display = 'none';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

function clearSearch() {
    const url = new URL(window.location.href);
    url.searchParams.delete('Поиск');
    window.location.href = url.toString();
}

document.addEventListener('DOMContentLoaded', function() {
    // Получаем элементы управления
    const searchInput = document.getElementById('searchInput');
    const searchButton = document.getElementById('searchButton');
    const clearSearchButton = document.getElementById('clearSearchButton');
    const searchResultsPanel = document.getElementById('searchResultsPanel');
    const directoriesPanel = document.getElementById('directoriesPanel');
    const filesPanel = document.getElementById('filesPanel');

    // Получаем параметры из скрытых полей
    const bucket = document.getElementById('bucketValue').value;
    const currentPath = document.getElementById('pathValue').value;

    // Обработчики событий
    searchButton.addEventListener('click', performSearch);
    clearSearchButton.addEventListener('click', clearSearch);

    searchInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') performSearch();
    });

    // Функция выполнения поиска
    async function performSearch() {
        const query = searchInput.value.trim();
        if (!query) {
            clearSearch();
            return;
        }

        try {
            // Показываем индикатор загрузки
            searchButton.disabled = true;
            searchButton.innerHTML = '<span class="loader"></span> Поиск...';

            // Формируем URL для поиска
            const url = `/api/search?bucket=${encodeURIComponent(bucket)}&path=${encodeURIComponent(currentPath)}&query=${encodeURIComponent(query)}`;
            console.log(url);
            const response = await fetch(url);

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const files = await response.json();
            displaySearchResults(files, query);

            // Показываем кнопку очистки
            clearSearchButton.style.display = 'inline-block';

        } catch (error) {
            console.error('Search failed:', error);
            alert('Search failed: ' + error.message);
        } finally {
            // Восстанавливаем кнопку
            searchButton.disabled = false;
            searchButton.textContent = 'Поиск';
        }
    }

    // Функция отображения результатов
    function displaySearchResults(files, query) {
        try {
            // Проверяем элементы перед использованием
            if (!directoriesPanel || !filesPanel || !searchResultsPanel) {
                throw new Error('Required panels not found');
            }

            directoriesPanel.style.display = 'none';
            filesPanel.style.display = 'none';
            searchResultsPanel.style.display = 'block';

            const content = document.getElementById('searchResultsContent');

            if (content) {
                content.innerHTML = files.length ?
                    createResultsTable(files) :
                    '<div class="no-results">Документы не найдены</div>';
            }

            if (clearSearchButton) {
                clearSearchButton.style.display = 'inline-block';
            }
        } catch (error) {
            console.error('Ошибка отображения результатов:', error);
            showMessage('Ошибка отображения результатов поиска', 'error');
        }
    }

    // Функция создания таблицы результатов
    function createResultsTable(files) {
        return `
        <div class="content">
            <table class="file-table-search">
                <thead>
                    <tr>
                        <th>Найденные документа</th>
                        <th class="file-size">Размер</th>
                    </tr>
                </thead>
                <tbody>
                    ${files.map(file => `
                        <tr onclick="downloadFile('${bucket}', '${escapeHtml(file.path)}')">
                            <td>${getFileIcon(file.extension)} ${escapeHtml(file.name)}</td>
                            <td class="file-size">${formatFileSize(file.size)}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        </div>
        `;
    }

    // Функция очистки поиска с проверкой элементов
    function clearSearch() {
        try {
            if (searchInput) searchInput.value = '';
            if (clearSearchButton) clearSearchButton.style.display = 'none';
            if (directoriesPanel) directoriesPanel.style.display = 'block';
            if (filesPanel) filesPanel.style.display = 'block';
            if (searchResultsPanel) searchResultsPanel.style.display = 'none';
        } catch (error) {
            console.error('Error clearing search:', error);
        }
    }

    // Экранирование HTML для безопасности
    function escapeHtml(unsafe) {
        return unsafe
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }
    function downloadFile(bucket, path) {
        window.location.href = `/download?bucket=${bucket}&path=${encodeURIComponent(path)}`;
    }

    function formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2) + ' ' + sizes[i]);
    }

    function getFileIcon(extension) {
        const ext = (extension || '').toLowerCase();
        const iconColor = getIconColor(ext);

        // Общая часть SVG для всех иконок
        const svgBase = `<svg class="file-icon" style="color: ${iconColor}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">`;

        // Иконки для разных типов файлов
        const icons = {
            // Папка (хотя в этой функции не должна использоваться для папок)
            folder: `${svgBase}<path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 2h9a2 2 0 0 1 2 2z"/></svg>`,

            // Архивы
            zip: `${svgBase}<path d="M21 15a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h3l2-2h6l2 2h3a2 2 0 0 1 2 2z"/><circle cx="7" cy="10" r="1"/><circle cx="7" cy="14" r="1"/><circle cx="12" cy="12" r="1"/><circle cx="17" cy="10" r="1"/><circle cx="17" cy="14" r="1"/></svg>`,
            rar: `${svgBase}<path d="M21 15a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h3l2-2h6l2 2h3a2 2 0 0 1 2 2z"/><path d="M7 10h.01M7 14h.01M12 12h.01M17 10h.01M17 14h.01"/></svg>`,

            // Документы
            pdf: `${svgBase}<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="10" y1="13" x2="10" y2="15"/><line x1="10" y1="17" x2="10" y2="17"/><line x1="14" y1="13" x2="14" y2="15"/><line x1="14" y1="17" x2="14" y2="17"/><line x1="18" y1="13" x2="18" y2="15"/><line x1="18" y1="17" x2="18" y2="17"/></svg>`,
            doc: `${svgBase}<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="16" y2="16"/><line x1="16" y1="17" x2="16" y2="19"/><line x1="10" y1="13" x2="10" y2="16"/><line x1="10" y1="17" x2="10" y2="19"/><line x1="13" y1="13" x2="13" y2="16"/><line x1="13" y1="17" x2="13" y2="19"/></svg>`,
            docx: `${svgBase}<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><path d="M16 13v3"/><path d="M16 17v2"/><path d="M10 13v3"/><path d="M10 17v2"/><path d="M13 13v3"/><path d="M13 17v2"/></svg>`,

            // Таблицы
            xls: `${svgBase}<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="8" y1="13" x2="8" y2="15"/><line x1="8" y1="17" x2="8" y2="19"/><line x1="12" y1="13" x2="12" y2="15"/><line x1="12" y1="17" x2="12" y2="19"/><line x1="16" y1="13" x2="16" y2="15"/><line x1="16" y1="17" x2="16" y2="19"/></svg>`,
            xlsx: `${svgBase}<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><path d="M8 13v2"/><path d="M8 17v2"/><path d="M12 13v2"/><path d="M12 17v2"/><path d="M16 13v2"/><path d="M16 17v2"/></svg>`,

            // Изображения
            jpg: `${svgBase}<rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>`,
            png: `${svgBase}<rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-3.086-3.086a2 2 0 0 0-2.828 0L6 21"/></svg>`,
            gif: `${svgBase}<rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><path d="M8 10h.01"/><path d="M12 10h.01"/><path d="M16 10h.01"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/></svg>`,

            // Аудио
            mp3: `${svgBase}<path d="M3 18v-6a9 9 0 0 1 18 0v6"/><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3z"/><path d="M3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/></svg>`,
            wav: `${svgBase}<path d="M3 18v-6a9 9 0 0 1 18 0v6"/><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3z"/><path d="M3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/><path d="M8 12h.01"/><path d="M12 12h.01"/><path d="M16 12h.01"/></svg>`,

            // Видео
            mp4: `${svgBase}<rect x="2" y="6" width="20" height="12" rx="2" ry="2"/><path d="M10 9l5 3-5 3V9z"/></svg>`,
            avi: `${svgBase}<rect x="2" y="6" width="20" height="12" rx="2" ry="2"/><path d="M10 9l5 3-5 3V9z"/><path d="M17 9v6"/></svg>`,

            // Код
            js: `${svgBase}<path d="M12 18V6"/><path d="M6 12l6 6 6-6"/><path d="M17 6v12"/><path d="M7 6v12"/></svg>`,
            html: `${svgBase}<path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7"/><path d="M12 17l4-4-4-4"/><path d="M16 17l-4-4 4-4"/></svg>`,

            // Стандартная иконка для неизвестных типов
            default: `${svgBase}<path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/><polyline points="13 2 13 9 20 9"/></svg>`
        };

        // Определяем нужную иконку
        if (['zip', 'rar', '7z', 'tar', 'gz'].includes(ext)) return icons.zip;
        if (['pdf'].includes(ext)) return icons.pdf;
        if (['doc', 'docx', 'odt'].includes(ext)) return icons.doc;
        if (['xls', 'xlsx', 'ods'].includes(ext)) return icons.xls;
        if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg', 'webp'].includes(ext)) return icons.jpg;
        if (['mp3', 'wav', 'ogg', 'flac'].includes(ext)) return icons.mp3;
        if (['mp4', 'avi', 'mov', 'mkv', 'webm'].includes(ext)) return icons.mp4;
        if (['js', 'ts', 'json'].includes(ext)) return icons.js;
        if (['html', 'htm', 'css', 'xml'].includes(ext)) return icons.html;

        return icons.default;
    }

    /**
     * Возвращает цвет иконки в зависимости от типа файла
     * @param {string} extension - расширение файла
     * @returns {string} цвет в HEX-формате
     */
    function getIconColor(extension) {
        const ext = (extension || '').toLowerCase();
        const colors = {
            // Архивы
            zip: '#FF9800',
            rar: '#F44336',
            // Документы
            pdf: '#F44336',
            doc: '#2196F3',
            docx: '#2196F3',
            // Таблицы
            xls: '#4CAF50',
            xlsx: '#4CAF50',
            // Изображения
            jpg: '#FF5722',
            png: '#03A9F4',
            gif: '#E91E63',
            // Аудио
            mp3: '#9C27B0',
            wav: '#673AB7',
            // Видео
            mp4: '#FF5722',
            avi: '#795548',
            // Код
            js: '#FFC107',
            html: '#E65100',
            // По умолчанию
            default: '#607D8B'
        };

        if (['zip', 'rar', '7z', 'tar', 'gz'].includes(ext)) return colors.zip;
        if (['pdf'].includes(ext)) return colors.pdf;
        if (['doc', 'docx', 'odt'].includes(ext)) return colors.doc;
        if (['xls', 'xlsx', 'ods'].includes(ext)) return colors.xls;
        if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg', 'webp'].includes(ext)) return colors.jpg;
        if (['mp3', 'wav', 'ogg', 'flac'].includes(ext)) return colors.mp3;
        if (['mp4', 'avi', 'mov', 'mkv', 'webm'].includes(ext)) return colors.mp4;
        if (['js', 'ts', 'json'].includes(ext)) return colors.js;
        if (['html', 'htm', 'css', 'xml'].includes(ext)) return colors.html;

        return colors.default;
    }
});








<#import "parts/main.ftlh" as c>
<@c.page>
    <#--
        Порядок вывода. Приёмы пищи и категории, которых здесь нет,
        выводятся следом в том порядке, в каком встретились в данных,
        поэтому новая категория не потеряется.
    -->
    <#assign mealOrder = ["Завтрак", "Обед", "Ужин"]>
    <#assign categoryOrder = [
        "Салаты/Холодные закуски",
        "Первые блюда",
        "Вторые блюда",
        "Гарнир",
        "Основные блюда",
        "Выпечка",
        "Напитки",
        "Дополнительные блюда",
        "Доп. Ингредиент"
    ]>
    <#assign categoryTitles = {
        "Салаты/Холодные закуски": "Салаты и холодные закуски",
        "Гарнир": "Гарниры",
        "Доп. Ингредиент": "Дополнительные ингредиенты"
    }>

    <#-- Упорядоченный список значений поля: сначала известные, потом новые из данных -->
    <#function ordered items field preferred>
        <#local found = []>
        <#list items as item>
            <#local value = item[field]!"">
            <#if value?has_content && !found?seq_contains(value)>
                <#local found = found + [value]>
            </#if>
        </#list>
        <#local result = []>
        <#list preferred as value>
            <#if found?seq_contains(value)>
                <#local result = result + [value]>
            </#if>
        </#list>
        <#list found as value>
            <#if !preferred?seq_contains(value)>
                <#local result = result + [value]>
            </#if>
        </#list>
        <#return result>
    </#function>

    <#macro dish item>
        <div class="pb-dish">
            <span class="pb-dish-name">${item.title}</span>
            <#if (item.quantity)?? && item.quantity?has_content>
                <span class="pb-dish-weight">${item.quantity}</span>
            </#if>
            <span class="pb-dish-price">
                <#if (item.price)?? && item.price?is_number>${item.price?string("0.##")}<#else>${item.price!"—"}</#if> ₽
            </span>
        </div>
    </#macro>

    <section class="u-clearfix u-section-1">
        <div class="u-clearfix u-sheet u-sheet-1">
            <div class="pb-wrap">

                <div class="pb-menu-head">
                    <div>
                        <h2 style="margin:0">Меню столовой</h2>
                        <div class="pb-menu-date">на ${.now?string('dd.MM.yyyy')}</div>
                    </div>

                    <button type="button" class="pb-cam-btn" id="camBtn">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <path d="M23 7l-7 5 7 5z"/>
                            <rect x="1" y="5" width="15" height="14" rx="2" ry="2"/>
                        </svg>
                        <span>Загруженность столовой</span>
                    </button>
                </div>

                <#if menuItems?? && menuItems?has_content>
                    <#assign meals = ordered(menuItems, "view", mealOrder)>

                    <div class="pb-menu-grid">
                        <#list meals as meal>
                            <#assign mealItems = []>
                            <#list menuItems as item>
                                <#if (item.view!"") == meal>
                                    <#assign mealItems = mealItems + [item]>
                                </#if>
                            </#list>

                            <div class="pb-meal">
                                <h3 class="pb-meal-title">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                        <path d="M4 3v8a3 3 0 0 0 6 0V3M7 11v10"/>
                                        <path d="M17 3c-1.5 2-2 4-2 6s.5 3 2 3 2-1 2-3-.5-4-2-6zM17 12v9"/>
                                    </svg>
                                    ${meal}
                                </h3>

                                <#assign categories = ordered(mealItems, "category", categoryOrder)>
                                <#list categories as category>
                                    <div class="pb-cat">
                                        <h4 class="pb-cat-title">${categoryTitles[category]!category}</h4>
                                        <div class="pb-dishes">
                                            <#list mealItems as item>
                                                <#if (item.category!"") == category>
                                                    <@dish item=item/>
                                                </#if>
                                            </#list>
                                        </div>
                                    </div>
                                </#list>
                            </div>
                        </#list>
                    </div>
                <#else>
                    <div class="pb-table-card">
                        <div class="pb-empty" style="display:flex">
                            <p>Меню на сегодня пока не опубликовано</p>
                            <span>Загляните позже или уточните в столовой</span>
                        </div>
                    </div>
                </#if>

            </div>
        </div>
    </section>

    <#-- Модальное окно с трансляцией -->
    <div id="trafficModal" class="pb-modal" role="dialog" aria-modal="true" aria-labelledby="trafficModalTitle">
        <div class="pb-modal-box">
            <button type="button" class="pb-modal-close" id="modalCloseBtn" aria-label="Закрыть">&times;</button>
            <h3 class="pb-modal-title" id="trafficModalTitle">Текущая загруженность столовой</h3>
            <div class="pb-stream">
                <img id="stream" alt="Трансляция из зала столовой">
            </div>
        </div>
    </div>

    <script>
        (function () {
            const STREAM_URL = 'diningroom/live.mjpeg';
            const BLANK = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';

            const modal = document.getElementById('trafficModal');
            const streamElement = document.getElementById('stream');
            const camBtn = document.getElementById('camBtn');
            const closeBtn = document.getElementById('modalCloseBtn');
            if (!modal || !streamElement || !camBtn) return;

            let streaming = false;

            function openModal() {
                modal.classList.add('is-open');
                document.body.style.overflow = 'hidden';
                streamElement.src = STREAM_URL + '?t=' + Date.now();
                streaming = true;
                closeBtn.focus();
            }

            function stopStream() {
                if (!streaming) return;
                streaming = false;
                streamElement.src = BLANK;

                fetch('diningroom/stopAllStreams', {method: 'GET', keepalive: true})
                    .catch(function (err) {
                        console.error('Не удалось остановить поток на сервере:', err);
                    });
            }

            function closeModal() {
                if (!modal.classList.contains('is-open')) return;
                modal.classList.remove('is-open');
                document.body.style.overflow = '';
                stopStream();
                camBtn.focus();
            }

            camBtn.addEventListener('click', openModal);
            closeBtn.addEventListener('click', closeModal);

            modal.addEventListener('click', function (event) {
                if (event.target === modal) closeModal();
            });

            document.addEventListener('keydown', function (event) {
                if (event.key === 'Escape') closeModal();
            });

            streamElement.addEventListener('error', function () {
                if (streaming) {
                    console.log('Обрыв трансляции, останавливаем');
                    stopStream();
                }
            });

            document.addEventListener('visibilitychange', function () {
                if (document.hidden) stopStream();
            });

            window.addEventListener('pagehide', stopStream);
        })();
    </script>
</@c.page>

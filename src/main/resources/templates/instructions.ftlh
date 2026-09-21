<#import "parts/main.ftlh" as c>
<@c.page>
    <section class="u-clearfix u-section-1">
        <div class="u-clearfix u-sheet u-sheet-1">
            <h2 align="center">Инструкции по работе в информационной системе</h2>

            <div class="pb-wrap">
                <p class="pb-section-sub">Нажмите на строку, чтобы открыть инструкцию</p>

                <#if docs?? && docs?has_content>
                    <div class="pb-toolbar">
                        <div class="pb-search">
                            <svg class="pb-search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="2"/>
                                <path d="M21 21l-4.3-4.3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                            <input type="text" id="instr-search-input" autocomplete="off"
                                   placeholder="Поиск по названию инструкции...">
                            <button type="button" id="instr-search-clear" class="pb-search-clear" aria-label="Очистить поиск">&times;</button>
                        </div>
                        <div class="pb-count" id="instr-count"></div>
                    </div>

                    <div class="pb-table-card">
                        <table class="pb-table pb-table-docs" id="addr-table">
                            <thead>
                            <tr>
                                <th>Наименование документа</th>
                                <th class="pb-col-go"></th>
                            </tr>
                            </thead>
                            <tbody>
                            <#list docs as doc>
                                <tr class="pb-row" data-href="tech/${doc}" data-search="${doc?lower_case}">
                                    <td class="pb-col-doc">
                                        <div class="pb-doc-name">
                                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                                                <polyline points="14 2 14 8 20 8"/>
                                                <line x1="8" y1="13" x2="16" y2="13"/>
                                                <line x1="8" y1="17" x2="14" y2="17"/>
                                            </svg>
                                            <span>${doc}</span>
                                        </div>
                                    </td>
                                    <td class="pb-col-go">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                            <path d="M9 18l6-6-6-6"/>
                                        </svg>
                                    </td>
                                </tr>
                            </#list>
                            </tbody>
                        </table>
                        <div class="pb-empty" id="instr-empty" style="display:none">
                            <p>Ничего не найдено</p>
                            <span>Попробуйте изменить запрос</span>
                        </div>
                    </div>
                <#else>
                    <div class="pb-table-card">
                        <div class="pb-empty" style="display:flex">
                            <p>Инструкций пока нет</p>
                            <span>Они появятся здесь, как только их добавят</span>
                        </div>
                    </div>
                </#if>
            </div>
        </div>
    </section>

    <script>
        (function () {
            const table = document.getElementById('addr-table');
            if (!table) return;

            const rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr.pb-row'));
            const input = document.getElementById('instr-search-input');
            const clearBtn = document.getElementById('instr-search-clear');
            const emptyEl = document.getElementById('instr-empty');
            const countEl = document.getElementById('instr-count');

            rows.forEach(function (row) {
                row.addEventListener('click', function () {
                    const href = row.dataset.href;
                    if (href) window.location = href;
                });
            });

            function apply() {
                const q = input.value.trim().toLowerCase();
                let visible = 0;
                rows.forEach(function (row) {
                    const show = !q || row.dataset.search.indexOf(q) !== -1;
                    row.style.display = show ? '' : 'none';
                    if (show) visible++;
                });
                emptyEl.style.display = visible === 0 ? 'flex' : 'none';
                table.style.display = visible === 0 ? 'none' : '';
                countEl.textContent = visible + ' из ' + rows.length + ' инструкций';
                clearBtn.style.display = q ? 'flex' : 'none';
            }

            input.addEventListener('input', apply);
            clearBtn.addEventListener('click', function () {
                input.value = '';
                input.focus();
                apply();
            });

            apply();
        })();
    </script>
</@c.page>

<#import "parts/main.ftlh" as c>
<@c.page>
    <section class="u-clearfix u-section-1" id="sec-15f9">
        <div class="u-clearfix u-sheet u-sheet-1">
            <div class="custom-expanded u-tab-links-align-center u-tabs u-tabs-1">
                <ul class="u-tab-list u-unstyled" role="tablist">
                    <li class="u-tab-item" role="presentation">
                        <a class="active u-button-style u-tab-link u-tab-link-1" id="link-tab-877b" href="#tab-877b"
                           role="tab" aria-controls="tab-877b" aria-selected="true">Отсутствующие руководители</a>
                    </li>
                    <li class="u-tab-item" role="presentation">
                        <a class="u-button-style u-tab-link u-tab-link-2" id="link-tab-25ac" href="#tab-25ac"
                           role="tab" aria-controls="tab-25ac" aria-selected="false">Отсутствующие сотрудники</a>
                    </li>
                </ul>
                <div class="u-tab-content">

                    <#-- ================= Руководители ================= -->
                    <div class="u-container-style u-tab-active u-tab-pane" id="tab-877b" role="tabpanel"
                         aria-labelledby="link-tab-877b">
                        <div class="u-container-layout u-container-layout-6">
                            <h2 align="center">Отсутствующие руководители</h2>

                            <div class="pb-wrap">
                                <#if managers?? && managers?has_content>
                                    <div class="pb-toolbar">
                                        <div class="pb-search">
                                            <svg class="pb-search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="2"/>
                                                <path d="M21 21l-4.3-4.3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                            </svg>
                                            <input type="text" id="mgr-search-input" autocomplete="off"
                                                   placeholder="Поиск по ФИО, должности, подразделению, причине...">
                                            <button type="button" id="mgr-search-clear" class="pb-search-clear" aria-label="Очистить поиск">&times;</button>
                                        </div>
                                        <div class="pb-count" id="mgr-count"></div>
                                    </div>

                                    <div class="pb-table-card">
                                        <table class="pb-table pb-table-absent" id="mgr-table">
                                            <thead>
                                            <tr>
                                                <th class="pb-col-photo"></th>
                                                <th>ФИО сотрудника</th>
                                                <th class="pb-col-position">Должность</th>
                                                <th class="pb-col-dept">Подразделение</th>
                                                <th class="pb-col-cause">Причина отсутствия</th>
                                                <th class="pb-col-lack">Отсутствует по</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <#list managers as manager>
                                                <tr href="${manager.id}" class="pb-row lightview" data-lightview-type="iframe"
                                                    data-lightview-options="skin:'light'"
                                                    data-search="${(manager.name!'')?lower_case} ${(manager.position!'')?lower_case} ${(manager.department!'')?lower_case} ${(manager.cause!'')?lower_case} ${(manager.lack!'')?lower_case}">
                                                    <td class="pb-col-photo">
                                                        <span class="pb-avatar">
                                                            <img src="data:image/png;base64,${manager.photo!''}" width="48" height="48" loading="lazy" alt=""
                                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                            <span class="pb-avatar-fallback" style="display:none">${(manager.name!'?')?substring(0,1)}</span>
                                                        </span>
                                                    </td>
                                                    <td class="pb-col-name">
                                                        <div class="pb-name">${manager.name}</div>
                                                        <div class="pb-name-sub">${manager.position!''} · ${manager.department!''}</div>
                                                    </td>
                                                    <td class="pb-col-position">${manager.position!''}</td>
                                                    <td class="pb-col-dept">${manager.department!''}</td>
                                                    <td class="pb-col-cause"><span class="pb-cause">${manager.cause!''}</span></td>
                                                    <td class="pb-col-lack">${manager.lack!''}</td>
                                                </tr>
                                            </#list>
                                            </tbody>
                                        </table>
                                        <div class="pb-empty" id="mgr-empty" style="display:none">
                                            <p>Ничего не найдено</p>
                                            <span>Попробуйте изменить запрос</span>
                                        </div>
                                    </div>
                                <#else>
                                    <div class="pb-table-card">
                                        <div class="pb-empty" style="display:flex">
                                            <p>Никого не нашли</p>
                                            <span>Сейчас отсутствующих руководителей нет</span>
                                        </div>
                                    </div>
                                </#if>
                            </div>
                        </div>
                    </div>

                    <#-- ================= Сотрудники ================= -->
                    <div class="u-container-style u-tab-pane" id="tab-25ac" role="tabpanel"
                         aria-labelledby="link-tab-25ac">
                        <div class="u-container-layout u-container-layout-6">
                            <h2 align="center">Отсутствующие сотрудники</h2>

                            <div class="pb-wrap">
                                <#if employees?? && employees?has_content>
                                    <div class="pb-toolbar">
                                        <div class="pb-search">
                                            <svg class="pb-search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="2"/>
                                                <path d="M21 21l-4.3-4.3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                            </svg>
                                            <input type="text" id="emp-search-input" autocomplete="off"
                                                   placeholder="Поиск по ФИО, должности, подразделению, причине...">
                                            <button type="button" id="emp-search-clear" class="pb-search-clear" aria-label="Очистить поиск">&times;</button>
                                        </div>
                                        <div class="pb-count" id="emp-count"></div>
                                    </div>

                                    <div class="pb-table-card">
                                        <table class="pb-table pb-table-absent" id="emp-table">
                                            <thead>
                                            <tr>
                                                <th class="pb-col-photo"></th>
                                                <th>ФИО сотрудника</th>
                                                <th class="pb-col-position">Должность</th>
                                                <th class="pb-col-dept">Подразделение</th>
                                                <th class="pb-col-cause">Причина отсутствия</th>
                                                <th class="pb-col-lack">Отсутствует по</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <#list employees as emp>
                                                <tr href="${emp.id}" class="pb-row lightview" data-lightview-type="iframe"
                                                    data-lightview-options="skin:'light'"
                                                    data-search="${(emp.name!'')?lower_case} ${(emp.position!'')?lower_case} ${(emp.department!'')?lower_case} ${(emp.cause!'')?lower_case} ${(emp.lack!'')?lower_case}">
                                                    <td class="pb-col-photo">
                                                        <span class="pb-avatar">
                                                            <img src="data:image/png;base64,${emp.photo!''}" width="48" height="48" loading="lazy" alt=""
                                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                            <span class="pb-avatar-fallback" style="display:none">${(emp.name!'?')?substring(0,1)}</span>
                                                        </span>
                                                    </td>
                                                    <td class="pb-col-name">
                                                        <div class="pb-name">${emp.name}</div>
                                                        <div class="pb-name-sub">${emp.position!''} · ${emp.department!''}</div>
                                                    </td>
                                                    <td class="pb-col-position">${emp.position!''}</td>
                                                    <td class="pb-col-dept">${emp.department!''}</td>
                                                    <td class="pb-col-cause"><span class="pb-cause">${emp.cause!''}</span></td>
                                                    <td class="pb-col-lack">${emp.lack!''}</td>
                                                </tr>
                                            </#list>
                                            </tbody>
                                        </table>
                                        <div class="pb-empty" id="emp-empty" style="display:none">
                                            <p>Ничего не найдено</p>
                                            <span>Попробуйте изменить запрос</span>
                                        </div>
                                    </div>
                                <#else>
                                    <div class="pb-table-card">
                                        <div class="pb-empty" style="display:flex">
                                            <p>Никого не нашли</p>
                                            <span>Сейчас отсутствующих сотрудников нет</span>
                                        </div>
                                    </div>
                                </#if>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </section>

    <script>
        (function () {
            function initAbsentTable(prefix, noun) {
                const table = document.getElementById(prefix + '-table');
                if (!table) return;

                const rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr.pb-row'));
                const input = document.getElementById(prefix + '-search-input');
                const clearBtn = document.getElementById(prefix + '-search-clear');
                const emptyEl = document.getElementById(prefix + '-empty');
                const countEl = document.getElementById(prefix + '-count');

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
                    countEl.textContent = visible + ' из ' + rows.length + ' ' + noun;
                    clearBtn.style.display = q ? 'flex' : 'none';
                }

                input.addEventListener('input', apply);
                clearBtn.addEventListener('click', function () {
                    input.value = '';
                    input.focus();
                    apply();
                });

                apply();
            }

            initAbsentTable('mgr', 'руководителей');
            initAbsentTable('emp', 'сотрудников');
        })();
    </script>
</@c.page>

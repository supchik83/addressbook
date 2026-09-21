<#import "parts/main.ftlh" as c>
<@c.page>
    <section class="u-clearfix u-section-1" id="sec-15f9">
        <div class="u-clearfix u-sheet u-sheet-1">
            <div class="custom-expanded u-tab-links-align-center u-tabs u-tabs-1">
                <ul class="u-tab-list u-unstyled" role="tablist">
                    <li class="u-tab-item" role="presentation">
                        <a class="active u-button-style u-tab-link u-tab-link-1" id="link-tab-877b" href="#tab-877b"
                           role="tab" aria-controls="tab-877b" aria-selected="true">Дни рождения сегодня</a>
                    </li>
                    <li class="u-tab-item" role="presentation">
                        <a class="u-button-style u-tab-link u-tab-link-2" id="link-tab-25ac" href="#tab-25ac"
                           role="tab" aria-controls="tab-25ac" aria-selected="false">Дни рождения в этом месяце</a>
                    </li>
                </ul>
                <div class="u-tab-content">

                    <#-- ================= Сегодня ================= -->
                    <div class="u-container-style u-tab-active u-tab-pane" id="tab-877b" role="tabpanel"
                         aria-labelledby="link-tab-877b">
                        <div class="u-container-layout u-container-layout-1">
                            <h2 align="center">День рождения сегодня отмечают</h2>

                            <div class="pb-wrap">
                                <#if celebrants?? && celebrants?has_content>
                                    <p class="pb-section-sub">Поздравьте коллег — это займёт минуту</p>

                                    <div class="pb-people">
                                        <#list celebrants as celebrant>
                                            <div class="pb-person">
                                                <span class="pb-person-flag" aria-hidden="true">🎂</span>
                                                <span class="pb-person-avatar">
                                                    <img src="data:image/png;base64,${celebrant.photo!''}" width="96" height="96" loading="lazy" alt=""
                                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                    <span class="pb-avatar-fallback" style="display:none">${(celebrant.name!'?')?substring(0,1)}</span>
                                                </span>
                                                <div class="pb-person-name">${celebrant.name}</div>
                                                <div class="pb-person-position">${celebrant.position!''}</div>
                                                <div class="pb-person-dept">${celebrant.department!''}</div>
                                                <div class="pb-person-foot">
                                                    <a class="pb-btn" href="mailto:${celebrant.email!''}">Отправить поздравление</a>
                                                </div>
                                            </div>
                                        </#list>
                                    </div>
                                <#else>
                                    <div class="pb-table-card">
                                        <div class="pb-empty" style="display:flex">
                                            <p>Сегодня именинников нет</p>
                                            <span>Загляните на вкладку «Дни рождения в этом месяце»</span>
                                        </div>
                                    </div>
                                </#if>
                            </div>
                        </div>
                    </div>

                    <#-- ================= В этом месяце ================= -->
                    <div class="u-container-style u-tab-pane" id="tab-25ac" role="tabpanel"
                         aria-labelledby="link-tab-25ac">
                        <div class="u-container-layout u-container-layout-6">
                            <h2 align="center">Дни рождения в этом месяце</h2>

                            <div class="pb-wrap">
                                <#if celebrantsM?? && celebrantsM?has_content>
                                    <div class="pb-toolbar">
                                        <div class="pb-search">
                                            <svg class="pb-search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="2"/>
                                                <path d="M21 21l-4.3-4.3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                            </svg>
                                            <input type="text" id="bd-search-input" autocomplete="off"
                                                   placeholder="Поиск по ФИО, должности, отделу, дате...">
                                            <button type="button" id="bd-search-clear" class="pb-search-clear" aria-label="Очистить поиск">&times;</button>
                                        </div>
                                        <div class="pb-count" id="bd-count"></div>
                                    </div>

                                    <div class="pb-table-card">
                                        <table class="pb-table pb-table-bday" id="bd-table">
                                            <thead>
                                            <tr>
                                                <th class="pb-col-photo"></th>
                                                <th>ФИО сотрудника</th>
                                                <th class="pb-col-position">Должность</th>
                                                <th class="pb-col-dept">Отдел</th>
                                                <th class="pb-col-date">Дата рождения</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <#list celebrantsM as celebrantM>
                                                <tr href="${celebrantM.id}" class="pb-row lightview" data-lightview-type="iframe"
                                                    data-lightview-options="skin:'light'"
                                                    data-search="${(celebrantM.name!'')?lower_case} ${(celebrantM.position!'')?lower_case} ${(celebrantM.department!'')?lower_case} ${(celebrantM.birthday!'')?lower_case}">
                                                    <td class="pb-col-photo">
                                                        <span class="pb-avatar">
                                                            <img src="data:image/png;base64,${celebrantM.photo!''}" width="48" height="48" loading="lazy" alt=""
                                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                            <span class="pb-avatar-fallback" style="display:none">${(celebrantM.name!'?')?substring(0,1)}</span>
                                                        </span>
                                                    </td>
                                                    <td class="pb-col-name">
                                                        <div class="pb-name">${celebrantM.name}</div>
                                                        <div class="pb-name-sub">${celebrantM.position!''} · ${celebrantM.department!''}</div>
                                                    </td>
                                                    <td class="pb-col-position">${celebrantM.position!''}</td>
                                                    <td class="pb-col-dept">${celebrantM.department!''}</td>
                                                    <td class="pb-col-date">${celebrantM.birthday!''}</td>
                                                </tr>
                                            </#list>
                                            </tbody>
                                        </table>
                                        <div class="pb-empty" id="bd-empty" style="display:none">
                                            <p>Ничего не найдено</p>
                                            <span>Попробуйте изменить запрос</span>
                                        </div>
                                    </div>
                                <#else>
                                    <div class="pb-table-card">
                                        <div class="pb-empty" style="display:flex">
                                            <p>Никого не нашли</p>
                                            <span>В этом месяце дней рождения нет</span>
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
            const table = document.getElementById('bd-table');
            if (!table) return;

            const rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr.pb-row'));
            const input = document.getElementById('bd-search-input');
            const clearBtn = document.getElementById('bd-search-clear');
            const emptyEl = document.getElementById('bd-empty');
            const countEl = document.getElementById('bd-count');

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
                countEl.textContent = visible + ' из ' + rows.length + ' именинников';
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

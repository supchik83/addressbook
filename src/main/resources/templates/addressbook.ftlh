<#import "parts/main.ftlh" as c>
<@c.page>
    <h2 align="center">Телефонный справочник</h2>

    <div class="loading-screen" id="loadingScreen">
        <h2>Загрузка...</h2>
        <div class="progress-container">
            <div class="progress-bar" id="progressBar"></div>
        </div>
        <div class="loading-percentage" id="loadingPercentage">0%</div>
    </div>

    <div class="pb-wrap">

        <div class="pb-toolbar">
            <div class="pb-search">
                <svg class="pb-search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="2"/>
                    <path d="M21 21l-4.3-4.3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                </svg>
                <input type="text" id="pb-search-input" autocomplete="off" placeholder="Поиск по ФИО, отделу, должности, телефону...">
                <button type="button" id="pb-search-clear" class="pb-search-clear" aria-label="Очистить поиск">&times;</button>
            </div>
            <div class="pb-count" id="pb-count"></div>
        </div>

<#--        <div class="pb-filters" id="pb-filters"></div>-->

        <div class="pb-table-card">
            <table class="pb-table" id="addr-table">
                <thead>
                <tr>
                    <th class="pb-col-photo"></th>
                    <th>ФИО сотрудника</th>
                    <th class="pb-col-phone">Телефон</th>
                    <th class="pb-col-email">E-mail</th>
                    <th class="pb-col-position">Должность</th>
                    <th class="pb-col-dept">Отдел</th>
                    <th class="pb-col-office">Кабинет</th>
                </tr>
                </thead>
                <tbody>
                <#list employees as employee>
                    <tr href="${employee.id}" class="pb-row lightview" data-lightview-type="iframe" data-lightview-options="skin:'light'"
                        data-department="${employee.department}"
                        data-search="${(employee.name!'')?lower_case} ${(employee.position!'')?lower_case} ${(employee.department!'')?lower_case} ${(employee.office!'')?lower_case} ${employee.innerPhone!''} ${(employee.email!'')?lower_case}">
                        <td class="pb-col-photo">
                            <span class="pb-avatar">
                                <img src="/photo/${employee.id}" width="48" height="48" loading="lazy" alt=""
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                <span class="pb-avatar-fallback" style="display:none">${(employee.name!'?')?substring(0,1)}</span>
                            </span>
                        </td>
                        <td class="pb-col-name">
                            <div class="pb-name">${employee.name}</div>
                            <div class="pb-name-sub">${employee.position} · ${employee.department}</div>
                        </td>
                        <td class="pb-col-phone">
                            <a class="pb-phone" href="tel:${employee.innerPhone}" onclick="event.stopPropagation()">${employee.innerPhone}</a>
                        </td>
                        <td class="pb-col-email">
                            <a class="pb-email" href="mailto:${employee.email}" onclick="event.stopPropagation()">${employee.email}</a>
                        </td>
                        <td class="pb-col-position">${employee.position}</td>
                        <td class="pb-col-dept"><span class="pb-badge">${employee.department}</span></td>
                        <td class="pb-col-office">${employee.office}</td>
                    </tr>
                </#list>
                </tbody>
            </table>
            <div class="pb-empty" id="pb-empty" style="display:none">
                <p>Ничего не найдено</p>
                <span>Попробуйте изменить запрос или сбросить фильтр отдела</span>
            </div>
        </div>
    </div>

    <script>
        (function () {
            const table = document.getElementById('addr-table');
            if (!table) return;

            const rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr.pb-row'));
            const input = document.getElementById('pb-search-input');
            const clearBtn = document.getElementById('pb-search-clear');
            const emptyEl = document.getElementById('pb-empty');
            const countEl = document.getElementById('pb-count');
            const filtersEl = document.getElementById('pb-filters');

            let activeDept = null;

            // Фильтр-чипы по отделам строим только если блок есть в разметке
            if (filtersEl) {
                const depts = Array.from(new Set(rows.map(function (r) { return r.dataset.department; })
                    .filter(Boolean))).sort(function (a, b) { return a.localeCompare(b, 'ru'); });

                function makeChip(label, dept) {
                    const chip = document.createElement('button');
                    chip.type = 'button';
                    chip.className = 'pb-chip';
                    chip.textContent = label;
                    chip.dataset.dept = dept === null ? '' : dept;
                    chip.addEventListener('click', function () {
                        activeDept = (activeDept === dept) ? null : dept;
                        Array.prototype.forEach.call(filtersEl.querySelectorAll('.pb-chip'), function (c) {
                            c.classList.toggle('pb-chip-active', c.dataset.dept === (activeDept || ''));
                        });
                        apply();
                    });
                    return chip;
                }

                filtersEl.appendChild(makeChip('Все отделы', null));
                depts.forEach(function (d) { filtersEl.appendChild(makeChip(d, d)); });
                filtersEl.querySelector('.pb-chip').classList.add('pb-chip-active');
            }

            function apply() {
                const q = input.value.trim().toLowerCase();
                let visible = 0;
                rows.forEach(function (row) {
                    const matchesQuery = !q || row.dataset.search.indexOf(q) !== -1;
                    const matchesDept = !activeDept || row.dataset.department === activeDept;
                    const show = matchesQuery && matchesDept;
                    row.style.display = show ? '' : 'none';
                    if (show) visible++;
                });
                emptyEl.style.display = visible === 0 ? 'flex' : 'none';
                table.style.display = visible === 0 ? 'none' : '';
                countEl.textContent = visible + ' из ' + rows.length + ' сотрудников';
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

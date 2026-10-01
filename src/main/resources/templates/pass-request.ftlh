<#-- Путь импорта поправьте так же, как в ваших остальных шаблонах (например "parts/main.ftlh") -->
<#import "parts/main.ftlh" as m>

<#-- Сообщение об ошибке под полем. path — путь поля, например visitors[0].fullName -->
<#macro err path>
    <#if errors[path]??><div class="pr-error">${errors[path]}</div></#if>
</#macro>

<#-- Карточка посетителя. i — индекс (строкой), v — данные формы или {} для пустой карточки-шаблона -->
<#macro visitorRow i v>
    <#local p = "visitors[" + i + "]">
    <#local byCar = v.byCar!false>
    <div class="pr-row" data-kind="visitors">
        <div class="pr-row-head">
            <span class="pr-row-title">Посетитель <span class="pr-row-num"></span></span>
            <button type="button" class="pr-remove" data-remove title="Удалить посетителя" aria-label="Удалить посетителя">&times;</button>
        </div>
        <div class="pr-grid">
            <label class="pr-field pr-span-2">
                <span>ФИО</span>
                <input type="text" name="visitors[${i}].fullName" value="${v.fullName!''}"
                       maxlength="150" required autocomplete="off" placeholder="Иванов Иван Иванович">
                <@err p + ".fullName"/>
            </label>
            <label class="pr-field pr-span-2">
                <span>Цель посещения</span>
                <input type="text" name="visitors[${i}].purpose" value="${v.purpose!''}"
                       maxlength="300" required autocomplete="off" placeholder="Например: совещание">
                <@err p + ".purpose"/>
            </label>
            <label class="pr-field">
                <span>Прибытие</span>
                <input type="datetime-local" name="visitors[${i}].arrivalAt" value="${v.arrivalInput!''}"
                       data-role="arrival" required>
                <@err p + ".arrivalAt"/>
                <@err p + ".arrivalNotInPast"/>
            </label>
            <label class="pr-field">
                <span>Убытие</span>
                <input type="datetime-local" name="visitors[${i}].departureAt" value="${v.departureInput!''}"
                       data-role="departure" required>
                <@err p + ".departureAt"/>
                <@err p + ".periodValid"/>
            </label>

            <fieldset class="pr-mode pr-span-2">
                <legend>Как прибудет</legend>
                <div class="pr-seg">
                    <label>
                        <input type="radio" name="visitors[${i}].travelMode" value="ON_FOOT" <#if !byCar>checked</#if>>
                        <span>Пешком</span>
                    </label>
                    <label>
                        <input type="radio" name="visitors[${i}].travelMode" value="BY_CAR" <#if byCar>checked</#if>>
                        <span>На автомобиле</span>
                    </label>
                </div>
            </fieldset>
        </div>

        <#-- Поля автомобиля: видны только при «На автомобиле». Скрытые поля отключаются и не отправляются -->
        <div class="pr-car" <#if !byCar>hidden</#if>>
            <div class="pr-car-hint">Укажите марку и госномер автотранспортного средства.</div>
            <div class="pr-grid">
                <label class="pr-field">
                    <span>Марка автомобиля</span>
                    <input type="text" name="visitors[${i}].carBrand" value="${v.carBrand!''}"
                           maxlength="100" autocomplete="off" placeholder="Toyota Camry"
                           <#if byCar>required<#else>disabled</#if>>
                    <@err p + ".carBrandFilled"/>
                    <@err p + ".carBrand"/>
                </label>
                <label class="pr-field">
                    <span>Госномер</span>
                    <input type="text" class="js-plate pr-plate" name="visitors[${i}].carPlate" value="${v.carPlate!''}"
                           maxlength="10" autocomplete="off" spellcheck="false" autocapitalize="characters"
                           placeholder="Е123ВХ 977"
                           pattern="[АВЕКМНОРСТУХ]\d{3}[АВЕКМНОРСТУХ]{2} \d{2,3}"
                           title="Формат: Е123ВХ 977 или Е123ВХ 77 — буквы А В Е К М Н О Р С Т У Х, регион 2 или 3 цифры"
                           <#if byCar>required<#else>disabled</#if>>
                    <@err p + ".carPlateFilled"/>
                    <@err p + ".carPlateFormatValid"/>
                </label>
            </div>
        </div>
    </div>
</#macro>

<@m.page>
    <link rel="stylesheet" href="/css/pass-request.css">

    <div class="pb-wrap pr-wrap">
        <h2 align="center">Заказ временного пропуска</h2>
        <div class="pb-section-sub">Все поля обязательны. Заявка уходит по электронной почте в бюро пропусков.</div>

        <#if success??>
            <div class="pr-alert pr-alert-ok" role="status">${success}</div>
        </#if>
        <#if errors["_global"]??>
            <div class="pr-alert pr-alert-err" role="alert">${errors["_global"]}</div>
        </#if>
        <div class="pr-alert pr-alert-err" id="pr-none" role="alert" hidden>Добавьте хотя бы одного посетителя.</div>

        <form method="post" action="/pass-request" id="passForm">
            <#-- CSRF-токен: нужен, если на портале включён Spring Security с CSRF -->
            <#if _csrf??><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"></#if>

            <section class="pr-card">
                <div class="pr-card-head">
                    <div>
                        <h2 class="pr-card-title">Заявитель</h2>
                        <div class="pr-card-hint">Кто заказывает пропуск. Ответ придёт на этот адрес.</div>
                    </div>
                </div>
                <div class="pr-grid">
                    <label class="pr-field">
                        <span>ФИО заявителя</span>
                        <input type="text" name="requesterName" value="${form.requesterName!''}"
                               maxlength="150" required autocomplete="name" placeholder="Петров Пётр Петрович">
                        <@err "requesterName"/>
                    </label>
                    <label class="pr-field">
                        <span>Электронная почта</span>
                        <input type="email" name="requesterEmail" value="${form.requesterEmail!''}"
                               maxlength="254" required autocomplete="email" placeholder="username@gmtmsk.ru">
                        <@err "requesterEmail"/>
                    </label>
                </div>
            </section>

            <section class="pr-card">
                <div class="pr-card-head">
                    <div>
                        <h2 class="pr-card-title">Посетители</h2>
                        <div class="pr-card-hint">Для каждого человека — своя карточка. Если посетитель приедет на автомобиле, выберите «На автомобиле» и укажите марку и госномер.</div>
                    </div>
                    <button type="button" class="pr-add" data-add>+ Добавить посетителя</button>
                </div>
                <@err "visitors"/>
                <div class="pr-list" id="visitors-list">
                    <#list form.visitors as v>
                        <@visitorRow i=v?index?c v=v/>
                    </#list>
                </div>
                <div class="pr-empty" id="visitors-empty" hidden>Посетители не добавлены</div>
            </section>

            <div class="pr-actions">
                <button type="submit" class="pr-submit">Отправить заявку</button>
            </div>
        </form>

        <#-- ============================================================================
             НА ВЫРОСТ: «Мои заявки»
             Включить вместе с хранением заявок в БД (см. шапку PassRequest.java):
             раскомментировать этот блок и строку model.addAttribute("myRequests", ...)
             в PassRequestController#form.
             Внутри этого комментария нельзя использовать закрывающую последовательность
             комментария FreeMarker.

        <section class="pr-card">
            <div class="pr-card-head">
                <h2 class="pr-card-title">Мои заявки</h2>
            </div>
            <#if myRequests?? && myRequests?has_content>
                <div class="pb-table-card">
                    <table class="pb-table">
                        <thead>
                        <tr>
                            <th>Подана</th>
                            <th>Посетители</th>
                            <th>Статус</th>
                        </tr>
                        </thead>
                        <tbody>
                        <#list myRequests as r>
                            <tr>
                                <td>${r.createdAtText}</td>
                                <td>
                                    <#list r.visitors as v>
                                        ${v.fullName}<#if v.byCar> — ${v.carBrand} ${v.carPlate}</#if><#sep>, </#list>
                                </td>
                                <td><span class="pb-pill">${r.status.title}</span></td>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>
            <#else>
                <div class="pr-empty">Вы ещё не подавали заявок</div>
            </#if>
        </section>
        ============================================================================ -->
    </div>

    <script>
        (function () {
            var form = document.getElementById('passForm');
            var list = document.getElementById('visitors-list');
            var LETTERS = 'АВЕКМНОРСТУХ';
            var LATIN = 'ABEKMHOPCTYX';

            // Маска госномера: Е123ВХ 977 / Е123ВХ 77. Латиница заменяется похожей кириллицей.
            function maskPlate(raw) {
                var out = '';
                raw.toUpperCase().split('').forEach(function (ch) {
                    var li = LATIN.indexOf(ch);
                    if (li >= 0) { ch = LETTERS.charAt(li); }
                    var pos = out.length;
                    var isLetter = LETTERS.indexOf(ch) >= 0;
                    var isDigit = ch >= '0' && ch <= '9';
                    var letterSlot = (pos === 0 || pos === 4 || pos === 5);
                    var digitSlot = (pos >= 1 && pos <= 3) || (pos >= 6 && pos <= 8);
                    if ((letterSlot && isLetter) || (digitSlot && isDigit)) { out += ch; }
                });
                return out.length > 6 ? out.slice(0, 6) + ' ' + out.slice(6) : out;
            }

            function pad(n) { return (n < 10 ? '0' : '') + n; }
            function todayStart() {
                var d = new Date();
                return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) + 'T00:00';
            }

            function rows() { return list.querySelectorAll('.pr-row'); }

            // Ограничения дат: прибытие — не раньше сегодня, убытие — не раньше прибытия
            function applyDateLimits() {
                var min = todayStart();
                rows().forEach(function (row) {
                    var arrival = row.querySelector('[data-role="arrival"]');
                    var departure = row.querySelector('[data-role="departure"]');
                    arrival.min = min;
                    departure.min = arrival.value || min;
                });
            }

            // «На автомобиле»: показываем поля авто и делаем их обязательными.
            // «Пешком»: прячем и отключаем — отключённые поля не уходят на сервер.
            function syncCar(row) {
                var byCar = row.querySelector('input[type="radio"][value="BY_CAR"]').checked;
                var box = row.querySelector('.pr-car');
                box.hidden = !byCar;
                box.querySelectorAll('input').forEach(function (input) {
                    input.disabled = !byCar;
                    input.required = byCar;
                });
            }

            // Перенумеровывает карточки, чтобы индексы в name шли подряд (Spring связывает списки по индексу)
            function refresh() {
                var all = rows();
                all.forEach(function (row, i) {
                    row.querySelectorAll('[name]').forEach(function (el) {
                        el.name = el.name.replace(/^visitors\[[^\]]*\]/, 'visitors[' + i + ']');
                    });
                    row.querySelector('.pr-row-num').textContent = all.length > 1 ? (i + 1) : '';
                    syncCar(row);
                });
                document.getElementById('visitors-empty').hidden = all.length > 0;
                applyDateLimits();
            }

            function addRow() {
                list.insertAdjacentHTML('beforeend', document.getElementById('visitor-tpl').innerHTML);
                refresh();
                var input = list.lastElementChild.querySelector('input');
                if (input) { input.focus(); }
                document.getElementById('pr-none').hidden = true;
            }

            document.addEventListener('click', function (e) {
                if (e.target.closest('[data-add]')) { addRow(); return; }
                var rm = e.target.closest('[data-remove]');
                if (rm) {
                    rm.closest('.pr-row').remove();
                    refresh();
                }
            });

            form.addEventListener('input', function (e) {
                var el = e.target;
                if (el.classList.contains('js-plate')) {
                    var masked = maskPlate(el.value);
                    if (masked !== el.value) { el.value = masked; }
                }
                if (el.getAttribute('data-role') === 'arrival') { applyDateLimits(); }
            });

            form.addEventListener('change', function (e) {
                if (e.target.type === 'radio') { syncCar(e.target.closest('.pr-row')); }
            });

            form.addEventListener('submit', function (e) {
                if (rows().length === 0) {
                    e.preventDefault();
                    document.getElementById('pr-none').hidden = false;
                }
            });

            refresh();
        })();
    </script>

    <#-- Пустая карточка для кнопки «Добавить посетителя» -->
    <template id="visitor-tpl"><@visitorRow i="__I__" v={}/></template>
</@m.page>

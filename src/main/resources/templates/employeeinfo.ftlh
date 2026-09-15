<!DOCTYPE html>
<html style="font-size: 16px;" lang="ru">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="utf-8">
    <link rel="stylesheet" href="/css/nicepage.css" media="screen">
    <link rel="stylesheet" href="/css/main.css" media="screen">
    <link rel="stylesheet" href="/css/employeeinfo.css" media="screen">
    <style>
        /* Стили для фиксированной шапки таблицы */
        .table-container {
            max-height: 400px;
            overflow-y: auto;
            /* Убираем границу контейнера */
            border: none;
            margin-top: 20px;
            /* Скрываем скроллбар */
            scrollbar-width: none; /* Для Firefox */
            -ms-overflow-style: none; /* Для IE и Edge */
        }

        /* Скрываем скроллбар для Webkit браузеров (Chrome, Safari) */
        .table-container::-webkit-scrollbar {
            display: none;
            width: 0;
            height: 0;
        }

        .fixed-header-table {
            width: 100%;
            border-collapse: collapse;
            /* Убираем внешние границы таблицы */
            border: none;
        }

        .fixed-header-table thead {
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .fixed-header-table th {
            background-color: #dce9f9;
            background-image: -webkit-gradient(linear, left top, left bottom, from(#d6ece7), to(#2cccc4));
            background-image: -webkit-linear-gradient(top, #d6ece7, #2cccc4);
            background-image: -moz-linear-gradient(top, #d6ece7, #2cccc4);
            background-image: -ms-linear-gradient(top, #d6ece7, #2cccc4);
            background-image: -o-linear-gradient(top, #d6ece7, #2cccc4);
            background-image: linear-gradient(to bottom, #d6ece7, #2cccc4);
            -webkit-box-shadow: 0 1px 0 rgba(255, 255, 255, .8) inset;
            -moz-box-shadow: 0 1px 0 rgba(255, 255, 255, .8) inset;
            box-shadow: 0 1px 0 rgba(255, 255, 255, .8) inset;
            border-top: none;
            text-shadow: 0 1px 0 rgba(255, 255, 255, .5);
            font-weight: bold;
            padding: 12px 8px;
            text-align: left;
            /* Убираем границы у заголовков */
            border: none;
            border-bottom: 2px solid #2cccc4;
            position: sticky;
            top: 0;
        }

        .fixed-header-table tbody tr {
            background-color: #f9f9f9;
        }

        .fixed-header-table tbody tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .fixed-header-table td {
            padding: 10px 8px;
            /* Убираем границы у ячеек */
            border: none;
            border-bottom: 1px solid #e0e0e0;
        }

        .fixed-header-table tbody tr:hover {
            background-color: #e9e9e9;
        }

        /* Убираем последнюю границу у последней строки */
        .fixed-header-table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Убедимся, что наши стили имеют приоритет */
        .table-container .fixed-header-table thead tr {
            height: 29px !important;
        }

        .table-container .fixed-header-table tbody tr {
            height: 44px !important;
        }
    </style>
</head>
<body class="u-body u-xl-mode">
<section class="u-clearfix u-section-1" id="sec-4d66">
    <div class="u-clearfix u-sheet u-valign-bottom u-sheet-1">
        <div class="data-layout-selected u-clearfix u-expanded-width u-gutter-0 u-layout-wrap u-layout-wrap-1">
            <div class="u-layout">
                <div class="u-layout-row">
                    <div class="u-container-style u-layout-cell u-size-17 u-layout-cell-1">
                        <div class="u-container-layout u-valign-bottom u-container-layout-1">
                            <img class="u-expanded-width u-image u-image-round u-radius u-image-1" src="data:image/png;base64,${user.photo}" alt="" data-image-width="400" data-image-height="265">
                        </div>
                    </div>
                    <div class="u-container-style u-layout-cell u-size-43 u-layout-cell-2">
                        <div class="u-container-layout u-valign-top u-container-layout-2">
                            <h4 class="u-text u-text-1 u-text-palette-4-base">${user.name}</h4>
                            <h4 class="u-text u-text-2">${user.position}</h4>
                            <h4 class="u-align-left u-text u-text-3">${user.department}</h4>
                            <div class="u-border-3 u-border-palette-4-dark-1 u-line u-line-horizontal u-line-1"></div>
                            <h4 class="u-align-left u-text u-text-4">Телефон: ${user.phone}</h4>
                            <h4 class="u-align-left u-text u-text-5">Внутренний телефон: ${user.innerPhone}</h4>
                            <h4 class="u-align-left u-text u-text-6">E-mail: <a href="mailto:${user.email}">${user.email}</a></h4>
                            <h4 class="u-align-left u-text u-text-7">Кабинет: ${user.office}</h4>
                            <h4 class="u-align-left u-text u-text-7">Работает в ГМТ с: ${user.receptionDate}</h4>
                            <div class="u-border-3 u-border-palette-4-dark-1 u-line u-line-horizontal u-line-1"></div>
                            <h4 class="u-align-left u-text u-text-4"> Руководитель: ${user.manager}</h4>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<section class="u-align-center u-clearfix u-section-2" id="sec-3997">
    <div class="u-clearfix u-sheet u-sheet-1">
        <#if workers?? && workers?has_content>
            <h5 class="u-align-left u-text u-text-1">Подчиненные:</h5>
            <div class="table-container">
                <table class="fixed-header-table">
                    <colgroup>
                        <col width="23.5%">
                        <col width="11.5%">
                        <col width="12.8%">
                        <col width="13%">
                        <col width="30.1%">
                        <col width="9.1%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>ФИО Сотрудника</th>
                        <th>Телефон</th>
                        <th>E-mail</th>
                        <th>Должность</th>
                        <th>Подразделение</th>
                        <th>Кабинет</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list workers as worker>
                        <tr>
                            <td>${worker.name}</td>
                            <td>${worker.innerPhone}</td>
                            <td><a href="mailto:${worker.email}">${worker.email}</a></td>
                            <td>${worker.position}</td>
                            <td>${worker.department}</td>
                            <td>${worker.office}</td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        <#else>
            <!-- Если подчиненных нет -->
        </#if>
    </div>
</section>
</body>
</html>
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

    <div class="container-fluid">
        <div class="row flex-xl-nowrap">
            <div class="col-10">
                <form class="form-inline my-2">
                    <div class="col-md-4">
                        <input type="text" id="search-emp" class="form-control col-md-3" onkeyup="tableSearch_emp()" placeholder="Поиск...">
                    </div>
                </form>
                <table class="bordered" xmlns="http://www.w3.org/1999/html" id="addr-table">
                    <thead>
                    <tr>
                        <th></th>
                        <th>ФИО сотрудника</th>
                        <th>Телефон</th>
                        <th>E-mail</th>
                        <th>Должность</th>
                        <th>Отдел</th>
                        <th>Кабинет</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list employees as employee>
                        <tr href = "${employee.id}" class="lightview" data-lightview-type="iframe" data-lightview-options="skin:'light'">
                            <td><img src="/photo/${employee.id}" width="65" height="65" loading="lazy"></td>
                            <td width="400">${employee.name}</td>
                            <td>${employee.innerPhone}</td>
                            <td><a href="mailto:${employee.email}"> ${employee.email}</a></td>
                            <td>${employee.position}</td>
                            <td>${employee.department}</td>
                            <td>${employee.office}</td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</@c.page>

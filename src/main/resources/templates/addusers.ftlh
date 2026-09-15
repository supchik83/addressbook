<#import "parts/main.ftlh" as c>
<@c.page>
    <br>
    <h3 align="center">Сервис по добавлению новых пользователей в Active Directory</h3>
    <section class="u-clearfix u-section-1" id="sec-15f9">
        <div class="u-clearfix u-sheet u-sheet-1">
            <div class="custom-expanded u-tab-links-align-center u-tabs u-tabs-1">
                <div class="u-tab-content">
                    <div class="u-container-layout u-container-layout-1">
                        <div class="u-expanded-width u-list u-list-1">
                            <div class="u-repeater u-repeater-1">
                                <form method="post" action="/upload" enctype="multipart/form-data">
                                    <div class="input-group">
                                        <input type="file" name="uploadedFile" class="form-control" id="inputGroupFile04" aria-describedby="inputGroupFileAddon04" aria-label="Upload">
                                        <button class="btn btn-outline-secondary" type="submit" id="inputGroupFileAddon04">Получить данные</button>
                                    </div>
                                </form>
                                <div class="container">
                                    <#--                            -->
                                    <br>
                                    <form method="post" action="/save" class="row g-3">
                                        <#if employees?? && employees?has_content>
                                            <#list employees as key, value>
                                                <div class="u-border-3 u-border-palette-4-dark-3 u-line u-line-horizontal u-line-1"></div>
                                                <div class="col-md-8">
                                                    <label for="name" class="form-label">ФИО пользователя:</label>
                                                    <input type="text" name="name" class="form-control" id="name" value="${key.name}" required>
                                                </div>
                                                <div class="col-md-4">
                                                    <label for="tabNumber" class="form-label">Табельный номер:</label>
                                                    <input type="text" name="tabNumber" class="form-control" id="tabNumber" value="${key.tabNumber}" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="username" class="form-label">Логин:</label>
                                                    <input type="text" name="username" class="form-control" id="username" value="${key.username}" required>
                                                </div>
                                                <div class="col-md-3">
                                                    <label for="birthday" class="form-label">День рождения:</label>
                                                    <input type="text" name="birthday" class="form-control" id="birthday" value="${key.birthday}" required>
                                                </div>
                                                <div class="col-md-3">
                                                    <label for="receptionDate" class="form-label">Дата приема:</label>
                                                    <input type="text" name="receptionDate" class="form-control" id="receptionDate" value="${key.receptionDate}" required>
                                                </div>
                                            <#--                                                <div class="col-md-6">-->
                                            <#--                                                    <label for="email" class="form-label">E-mail:</label>-->
                                            <#--                                                    <input type="email" name="email" class="form-control" id="email" value="${key.username}@gmtmsk.ru">-->
                                            <#--                                                </div>-->
                                                <div class="col-12">
                                                    <label for="position" class="form-label">Должность:</label>
                                                    <input type="text" name="position" class="form-control" id="position" value="${key.position}" required>
                                                </div>
                                                <div class="col-12">
                                                    <label for="department" class="form-label">Структурное подразделение:</label>
                                                    <input type="text" name="department" class="form-control" id="department" value="${key.department}" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="manager" class="form-label">Непосредственный руководитель:</label>
                                                    <input type="text" name="manager" class="form-control" id="manager">
                                                </div>

                                                <div class="col-md-2">
                                                    <label for="office" class="form-label">Кабинет:</label>
                                                    <input type="text" name="office" class="form-control" id="office" required>
                                                    <div class="invalid-feedback">
                                                        Введите № кабинета.
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <label for="inputPhone" class="form-label">Телефон:</label>
                                                    <input type="text" name="innerPhone" class="form-control" id="innerPhone" required>
                                                    <div class="invalid-feedback">
                                                        Введите № телефона.
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <label for="sex" class="form-label">Пол:</label>
                                                    <input type="text" name="sex" class="form-control" id="sex" value="${key.sex}" required>
                                                </div>
                                                <div class="col-md-12">
                                                    <label for="example" class="form-label">Скопировать группы доступа:</label>
                                                    <select id="example" name="example" class="form-select" aria-label="select">
                                                        <option selected>Выберете сотрудника</option>
                                                        <#if value?? && value?has_content>
                                                            <#list value as user>
                                                                <option  value="${user.DN}">${user.name}</option>
                                                            </#list>
                                                        <#else>
                                                            <option value="">Нет сотрудников</option>
                                                        </#if>
                                                    </select>
                                                </div>
                                            </#list>
                                            <div class="col-12">
                                                <button type="submit" class="btn btn-primary">Создать пользователя(-ей)</button>
                                            </div>
                                        <#else>
                                            <h2 align="center">Список пуст</h2>
                                        </#if>
                                    </form>
                                    <br>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</@c.page>
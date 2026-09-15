<#import "parts/main.ftlh" as c>
<@c.page>
    <br>
    <h3 align="center">Сервис по обновлению данных пользователей</h3>
    <br>
    <div class="u-clearfix u-sheet u-sheet-1">
        <div class="u-container-layout u-container-layout-1">
            <form method="post" action="/upload2" enctype="multipart/form-data">
                <div class="input-group">
                    <input type="file" name="uploadedFile2" class="form-control" id="inputGroupFile04" aria-describedby="inputGroupFileAddon04" aria-label="Upload">
                    <button class="btn btn-outline-secondary" type="submit" id="inputGroupFileAddon04">Обновить данные пользователей</button>
                </div>
            </form>
            <br>
            <p>Пользователи, не найденные в списке:</p>
            <form class="form-update" method="post" action="/fired">
                <#if firedEmp?? && firedEmp?has_content>
                    <div class="list-group">
                        <#list firedEmp as employee>
                            <label class="list-group-item">
                                <input class="form-check-input me-1" type="checkbox" name="fired" value="${employee.username}">
                                ${employee.name}, ${employee.position}, ${employee.department} -
                                <#if employee.tabNumber?? && employee.tabNumber?has_content>
                                    ${employee.tabNumber}
                                <#else>
                                    таб.номер отсутствует
                                </#if>
                            </label>
                        </#list>
                        <br>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">Отправить в уволенные</button>
                        </div>
                    </div>

                <#else>
                    <h2 align="center">Список пуст!</h2>
                </#if>
            </form>
        </div>
    </div>
</@c.page>
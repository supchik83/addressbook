<#import "parts/main.ftlh" as c>
<@c.page>
    <section class="u-clearfix u-section-1" id="sec-15f9" xmlns="http://www.w3.org/1999/html">
        <div class="u-clearfix u-sheet u-sheet-1">
            <div class="custom-expanded u-tab-links-align-center u-tabs u-tabs-1">
                <ul class="u-tab-list u-unstyled" role="tablist"><li class="u-tab-item" role="presentation"><a class="active u-button-style u-tab-link u-tab-link-1" id="link-tab-877b" href="#tab-877b" role="tab" aria-controls="tab-877b" aria-selected="true">Отсутствующие руководители</a>
                    </li><li class="u-tab-item" role="presentation"><a class="u-button-style u-tab-link u-tab-link-2" id="link-tab-25ac" href="#tab-25ac" role="tab" aria-controls="tab-25ac" aria-selected="false">Отсутствующие сотрудники</a>
                    </li></ul>
                <div class="u-tab-content">
                    <div class="u-container-style u-tab-active u-tab-pane" id="tab-877b" role="tabpanel" aria-labelledby="link-tab-877b">
                        <div class="u-container-layout u-container-layout-6">
                            <h2 align="center">Отсутствующие руководители:</h2>
                            <div class="u-expanded-width u-table u-table-responsive u-table-1">
                                <#if managers?? && managers?has_content>
                                    <table class="bordered" xmlns="http://www.w3.org/1999/html">
                                        <thead>
                                        <tr>
                                            <th></th>
                                            <th>ФИО сотрудника</th>
                                            <th>Должность</th>
                                            <th>Подразделение</th>
                                            <th>Причина отсутствия</th>
                                            <th>отсутствует по</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <#list managers as manager>
                                            <tr href = "${manager.id}" class="lightview" data-lightview-type="iframe" data-lightview-options="skin:'light'">
                                                <td><img src="data:image/png;base64,${manager.photo}" width="65" height="65" loading="lazy"></td>
                                                <td >${manager.name}</td>
                                                <td>${manager.position}</td>
                                                <td>${manager.department}</td>
                                                <td>${manager.cause}</td>
                                                <td>${manager.lack}</td>
                                            </tr>
                                        </#list>
                                        </tbody>
                                    </table>
                                <#else>
                                    <h2 align="center">Никого не нашли</h2>
                                </#if>
                            </div>
                        </div>
                    </div>
                    <div class="u-container-style u-tab-pane" id="tab-25ac" role="tabpanel" aria-labelledby="link-tab-25ac">
                        <div class="u-container-layout u-container-layout-6">
                            <h2 align="center">Отсутствующие сотрудники:</h2>
                            <form class="form-inline my-2">
                                <div class="col-md-4">
                                    <input type="text" id="search-emp" class="form-control col-md-3" onkeyup="tableSearch_emp()" placeholder="Поиск...">
                                </div>
                            </form>
                            <div class="u-expanded-width u-table u-table-responsive u-table-1">
                                <#if employees?? && employees?has_content>
                                    <table class="bordered" xmlns="http://www.w3.org/1999/html" id="addr-table">
                                        <thead>
                                        <tr>
                                            <th></th>
                                            <th>ФИО сотрудника</th>
                                            <th>Должность</th>
                                            <th>Подразделение</th>
                                            <th>Причина отсутствия</th>
                                            <th>Отсутствует по</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <#list employees as emp>
                                            <tr href = "${emp.id}" class="lightview" data-lightview-type="iframe" data-lightview-options="skin:'light'">
                                                <td><img src="data:image/png;base64,${emp.photo}" width="65" height="65" loading="lazy"></td>
                                                <td>${emp.name}</td>
                                                <td>${emp.position}</td>
                                                <td>${emp.department}</td>
                                                <td>${emp.cause}</td>
                                                <td>${emp.lack}</td>
                                            </tr>
                                        </#list>
                                        </tbody>
                                    </table>
                                <#else>
                                    <h2 align="center">Никого не нашли</h2>
                                </#if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</@c.page>



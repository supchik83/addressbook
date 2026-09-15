<#import "parts/main.ftlh" as c>
<@c.page>
    <section class="u-clearfix u-section-1" id="sec-15f9">
        <div class="u-clearfix u-sheet u-sheet-1">
            <div class="custom-expanded u-tab-links-align-center u-tabs u-tabs-1">
                <ul class="u-tab-list u-unstyled" role="tablist"><li class="u-tab-item" role="presentation"><a class="active u-button-style u-tab-link u-tab-link-1" id="link-tab-877b" href="#tab-877b" role="tab" aria-controls="tab-877b" aria-selected="true">Дни рождения сегодня</a>
                    </li><li class="u-tab-item" role="presentation"><a class="u-button-style u-tab-link u-tab-link-2" id="link-tab-25ac" href="#tab-25ac" role="tab" aria-controls="tab-25ac" aria-selected="false">Дни рождения в этом месяце</a>
                    </li></ul>
                <div class="u-tab-content">
                    <div class="u-container-style u-tab-active u-tab-pane" id="tab-877b" role="tabpanel" aria-labelledby="link-tab-877b">
                        <div class="u-container-layout u-container-layout-1">
                            <h2 align="center">День рождения сегодня отмечают:</h2>
                            <div class="u-expanded-width u-list u-list-1">
                                <div class="u-repeater u-repeater-1">
                                    <#if celebrants?? && celebrants?has_content>
                                        <#list celebrants as celebrant>
                                        <div class="u-container-style u-list-item u-repeater-item">
                                            <div class="u-container-layout u-similar-container u-valign-top u-container-layout-1">
                                                <p class="u-align-left u-custom-font u-font-roboto u-text u-text-2"> ${celebrant.name}</p>
                                                <img class="u-align-center u-image u-image-round u-radius u-image-1" src="data:image/png;base64,${celebrant.photo}" alt="" data-image-width="1024" data-image-height="1024">
                                                <p class="u-align-left u-custom-font u-font-roboto u-text u-text-3"> ${celebrant.position}</p>
                                                <p class="u-align-left u-custom-font u-font-roboto u-text u-text-4"> ${celebrant.department}</p>
                                                <a href="mailto:${celebrant.email}" class="u-border-2 u-border-grey-75 u-btn u-btn-round u-button-style u-gradient u-none u-radius u-text-body-alt-color u-btn-1"> Отправить поздравление </a>
                                            </div>
                                        </div>
                                        </#list>
                                    <#else>
                                        <h2 align="center">Никого не нашли</h2>
                                    </#if>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="u-container-style u-tab-pane" id="tab-25ac" role="tabpanel" aria-labelledby="link-tab-25ac">
                        <div class="u-container-layout u-container-layout-6">
                            <h2 align="center">Дни рождения в этом месяце отмечают:</h2>
                            <div class="u-expanded-width u-table u-table-responsive u-table-1">
                                <#if celebrantsM?? && celebrantsM?has_content>
                                    <table class="bordered" xmlns="http://www.w3.org/1999/html" id="addr-table">
                                        <thead>
                                        <tr>
                                            <th></th>
                                            <th>ФИО сотрудника</th>
                                            <th>Должность</th>
                                            <th>Отдел</th>
                                            <th>Дата рождения</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <#list celebrantsM as celebrantM>
                                            <tr href = "${celebrantM.id}" class="lightview" data-lightview-type="iframe" data-lightview-options="skin:'light'">
                                                <td><img src="data:image/png;base64,${celebrantM.photo}" width="65" height="65"></td>
                                                <td width="400">${celebrantM.name}</td>
                                                <td>${celebrantM.position}</td>
                                                <td>${celebrantM.department}</td>
                                                <td>${celebrantM.birthday}</td>
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
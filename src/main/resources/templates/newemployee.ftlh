<#import "parts/main.ftlh" as c>
<@c.page>
    <h2 align="center">Добро пожаловать в команду!</h2>
    <section class="u-clearfix u-section-1" id="sec-3a3e">
        <div class="u-clearfix u-sheet u-sheet-1">
            <div class="u-expanded-width u-list u-list-1">
                <div class="u-repeater u-repeater-1">
                    <#if newemployees?? && newemployees?has_content>
                        <#list newemployees as new>
                            <div class="u-container-style u-list-item u-repeater-item">
                                <div class="u-container-layout u-similar-container u-valign-top u-container-layout-2">
                                    <p class="u-align-left u-custom-font u-font-roboto u-text u-text-2"> ${new.name}</p>
                                    <img class="u-align-center u-image u-image-round u-radius u-image-1" src="data:image/png;base64,${new.photo}" alt="" data-image-width="1024" data-image-height="1024">
                                    <p class="u-align-left u-custom-font u-font-roboto u-text u-text-3"> ${new.position}</p>
                                    <p class="u-align-left u-custom-font u-font-roboto u-text u-text-4"> ${new.department}</p>
                                    <p class="u-align-right u-custom-font u-font-roboto u-text u-text-5"> Дата приема: ${new.receptionDate}</p>
                                </div>
                            </div>
                        </#list>
                    <#else>
                        <h2 align="center">Новых сотрудников нет!</h2>
                    </#if>
                </div>
            </div>
        </div>
    </section>

</@c.page>
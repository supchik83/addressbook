<#import "parts/main.ftlh" as c>
<@c.page>
    <section class="u-clearfix u-section-1" id="sec-3a3e">
        <div class="u-clearfix u-sheet u-sheet-1">
            <h2 align="center">Добро пожаловать в команду!</h2>

            <div class="pb-wrap">
                <#if newemployees?? && newemployees?has_content>
                    <p class="pb-section-sub">Коллеги, которые недавно вышли на работу</p>

                    <div class="pb-people">
                        <#list newemployees as new>
                            <div class="pb-person">
                                <span class="pb-person-flag" aria-hidden="true">👋</span>
                                <span class="pb-person-avatar">
                                    <img src="data:image/png;base64,${new.photo!''}" width="96" height="96" loading="lazy" alt=""
                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                    <span class="pb-avatar-fallback" style="display:none">${(new.name!'?')?substring(0,1)}</span>
                                </span>
                                <div class="pb-person-name">${new.name}</div>
                                <div class="pb-person-position">${new.position!''}</div>
                                <div class="pb-person-dept">${new.department!''}</div>
                                <div class="pb-person-foot">
                                    <span class="pb-pill">Принят: ${new.receptionDate!''}</span>
                                </div>
                            </div>
                        </#list>
                    </div>
                <#else>
                    <div class="pb-table-card">
                        <div class="pb-empty" style="display:flex">
                            <p>Новых сотрудников нет</p>
                            <span>Как только кто-то выйдет на работу, он появится здесь</span>
                        </div>
                    </div>
                </#if>
            </div>
        </div>
    </section>
</@c.page>

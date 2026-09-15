<#import "parts/main.ftlh" as c>
<@c.page>
    <h2 align="center">Добро пожаловать в команду ГАУ ИНПЦ "Гормедтехника"</h2>
    <div class="u-clearfix u-sheet u-sheet-1">
    <section class="u-clearfix u-section-1" id="sec-15f9">
        <div class="data-layout-selected u-clearfix u-expanded-width u-layout-wrap u-layout-wrap-1">
            <div class="u-layout">
                <div class="u-layout-row">
                    <div class="u-container-style u-layout-cell u-size-30 u-layout-cell-1">
                        <div class="u-container-layout u-valign-bottom u-container-layout-3">
                            <a href="docs\Presentation.pdf" target="_blank">
                                <img class="u-expanded-width u-image u-image-contain u-image-default u-image-2" src="img/preza.png" alt="" data-image-width="1021" data-image-height="560">
                            </a>
                        </div>
                    </div>
                    <div class="u-container-style u-layout-cell u-size-1 u-layout-cell-2">
                        <div class="u-container-layout u-container-layout-4"></div>
                    </div>
                    <div class="u-container-style u-layout-cell u-size-29 u-layout-cell-3">
                        <div class="u-container-layout u-container-layout-5">
                            <h4 class="u-text u-text-default u-text-6">Полезные ссылки: </h4>
                            <a href="https://xn--80afddbsolmfw1a4b.xn--p1ai/" target="_blank" class="u-active-none u-border-2 u-border-no-left u-border-no-right u-border-no-top u-border-palette-1-base u-btn u-btn-rectangle u-button-style u-hover-none u-none u-btn-5"> Официальный
                                сайт ГАУ ИНПЦ "Гормедтехника"</a>
                            <a href="https://support.gmtmsk.ru/portal" target="_blank" class="u-active-none u-border-2 u-border-no-left u-border-no-right u-border-no-top u-border-palette-1-base u-btn u-btn-rectangle u-button-style u-hover-none u-none u-btn-5"> Сервис
                                технической поддержки ГМТ</a>
                            <a href="https://mosedo.mos.ru/auth.php?uri=%2F" target="_blank" class="u-active-none u-border-2 u-border-no-left u-border-no-right u-border-no-top u-border-palette-1-base u-btn u-btn-rectangle u-button-style u-hover-none u-none u-btn-5"> Система
                                электронного документооборота</a>
                            <a href="https://t.me/gmtmsk_bot" target="_blank" class=" qr-hover u-active-none u-border-2 u-border-no-left u-border-no-right u-border-no-top u-border-palette-1-base u-btn u-btn-rectangle u-button-style u-hover-none u-none u-btn-5">Закрытый телеграм канал ГАУ ИНПЦ "Гормедтехника"</a>
<#--                            <div class="qr-code-container">-->
<#--                                <div class="qr-code"></div>-->
<#--                            </div>-->
                            <a href="https://t.me/gmtsport25" target="_blank" class=" u-active-none u-border-2 u-border-no-left u-border-no-right u-border-no-top u-border-palette-1-base u-btn u-btn-rectangle u-button-style u-hover-none u-none u-btn-5">Спортивное сообщество ГАУ ИНПЦ "Гормедтехника"</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <h3 align="center">Пожалуйста, ознакомтесь с полезными документами!</h3>
        <form class="form-inline my-2">
            <div class="col-md-4">
                <input type="text" id="search-docs" class="form-control col-md-3" onkeyup="tableSearch_docs()" placeholder="Поиск...">
            </div>
        </form>
        <div class="u-expanded-width u-table u-table-responsive u-table-1">
            <table class="bordered" xmlns="http://www.w3.org/1999/html" id="text-table">
                <thead>
                <tr>
                    <th>Наименование документа</th>
                </tr>
                </thead>
                <tbody>
                <#list docs as doc>
                    <tr data-href="/for-new-emp/${doc}">
                        <td>${doc}</td>
                    </tr>
                </#list>
                </tbody>
            </table>
        </div>
    </section>
</@c.page>
<#import "parts/main.ftlh" as c>
<@c.page>
    <h2 align="center">Инструкции по работе в информационной системе</h2>
        <div class="u-clearfix u-sheet u-sheet-1">
            <form class="form-inline my-2">
                <div class="col-md-4">
                    <input type="text" id="search-text" class="form-control col-md-3" onkeyup="tableSearch()" placeholder="Поиск...">
                </div>
            </form>
            <div class="u-expanded-width u-table u-table-responsive u-table-1">
                <table class="bordered" xmlns="http://www.w3.org/1999/html" id="addr-table">
                    <thead>
                    <tr>
                        <th>Наименование документа</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list docs as doc>
                        <tr data-href="tech/${doc}">
                            <td>${doc}</td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>
</@c.page>
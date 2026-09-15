<#import "parts/main.ftlh" as c>
<@c.page>
    <style>
        .outer:before {
            content: '';
            display: inline-block;
            height: 100%;
            vertical-align: middle;
        }
        .outer {
            text-align: center;
        }
    </style>
    <div class="outer">
        <h3>${message}</h3>
        <br>
        <br>
        <input class="btn btn-primary" type="button" onclick="history.back();" value="Назад"/>
    </div>
</@c.page>
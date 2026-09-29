<#import "parts/main.ftlh" as c>
<@c.page>
<style>
    .uu-wrap {
        max-width: 960px;
        margin: 0 auto;
        padding: 24px 16px 60px;
        font-family: -apple-system, "Segoe UI", Roboto, Arial, sans-serif;
        color: #2b2f36;
    }
    .uu-title {
        text-align: center;
        font-weight: 600;
        margin-bottom: 24px;
        color: #1f2430;
    }
    .uu-alert {
        border-radius: 10px;
        padding: 12px 16px;
        margin-bottom: 20px;
        background: #eaf6ec;
        border: 1px solid #bfe6c6;
        color: #245c2e;
        font-size: 14px;
    }
    .uu-card {
        background: #ffffff;
        border: 1px solid #e5e8ee;
        border-radius: 14px;
        box-shadow: 0 2px 10px rgba(20, 25, 40, 0.04);
        padding: 20px 22px;
        margin-bottom: 24px;
    }
    .uu-card-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 14px;
    }
    .uu-card-header h4 {
        margin: 0;
        font-size: 17px;
        font-weight: 600;
        color: #1f2430;
    }
    .uu-badge {
        display: inline-block;
        min-width: 24px;
        padding: 2px 9px;
        border-radius: 999px;
        background: #eef1f6;
        color: #4a5468;
        font-size: 13px;
        font-weight: 600;
        text-align: center;
    }
    .uu-badge.warn { background: #fdecd2; color: #8a5a00; }
    .uu-badge.danger { background: #fbe4e4; color: #a12727; }

    .uu-upload-row {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }
    .uu-upload-row input[type=file] {
        flex: 1 1 260px;
        padding: 8px 10px;
        border: 1px solid #d7dce4;
        border-radius: 8px;
        background: #fafbfc;
    }
    .uu-btn {
        border: none;
        border-radius: 8px;
        padding: 9px 18px;
        font-weight: 600;
        font-size: 14px;
        cursor: pointer;
        transition: background 0.15s ease, transform 0.05s ease;
    }
    .uu-btn:active { transform: translateY(1px); }
    .uu-btn-primary { background: #2f6feb; color: #fff; }
    .uu-btn-primary:hover { background: #2559c4; }
    .uu-btn-danger { background: #d64545; color: #fff; }
    .uu-btn-danger:hover { background: #b93636; }
    .uu-btn-disabled { background: #d7dce4; color: #8a93a3; cursor: not-allowed; }

    .uu-log {
        max-height: 340px;
        overflow-y: auto;
        border: 1px solid #edf0f4;
        border-radius: 10px;
        background: #fbfcfe;
    }
    .uu-log-item {
        padding: 9px 14px;
        font-family: "SFMono-Regular", Consolas, Menlo, monospace;
        font-size: 12.5px;
        line-height: 1.5;
        border-bottom: 1px solid #eef1f6;
        color: #3a4150;
        word-break: break-word;
    }
    .uu-log-item:last-child { border-bottom: none; }
    .uu-log-item.match {
        background: #fff8ea;
        color: #7a5200;
    }
    .uu-log-empty {
        padding: 18px;
        text-align: center;
        color: #9aa2b1;
        font-size: 14px;
    }

    .uu-fired-list {
        display: flex;
        flex-direction: column;
        gap: 8px;
        max-height: 420px;
        overflow-y: auto;
        padding-right: 2px;
    }
    .uu-fired-item {
        display: flex;
        align-items: flex-start;
        gap: 10px;
        border: 1px solid #edf0f4;
        border-radius: 10px;
        padding: 10px 12px;
        background: #fbfcfe;
        transition: background 0.15s ease, border-color 0.15s ease;
    }
    .uu-fired-item:hover {
        background: #fdf2f2;
        border-color: #f3c9c9;
    }
    .uu-fired-item input[type=checkbox] {
        margin-top: 3px;
        width: 16px;
        height: 16px;
        accent-color: #d64545;
    }
    .uu-fired-name {
        font-weight: 600;
        color: #1f2430;
        font-size: 14px;
    }
    .uu-fired-meta {
        font-size: 13px;
        color: #6a7386;
        margin-top: 2px;
    }
    .uu-fired-tab {
        font-size: 12px;
        color: #9aa2b1;
        margin-top: 2px;
    }
    .uu-fired-submit {
        margin-top: 16px;
        text-align: right;
    }
    .uu-empty-state {
        text-align: center;
        padding: 28px 10px;
        color: #6a7386;
    }
    .uu-empty-state .uu-emoji {
        font-size: 28px;
        display: block;
        margin-bottom: 8px;
    }
</style>

<div class="uu-wrap">
    <h3 class="uu-title">Сервис по обновлению данных пользователей</h3>

    <#if message?? && message?has_content>
        <div class="uu-alert">${message}</div>
    </#if>

    <div class="uu-card">
        <div class="uu-card-header">
            <h4>Загрузка файла с данными</h4>
        </div>
        <form method="post" action="/upload2" enctype="multipart/form-data">
            <div class="uu-upload-row">
                <input type="file" name="uploadedFile2" id="inputGroupFile04" aria-label="Upload">
                <button class="uu-btn uu-btn-primary" type="submit">Обновить данные пользователей</button>
            </div>
        </form>
    </div>

    <div class="uu-card">
        <div class="uu-card-header">
            <h4>Лог изменений</h4>
            <#if changeLog?? && changeLog?has_content>
                <span class="uu-badge warn">${changeLog?size}</span>
            <#else>
                <span class="uu-badge">0</span>
            </#if>
        </div>
        <div class="uu-log">
            <#if changeLog?? && changeLog?has_content>
                <#list changeLog as entry>
                    <div class="uu-log-item<#if entry?contains("найден по ФИО")> match</#if>">${entry}</div>
                </#list>
            <#else>
                <div class="uu-log-empty">Загрузите файл, чтобы увидеть изменения</div>
            </#if>
        </div>
    </div>

    <div class="uu-card">
        <div class="uu-card-header">
            <h4>Пользователи, не найденные в списке</h4>
            <#if firedEmp?? && firedEmp?has_content>
                <span class="uu-badge danger">${firedEmp?size}</span>
            <#else>
                <span class="uu-badge">0</span>
            </#if>
        </div>

        <form method="post" action="/fired">
            <#if firedEmp?? && firedEmp?has_content>
                <div class="uu-fired-list">
                    <#list firedEmp as employee>
                        <label class="uu-fired-item">
                            <input type="checkbox" name="fired" value="${employee.username}">
                            <span>
                                <span class="uu-fired-name">${employee.name}</span>
                                <span class="uu-fired-meta">${employee.position}, ${employee.department}</span>
                                <span class="uu-fired-tab">
                                    <#if employee.tabNumber?? && employee.tabNumber?has_content>
                                        Таб. номер: ${employee.tabNumber}
                                    <#else>
                                        Таб. номер отсутствует
                                    </#if>
                                </span>
                            </span>
                        </label>
                    </#list>
                </div>
                <div class="uu-fired-submit">
                    <button type="submit" class="uu-btn uu-btn-danger">Отправить в уволенные</button>
                </div>
            <#else>
                <div class="uu-empty-state">
                    <span class="uu-emoji">&#10003;</span>
                    Список пуст
                </div>
            </#if>
        </form>
    </div>
</div>
</@c.page>

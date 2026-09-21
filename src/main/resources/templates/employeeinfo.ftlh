<!DOCTYPE html>
<html style="font-size: 16px;" lang="ru">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="utf-8">
    <title>${user.name}</title>
    <link rel="stylesheet" href="/css/employeeinfo.css" media="screen">
</head>
<body class="ei-body">

<div class="ei-page">

    <#-- ========== Карточка сотрудника: зафиксирована ========== -->
    <div class="ei-card">
        <div class="ei-photo">
            <#if (user.photo)?? && user.photo?has_content>
                <img src="data:image/png;base64,${user.photo}" alt="${user.name}">
            <#else>
                <div class="ei-photo-fallback">${(user.name!'?')?substring(0,1)}</div>
            </#if>
        </div>

        <div class="ei-info">
            <h1 class="ei-name">${user.name}</h1>
            <p class="ei-position">${user.position!''}</p>
            <p class="ei-dept">${user.department!''}</p>

            <div class="ei-divider"></div>

            <div class="ei-facts">
                <div class="ei-fact">
                    <span class="ei-fact-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3.1 19.5 19.5 0 0 1-6-6A19.8 19.8 0 0 1 2.1 4.2 2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1 1 .3 1.9.6 2.8a2 2 0 0 1-.5 2.1L8.1 9.9a16 16 0 0 0 6 6l1.3-1.3a2 2 0 0 1 2.1-.4c.9.3 1.8.5 2.8.6a2 2 0 0 1 1.7 2z"/>
                        </svg>
                    </span>
                    <div>
                        <div class="ei-fact-label">Телефон</div>
                        <div class="ei-fact-value">${user.phone!'—'}</div>
                    </div>
                </div>

                <div class="ei-fact">
                    <span class="ei-fact-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <rect x="4" y="2" width="16" height="20" rx="2"/>
                            <line x1="8" y1="7" x2="16" y2="7"/>
                            <line x1="8" y1="11" x2="16" y2="11"/>
                            <line x1="10" y1="18" x2="14" y2="18"/>
                        </svg>
                    </span>
                    <div>
                        <div class="ei-fact-label">Внутренний</div>
                        <div class="ei-fact-value">${user.innerPhone!'—'}</div>
                    </div>
                </div>

                <div class="ei-fact">
                    <span class="ei-fact-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <rect x="2" y="4" width="20" height="16" rx="2"/>
                            <path d="M22 6l-10 7L2 6"/>
                        </svg>
                    </span>
                    <div>
                        <div class="ei-fact-label">E-mail</div>
                        <div class="ei-fact-value">
                            <#if (user.email)?? && user.email?has_content>
                                <a href="mailto:${user.email}">${user.email}</a>
                            <#else>—</#if>
                        </div>
                    </div>
                </div>

                <div class="ei-fact">
                    <span class="ei-fact-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <path d="M3 21h18M5 21V7l7-4 7 4v14"/>
                            <path d="M10 21v-6h4v6"/>
                        </svg>
                    </span>
                    <div>
                        <div class="ei-fact-label">Кабинет</div>
                        <div class="ei-fact-value">${user.office!'—'}</div>
                    </div>
                </div>

                <div class="ei-fact">
                    <span class="ei-fact-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <rect x="3" y="4" width="18" height="18" rx="2"/>
                            <line x1="16" y1="2" x2="16" y2="6"/>
                            <line x1="8" y1="2" x2="8" y2="6"/>
                            <line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                    </span>
                    <div>
                        <div class="ei-fact-label">Работает в ГМТ с</div>
                        <div class="ei-fact-value">${user.receptionDate!'—'}</div>
                    </div>
                </div>

                <div class="ei-fact">
                    <span class="ei-fact-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                        </svg>
                    </span>
                    <div>
                        <div class="ei-fact-label">Руководитель</div>
                        <div class="ei-fact-value">${user.manager!'—'}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <#-- ========== Подчинённые: скроллится только этот блок ========== -->
    <#if workers?? && workers?has_content>
        <div class="ei-subs">
            <div class="ei-subs-head">
                <h2 class="ei-subs-title">Подчинённые</h2>
                <span class="ei-subs-count">${workers?size}</span>
            </div>

            <div class="ei-scroll">
                <table class="ei-table">
                    <thead>
                    <tr>
                        <th style="width:24%">ФИО сотрудника</th>
                        <th style="width:11%">Телефон</th>
                        <th style="width:17%">E-mail</th>
                        <th style="width:17%">Должность</th>
                        <th style="width:23%">Подразделение</th>
                        <th style="width:8%">Кабинет</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list workers as worker>
                        <tr>
                            <td>${worker.name}</td>
                            <td class="ei-nowrap">${worker.innerPhone!''}</td>
                            <td>
                                <#if (worker.email)?? && worker.email?has_content>
                                    <a href="mailto:${worker.email}">${worker.email}</a>
                                </#if>
                            </td>
                            <td>${worker.position!''}</td>
                            <td>${worker.department!''}</td>
                            <td class="ei-nowrap">${worker.office!''}</td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>
    </#if>

</div>

</body>
</html>

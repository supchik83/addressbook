<#import "parts/main.ftlh" as c>
<@c.page>
    <section class="u-clearfix u-section-1">
        <div class="u-clearfix u-sheet u-sheet-1">
            <h2 align="center">Шаблоны кадровых документов</h2>

            <div class="pb-wrap">
                <p class="pb-section-sub">Готовые формы заявлений и приказов — нажмите на строку, чтобы скачать</p>

                <div class="file-explorer">
                    <div class="toolbar">
                        <div class="toolbar-title">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 2h9a2 2 0 0 1 2 2z"/>
                            </svg>
                            <span>Шаблоны кадровых документов</span>
                        </div>

                        <div class="search-container">
                            <input type="text" id="searchInput" placeholder="Поиск документов..."
                                   value="${searchQuery!''}" class="search-bar" autocomplete="off">
                            <input type="hidden" id="bucketValue" value="${bucket}">
                            <input type="hidden" id="pathValue" value="${currentPath}">
                            <button id="searchButton" type="button">Поиск</button>
                            <button id="clearSearchButton" type="button" style="display: none;">Очистить поиск</button>
                        </div>
                    </div>

                    <div class="content">
                        <#-- Панель директорий -->
                        <div id="directoriesPanel" class="directories-panel">
                            <div class="panel-caption">Разделы</div>

                            <div class="directory-back-button" onclick="goUpOneLevelTempl()">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                    <path d="M19 12H5M12 19l-7-7 7-7"/>
                                </svg>
                                Назад
                            </div>

                            <ul class="directory-list">
                                <#if currentPath != "">
                                    <#assign displayPath = currentPath?ends_with('/')?then(currentPath?substring(0, currentPath?length-1), currentPath)>
                                    <li class="directory-item active" onclick="window.location='/templates_new?bucket=${bucket}&path=${currentPath?substring(0, currentPath?last_index_of('/') + 1)?url}'">
                                        <svg class="directory-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                            <path d="M19 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2z"/>
                                        </svg>
                                        <span>${displayPath}</span>
                                    </li>
                                </#if>

                                <#list directories as dir>
                                    <#assign displayDirPath = dir.path?ends_with('/')?then(dir.path?substring(0, dir.path?length-1), dir.path)>
                                    <li class="directory-item" onclick="window.location='/templates_new?bucket=${bucket}&path=${dir.path?url}'">
                                        <svg class="directory-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                            <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 2h9a2 2 0 0 1 2 2z"/>
                                        </svg>
                                        <span>${displayDirPath}</span>
                                    </li>
                                </#list>

                                <#if !(directories?? && directories?has_content) && currentPath == "">
                                    <li class="panel-caption" style="padding-top:6px">Вложенных разделов нет</li>
                                </#if>
                            </ul>
                        </div>

                        <#-- Панель файлов -->
                        <div id="filesPanel" class="files-panel">
                            <#if files?? && files?has_content>
                                <table class="file-table">
                                    <thead>
                                    <tr>
                                        <th>Название документа</th>
                                        <th class="file-size">Размер</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <#list files as file>
                                        <tr onclick="downloadFile('${bucket}', '${file.path?js_string}')" title="Скачать ${file.name}">
                                            <td>
                                                <div class="file-name">
                                                    <#if file.extension == "pdf">
                                                        <svg class="file-icon file-icon-pdf" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                                                            <polyline points="14 2 14 8 20 8"/>
                                                            <line x1="10" y1="13" x2="10" y2="15"/>
                                                            <line x1="10" y1="17" x2="10" y2="17"/>
                                                            <line x1="14" y1="13" x2="14" y2="15"/>
                                                            <line x1="14" y1="17" x2="14" y2="17"/>
                                                            <line x1="18" y1="13" x2="18" y2="15"/>
                                                            <line x1="18" y1="17" x2="18" y2="17"/>
                                                        </svg>
                                                    <#elseif file.extension == "jpg" || file.extension == "jpeg" || file.extension == "png" || file.extension == "gif">
                                                        <svg class="file-icon file-icon-image" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                                                            <circle cx="8.5" cy="8.5" r="1.5"/>
                                                            <polyline points="21 15 16 10 5 21"/>
                                                        </svg>
                                                    <#elseif file.extension == "doc" || file.extension == "docx">
                                                        <svg class="file-icon file-icon-doc" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                                                            <polyline points="14 2 14 8 20 8"/>
                                                            <line x1="16" y1="13" x2="16" y2="16"/>
                                                            <line x1="16" y1="17" x2="16" y2="19"/>
                                                            <line x1="10" y1="13" x2="10" y2="16"/>
                                                            <line x1="10" y1="17" x2="10" y2="19"/>
                                                            <line x1="13" y1="13" x2="13" y2="16"/>
                                                            <line x1="13" y1="17" x2="13" y2="19"/>
                                                        </svg>
                                                    <#elseif file.extension == "xls" || file.extension == "xlsx">
                                                        <svg class="file-icon file-icon-xls" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                                                            <polyline points="14 2 14 8 20 8"/>
                                                            <line x1="8" y1="13" x2="8" y2="15"/>
                                                            <line x1="8" y1="17" x2="8" y2="19"/>
                                                            <line x1="12" y1="13" x2="12" y2="15"/>
                                                            <line x1="12" y1="17" x2="12" y2="19"/>
                                                            <line x1="16" y1="13" x2="16" y2="15"/>
                                                            <line x1="16" y1="17" x2="16" y2="19"/>
                                                        </svg>
                                                    <#else>
                                                        <svg class="file-icon" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                                            <path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/>
                                                            <polyline points="13 2 13 9 20 9"/>
                                                        </svg>
                                                    </#if>
                                                    <span>${file.name}</span>
                                                </div>
                                            </td>
                                            <td class="file-size">
                                                <#if file.size < 1024>
                                                    ${file.size} B
                                                <#elseif file.size < 1048576>
                                                    ${(file.size / 1024)?string("0.##")} KB
                                                <#else>
                                                    ${(file.size / 1048576)?string("0.##")} MB
                                                </#if>
                                            </td>
                                        </tr>
                                    </#list>
                                    </tbody>
                                </table>
                            <#else>
                                <div class="pb-empty" style="display:flex">
                                    <p>В этом разделе документов нет</p>
                                    <span>Выберите другой раздел слева или найдите шаблон через поиск</span>
                                </div>
                            </#if>
                        </div>
                    </div>

                    <div id="searchResultsPanel" class="search-results-panel" style="display: none;">
                        <div id="searchResultsContent"></div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</@c.page>

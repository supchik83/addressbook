<#import "parts/main.ftlh" as c>
<@c.page>
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .current-date {
            color: #666;
            font-size: 1.2em;
        }
        .video-button {
            background-color: #2cccc4;
            color: white;
            border: none;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            transition: all 0.3s;
            position: relative;
            margin: 10px 0;
        }
        .video-button:hover {
            background-color: #2cccc4;
            transform: scale(1.1);
        }
        .video-button::before {
            content: "▶";
            font-size: 24px;
        }
        .video-button::after {
            content: "Посмотреть загруженность столовой";
            position: absolute;
            white-space: nowrap;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 14px;
            bottom: -40px;
            left: 50%;
            transform: translateX(-50%);
            opacity: 0;
            transition: opacity 0.3s;
        }
        .video-button:hover::after {
            opacity: 1;
        }

        /* Стили модального окна */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0,0,0,0.7);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background-color: white;
            border-radius: 8px;
            width: 80%;
            max-width: 800px;
            padding: 20px;
            position: relative;
            box-shadow: 0 4px 20px rgba(0,0,0,0.25);
        }
        .modal-close {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 24px;
            cursor: pointer;
            color: #666;
            background: none;
            border: none;
        }
        .modal-close:hover {
            color: #333;
        }
        .modal-title {
            text-align: center;
            margin-top: 0;
            color: #2cccc4;
        }
        .video-container {
            position: relative;
            padding-bottom: 56.25%; /* 16:9 */
            height: 0;
            overflow: hidden;
            margin: 20px 0;
        }
        .video-container iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
        }

        /* Остальные стили меню */
        .menu-columns {
            display: flex;
            gap: 30px;
            padding: 3px 3px 10%;
        }
        .menu-column {
            flex: 1;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 20px;
        }
        .meal-title {
            color: #d35400;
            border-bottom: 2px solid #d35400;
            padding-bottom: 10px;
            margin-top: 0;
            text-align: center;
        }
        .category {
            margin-bottom: 25px;
        }
        .category-title {
            color: #2cccc4;
            margin-bottom: 10px;
            font-size: 1.2em;
            padding-left: 10px;
            border-left: 4px solid #2cccc4;
        }
        .menu-items {
            display: grid;
            grid-template-columns: 1fr;
            gap: 12px;
        }
        .menu-item {
            border: 1px solid #eee;
            padding: 12px 15px;
            border-radius: 5px;
            background-color: #fefefe;
        }
        .item-name {
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }
        .item-details {
            display: flex;
            justify-content: space-between;
            color: #666;
            font-size: 0.9em;
        }
        .item-price {
            color: #27ae60;
            font-weight: bold;
        }

        @media (max-width: 768px) {
            .menu-columns {
                flex-direction: column;
            }
            .header-section {
                flex-direction: column;
                align-items: flex-start;
            }
            .video-button {
                align-self: center;
                margin: 15px 0;
            }
            .modal-content {
                width: 95%;
                padding: 15px;
            }
        }
    </style>

    <div class="container">
        <div class="header-section">
            <div>
                <h1>Меню столовой</h1>
                <div class="current-date">на ${.now?string('dd.MM.yyyy')}</div>
            </div>
            <button class="video-button" onclick="showCafeteriaTraffic()"></button>
        </div>
        <!-- Модальное окно загруженности столовой -->
        <div id="trafficModal" class="modal-overlay">
            <div class="modal-content">
                <button class="modal-close" onclick="closeModal()">×</button>
                <h3 class="modal-title">Текущая загруженность столовой</h3>
                <div class="video-container">
                    <img id="stream" width="100%" height="480">
                </div>
            </div>
        </div>
        <div class="menu-columns">
            <!-- Колонка завтрака -->
            <div class="menu-column">
                <h2 class="meal-title">Завтрак</h2>

                <!-- Категория: Основные блюда -->
                <#assign hasBreakfastMain = false>
                <#list menuItems as item>
                    <#if item.view == "Завтрак" && item.category == "Основные блюда">
                        <#assign hasBreakfastMain = true>
                        <#break>
                    </#if>
                </#list>
                <#if hasBreakfastMain>
                <div class="category">
                    <h3 class="category-title">Основные блюда</h3>
                    <div class="menu-items">
                        <#list menuItems as item>
                            <#if item.view == "Завтрак" && item.category == "Основные блюда">
                                <div class="menu-item">
                                    <div class="item-name">${item.title}</div>
                                    <div class="item-details">
                                        <span class="item-weight">${item.quantity}</span>
                                        <span class="item-price">${item.price} руб.</span>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </div>
                </div>
                </#if>

                <!-- Категория: Выпечка -->
                <#assign hasBreakfastBakery = false>
                <#list menuItems as item>
                    <#if item.view == "Завтрак" && item.category == "Выпечка">
                        <#assign hasBreakfastBakery = true>
                        <#break>
                    </#if>
                </#list>
                <#if hasBreakfastBakery>
                <div class="category">
                    <h3 class="category-title">Выпечка</h3>
                    <div class="menu-items">
                        <#list menuItems as item>
                            <#if item.view == "Завтрак" && item.category == "Выпечка">
                                <div class="menu-item">
                                    <div class="item-name">${item.title}</div>
                                    <div class="item-details">
                                        <span class="item-weight">${item.quantity}</span>
                                        <span class="item-price">${item.price} руб.</span>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </div>
                </div>
                </#if>

                <!-- Категория: Напитки -->
                <#assign hasBreakfastDrinks = false>
                <#list menuItems as item>
                    <#if item.view == "Завтрак" && item.category == "Напитки">
                        <#assign hasBreakfastDrinks = true>
                        <#break>
                    </#if>
                </#list>
                <#if hasBreakfastDrinks>
                <div class="category">
                    <h3 class="category-title">Напитки</h3>
                    <div class="menu-items">
                        <#list menuItems as item>
                            <#if item.view == "Завтрак" && item.category == "Напитки">
                                <div class="menu-item">
                                    <div class="item-name">${item.title}</div>
                                    <div class="item-details">
                                        <span class="item-weight">${item.quantity}</span>
                                        <span class="item-price">${item.price} руб.</span>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </div>
                </div>
                </#if>

                <!-- Категория: Доп. Ингредиенты -->
                <#assign hasBreakfastIngredients = false>
                <#list menuItems as item>
                    <#if item.view == "Завтрак" && item.category == "Доп. Ингредиент">
                        <#assign hasBreakfastIngredients = true>
                        <#break>
                    </#if>
                </#list>
                <#if hasBreakfastIngredients>
                <div class="category">
                    <h3 class="category-title">Дополнительные ингредиенты</h3>
                    <div class="menu-items">
                        <#list menuItems as item>
                            <#if item.view == "Завтрак" && item.category == "Доп. Ингредиент">
                                <div class="menu-item">
                                    <div class="item-name">${item.title}</div>
                                    <div class="item-details">
                                        <span class="item-weight">${item.quantity}</span>
                                        <span class="item-price">${item.price} руб.</span>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </div>
                </div>
                </#if>
            </div>

            <!-- Колонка обеда -->
            <div class="menu-column">
                <h2 class="meal-title">Обед</h2>

                <!-- Категория: Салаты/Холодные закуски -->
                <#assign hasLunchSalads = false>
                <#list menuItems as item>
                    <#if item.view == "Обед" && item.category == "Салаты/Холодные закуски">
                        <#assign hasLunchSalads = true>
                        <#break>
                    </#if>
                </#list>
                <#if hasLunchSalads>
                <div class="category">
                    <h3 class="category-title">Салаты и холодные закуски</h3>
                    <div class="menu-items">
                        <#list menuItems as item>
                            <#if item.view == "Обед" && item.category == "Салаты/Холодные закуски">
                                <div class="menu-item">
                                    <div class="item-name">${item.title}</div>
                                    <div class="item-details">
                                        <span class="item-weight">${item.quantity}</span>
                                        <span class="item-price">${item.price} руб.</span>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </div>
                </div>
                </#if>

                <!-- Категория: Первые блюда -->
                <#assign hasLunchFirstCourses = false>
                <#list menuItems as item>
                    <#if item.view == "Обед" && item.category == "Первые блюда">
                        <#assign hasLunchFirstCourses = true>
                        <#break>
                    </#if>
                </#list>
                <#if hasLunchFirstCourses>
                <div class="category">
                    <h3 class="category-title">Первые блюда</h3>
                    <div class="menu-items">
                        <#list menuItems as item>
                            <#if item.view == "Обед" && item.category == "Первые блюда">
                                <div class="menu-item">
                                    <div class="item-name">${item.title}</div>
                                    <div class="item-details">
                                        <span class="item-weight">${item.quantity}</span>
                                        <span class="item-price">${item.price} руб.</span>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </div>
                </div>
                </#if>

                <!-- Категория: Вторые блюда -->
                <#assign hasLunchSecondCourses = false>
                <#list menuItems as item>
                    <#if item.view == "Обед" && item.category == "Вторые блюда">
                        <#assign hasLunchSecondCourses = true>
                        <#break>
                    </#if>
                </#list>
                <#if hasLunchSecondCourses>
                <div class="category">
                    <h3 class="category-title">Вторые блюда</h3>
                    <div class="menu-items">
                        <#list menuItems as item>
                            <#if item.view == "Обед" && item.category == "Вторые блюда">
                                <div class="menu-item">
                                    <div class="item-name">${item.title}</div>
                                    <div class="item-details">
                                        <span class="item-weight">${item.quantity}</span>
                                        <span class="item-price">${item.price} руб.</span>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </div>
                </div>
                </#if>

                <!-- Категория: Гарниры -->
                <#assign hasLunchGarnishes = false>
                <#list menuItems as item>
                    <#if item.view == "Обед" && item.category == "Гарнир">
                        <#assign hasLunchGarnishes = true>
                        <#break>
                    </#if>
                </#list>
                <#if hasLunchGarnishes>
                <div class="category">
                    <h3 class="category-title">Гарниры</h3>
                    <div class="menu-items">
                        <#list menuItems as item>
                            <#if item.view == "Обед" && item.category == "Гарнир">
                                <div class="menu-item">
                                    <div class="item-name">${item.title}</div>
                                    <div class="item-details">
                                        <span class="item-weight">${item.quantity}</span>
                                        <span class="item-price">${item.price} руб.</span>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </div>
                </div>
                </#if>

                <!-- Категория: Напитки -->
                <#assign hasLunchDrinks = false>
                <#list menuItems as item>
                    <#if item.view == "Обед" && item.category == "Напитки">
                        <#assign hasLunchDrinks = true>
                        <#break>
                    </#if>
                </#list>
                <#if hasLunchDrinks>
                <div class="category">
                    <h3 class="category-title">Напитки</h3>
                    <div class="menu-items">
                        <#list menuItems as item>
                            <#if item.view == "Обед" && item.category == "Напитки">
                                <div class="menu-item">
                                    <div class="item-name">${item.title}</div>
                                    <div class="item-details">
                                        <span class="item-weight">${item.quantity}</span>
                                        <span class="item-price">${item.price} руб.</span>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </div>
                </div>
                </#if>

                <!-- Категория: Дополнительные блюда -->
                <#assign hasLunchAdditional = false>
                <#list menuItems as item>
                    <#if item.view == "Обед" && item.category == "Дополнительные блюда">
                        <#assign hasLunchAdditional = true>
                        <#break>
                    </#if>
                </#list>
                <#if hasLunchAdditional>
                <div class="category">
                    <h3 class="category-title">Дополнительные блюда</h3>
                    <div class="menu-items">
                        <#list menuItems as item>
                            <#if item.view == "Обед" && item.category == "Дополнительные блюда">
                                <div class="menu-item">
                                    <div class="item-name">${item.title}</div>
                                    <div class="item-details">
                                        <span class="item-weight">${item.quantity}</span>
                                        <span class="item-price">${item.price} руб.</span>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </div>
                </div>
                </#if>
            </div>
        </div>
    </div>

    <script>
        // JavaScript код остается без изменений
        let streamUrl = 'diningroom/live.mjpeg';
        let streamElement = document.getElementById('stream');
        let currentStreamUrl = null;
        let streamController = null;

        function showCafeteriaTraffic() {
            const modal = document.getElementById('trafficModal');
            modal.style.display = 'flex';
            stopStream();
            streamController = new AbortController();
            currentStreamUrl = streamUrl + '?t=' + new Date().getTime();
            loadStreamWithFetch(currentStreamUrl);
            document.body.style.overflow = 'hidden';
            console.log('Stream started:', currentStreamUrl);
        }

        function loadStreamWithFetch(url) {
            fetch(url, {
                signal: streamController.signal
            })
                .then(response => {
                    if (!response.ok) throw new Error('Network response was not ok');
                    streamElement.src = url;
                })
                .catch(error => {
                    if (error.name === 'AbortError') {
                        console.log('Stream fetch aborted');
                    } else {
                        console.error('Stream fetch error:', error);
                    }
                });
        }

        function stopStream() {
            if (streamController) {
                streamController.abort();
                streamController = null;
            }

            if (currentStreamUrl) {
                streamElement.src = '';
                streamElement.src = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';
                if (streamElement.load) streamElement.load();
                if (streamElement.onload) streamElement.onload = null;
                currentStreamUrl = null;
            }

            fetch('diningroom/stopAllStreams', {
                method: 'GET',
                keepalive: true
            })
                .then(() => console.log('Server streams cleanup requested'))
                .catch(err => console.error('Error cleaning server streams:', err));
        }

        function closeModal() {
            const modal = document.getElementById('trafficModal');
            modal.style.display = 'none';
            stopStream();
            document.body.style.overflow = 'auto';
        }

        window.onclick = function(event) {
            const modal = document.getElementById('trafficModal');
            if (event.target === modal) {
                closeModal();
            }
        }

        document.onkeydown = function(evt) {
            evt = evt || window.event;
            if (evt.key === "Escape") {
                closeModal();
            }
        };

        window.addEventListener('beforeunload', function() {
            stopStream();
        });

        streamElement.addEventListener('error', function() {
            console.log('Stream connection error, stopping...');
            stopStream();
        });

        document.addEventListener('visibilitychange', function() {
            if (document.hidden) {
                console.log('Page hidden, stopping stream');
                stopStream();
            }
        });
    </script>
</@c.page>

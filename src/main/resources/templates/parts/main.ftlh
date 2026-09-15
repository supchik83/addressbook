<#macro page>
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <title>Портал ГАУ ИНПЦ "ГОРМЕДТЕХНИКА"</title>
        <link rel="stylesheet" href="/css/main.css">
        <link rel="stylesheet" href="/css/lightview.css">
        <link rel="stylesheet" href="/css/birthday.css">
        <link rel="stylesheet" href="/css/nicepage.css" media="screen">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" i
              ntegrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="shortcut icon" href="/static/img/favicon.png" />
    </head>
    <nav class="navbar navbar-expand-lg sticky-top navbar-light bg-light">
        <div class="container-fluid">
            <a class="navbar-brand" href="/">
                <img src="/img/LOGO.png" width="30" height="30" class="d-inline-block align-top" alt="">
                Портал ГАУ ИНПЦ "Гормедтехника"
            </a>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink1" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Информация о сотрудниках
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink1">
                            <a class="dropdown-item" href="/">Телефонный справочник</a>
                            <a class="dropdown-item" href="/birthday">Дни рождения</a>
                            <a class="dropdown-item" href="/new_employee">Новые сотрудники</a>
                            <a class="dropdown-item" href="/absent_employees">Отсутствующие сотрудники</a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink2" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Документы
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink2">
                            <a class="dropdown-item" href="/templates_new">Шаблоны кадровых документов</a>
                            <a class="dropdown-item" href="/lna">Локально-нормативные акты</a>
                            <a class="dropdown-item" href="/tech">Инструкции по работе в информационных системах</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="/for-new-emp">Информация для новых сотрудников</a>
                        </div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="/diningroom">Меню столовой</a>
                    </li>
                    <#--                    <li class="nav-item">-->
                    <#--                        <a class="nav-link" href="#">Новости/события</a>-->
                    <#--                    </li>-->
                    <#--                    <#if user?? && (user.contains("Служба автоматизированных систем управления и информационной безопасности"))>-->
                    <#--                    <li class="nav-item dropdown">-->
                    <#--                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink3" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">-->
                    <#--                            Сервис-->
                    <#--                        </a>-->
                    <#--                        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink3">-->
                    <#--                            <a class="dropdown-item" href="/addusers">Добавление новых пользователей</a>-->
                    <#--                            <a class="dropdown-item" href="/updateusers">Обновление данных пользователей</a>-->
                    <#--                        </div>-->
                    <#--                    </li>-->
                    <#--                    </#if>-->
                    <#--                    <li class="nav-item">-->
                    <#--                        <a class="nav-link" href="#">Наши сообщества</a>-->
                    <#--                    </li>-->
                    <#--                    <li class="nav-item">-->
                    <#--                        <a class="nav-link" href="#">Новости/события</a>-->
                    <#--                    </li>-->
                </ul>
            </div>

            <#--                <button class="btn btn-light active my-2 my-sm-0" data-bs-toggle="modal" data-bs-target="#loginModal">Вход</button>-->
            <div class="qr-container">
                <button class="qr-button" data-tooltip="Техническая поддержка ГМТ" onclick="window.open('https://support.gmtmsk.ru/portal', '_blank')">
                    <img class="p-3 " src="img\stp.png" title="">
                </button>
                <button class="qr-button" data-tooltip="Наш закрытый telegram-канал" onclick="window.open('https://t.me/gmtmsk_bot ', '_blank')">
                    <img class="p-3 " src="img\qrcode_bot.png" title="">
                </button>
                <button class="qr-button" data-tooltip="Наше спортивное сообщество" onclick="window.open('https://t.me/gmtsport25', '_blank')">
                    <img class="p-3" src="img\qrcode_sport.png">
                </button>
            </div>
        </div>
    </nav>
    <body class="u-body u-xl-mode">
    <main class="content-wrapper">
        <div class="btn-up btn-up_hide"></div>
        <#nested>
    </main>
    <script type="text/javascript" src="/js/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="/js/lightview.js"></script>
    <script type="text/javascript" src="/js/nicepage.js"></script>
    <script type="text/javascript" src="/js/bootstrap.js"></script>
    <script type="text/javascript" src="/js/main.js"></script>
    <script type="text/javascript" src="/js/loading.js"></script>
    <script type="text/javascript" src="/js/snowflakes.js"></script>
    <script>

        jQuery.event.special.touchstart = {
            setup: function(_, ns, handle) {
                this.addEventListener('touchstart', handle, { passive: true });
            }
        };

        // Добавьте также для touchmove
        jQuery.event.special.touchmove = {
            setup: function(_, ns, handle) {
                this.addEventListener('touchmove', handle, { passive: true });
            }
        };

        $(document).ready(function($) {
            $('*[data-href]').on('click', function () {
                window.location = $(this).data("href");
            });
        });

        const btnUp = {
            el: document.querySelector('.btn-up'),
            show() {
                // удалим у кнопки класс btn-up_hide
                this.el.classList.remove('btn-up_hide');
            },
            hide() {
                // добавим к кнопке класс btn-up_hide
                this.el.classList.add('btn-up_hide');
            },
            addEventListener() {
                // при прокрутке содержимого страницы
                window.addEventListener('scroll', () => {
                    // определяем величину прокрутки
                    const scrollY = window.scrollY || document.documentElement.scrollTop;
                    // если страница прокручена больше чем на 400px, то делаем кнопку видимой, иначе скрываем
                    scrollY > 400 ? this.show() : this.hide();
                });
                // при нажатии на кнопку .btn-up
                document.querySelector('.btn-up').onclick = () => {
                    // переместим в начало страницы
                    window.scrollTo({
                        top: 0,
                        left: 0,
                        behavior: 'smooth'
                    });
                }
            }
        }
        btnUp.addEventListener();
    </script>
    </body>
    <footer class="footer">
        <div class="container">
            <div class="text-center">
                <span>ГАУ ИНПЦ "Гормедтехника", 2025</span>
            </div>
        </div>
    </footer>
    </html>
</#macro>
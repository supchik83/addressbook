<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Проходная — поиск сотрудника</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
<style>
  :root{
    --bg: #f3f7f8;
    --surface: #ffffff;
    --surface-2: #edf4f5;
    --surface-3: #e0ecee;
    --border: #dbe7e9;
    --border-soft: #e7f0f1;
    --text: #16232a;
    --text-dim: #5c7076;
    --text-faint: #93a7ac;
    --accent: #00929b;
    --accent-dim: #e0f3f4;
    --accent-text: #00636b;
    --red: #c94b3f;
    --red-dim: #fbeae7;
    --green: #2d8659;
    --green-dim: #e6f3ec;
    --radius-sm: 8px;
    --radius-md: 14px;
    --font-display: 'Manrope', 'Segoe UI', sans-serif;
    --font-body: 'Inter', 'Segoe UI', sans-serif;
  }
  *{box-sizing:border-box;}
  html,body{
    margin:0; padding:0; height:100%;
    background: var(--bg);
    color: var(--text);
    font-family: var(--font-body);
    overflow:hidden;
  }
  ::selection{ background: var(--accent-dim); color: var(--accent-text); }

  #app{ display:flex; flex-direction:column; height:100vh; width:100vw; }

  header{
    display:flex; align-items:center; justify-content:space-between;
    padding: 22px 40px;
    border-bottom: 1px solid var(--border-soft);
    flex-shrink:0;
  }
  .brand{ display:flex; align-items:center; gap:14px; }
  .brand-mark{ width:46px; height:46px; flex-shrink:0; display:block; }
  .brand-text .org{ font-family: var(--font-display); font-weight:700; font-size:17px; letter-spacing:0.2px; line-height:1.2; }
  .brand-text .sub{ font-size:13px; color: var(--text-dim); margin-top:2px; }
  .clock{ text-align:right; font-family:var(--font-display); }
  .clock .time{ font-size:28px; font-weight:700; font-variant-numeric: tabular-nums; letter-spacing:0.5px; }
  .clock .date{ font-size:13px; color: var(--text-dim); font-family: var(--font-body); margin-top:2px; text-transform:capitalize; }

  .search-zone{ padding: 28px 40px 18px; flex-shrink:0; }
  .search-box{ position:relative; max-width: 900px; margin: 0 auto 18px; }
  .search-box input{
    width:100%; height:68px;
    background: var(--surface);
    border: 1.5px solid var(--border);
    border-radius: var(--radius-md);
    color: var(--text);
    font-size: 24px;
    font-family: var(--font-display);
    font-weight:600;
    padding: 0 60px 0 60px;
    outline:none;
    transition: border-color .15s ease;
  }
  .search-box input::placeholder{ color: var(--text-faint); font-weight:500; }
  .search-box input:focus{ border-color: var(--accent); box-shadow: 0 0 0 4px var(--accent-dim); }
  .search-box svg.icon-search{ position:absolute; left:22px; top:50%; transform: translateY(-50%); width:24px; height:24px; stroke: var(--text-faint); }
  .clear-btn{
    position:absolute; right:16px; top:50%; transform: translateY(-50%);
    width:40px; height:40px; border-radius:50%; border:none;
    background: var(--surface-2); color: var(--text-dim); font-size:20px; cursor:pointer;
    display:none; align-items:center; justify-content:center;
  }
  .clear-btn.show{ display:flex; }
  .clear-btn:active{ background: var(--surface-3); }

  .results-wrap{ flex:1; overflow-y:auto; padding: 10px 40px 30px; }
  .results-grid{
    max-width: 1180px; margin: 0 auto;
    display:grid; grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)); gap:14px;
  }
  .card{
    background: var(--surface);
    border: 1px solid var(--border-soft);
    border-left: 4px solid var(--dept-color, var(--accent));
    border-radius: var(--radius-sm);
    padding: 16px 18px;
    display:flex; flex-direction:column; gap:12px;
    height:100%;
  }
  .card-top{ display:flex; gap:14px; align-items:flex-start; }
  .avatar{
    width:52px; height:52px; border-radius:50%;
    background: var(--dept-color, var(--accent)); color: #ffffff;
    display:flex; align-items:center; justify-content:center;
    font-family: var(--font-display); font-weight:800; font-size:17px; flex-shrink:0;
  }
  .card-info{ min-width:0; flex:1; }
  .card-name{ font-family: var(--font-display); font-weight:700; font-size:17px; line-height:1.25; margin:0 0 4px; }
  .card-role{ font-size:14px; color: var(--text-dim); margin:0 0 10px; }
  .card-meta{ display:flex; flex-direction:column; align-items:flex-start; gap:6px; }
  .tag{
    font-size:12.5px; font-weight:600; padding:4px 10px; border-radius:6px;
    background: var(--surface-2); color: var(--text-dim);
    white-space:normal; line-height:1.35; max-width: 100%;
  }
  .presence{ display:inline-flex; align-items:center; gap:6px; font-size:12.5px; font-weight:600; padding:4px 10px 4px 8px; border-radius:6px; }
  .presence-dot{ width:7px; height:7px; border-radius:50%; flex-shrink:0; }
  .presence.in{ background: var(--green-dim); color: var(--green); }
  .presence.in .presence-dot{ background: var(--green); }
  .presence.out{ background: var(--surface-2); color: var(--text-dim); }
  .presence.out .presence-dot{ background: var(--text-faint); }

  .phone-row{
    display:flex; align-items:center; gap:10px;
    padding: 10px 12px; background: var(--accent-dim); border-radius: var(--radius-sm);
    margin-top:auto;
  }
  .phone-row svg{ width:20px; height:20px; stroke: var(--accent-text); flex-shrink:0; }
  .phone-row .phone-label{ font-size:12px; color: var(--accent-text); font-weight:600; margin:0 0 1px; }
  .phone-row .phone-number{
    font-family: var(--font-display); font-size:24px; font-weight:800; color: var(--accent-text);
    font-variant-numeric: tabular-nums; letter-spacing:1px; line-height:1.1;
  }

  .empty{ max-width: 480px; margin: 60px auto 0; text-align:center; color: var(--text-dim); }
  .empty svg{ width:56px; height:56px; stroke: var(--text-faint); margin-bottom:18px; }
  .empty .t1{ font-family: var(--font-display); font-weight:700; font-size:19px; color: var(--text); margin-bottom:8px; }
  .empty .t2{ font-size:14.5px; line-height:1.5; }

  footer{
    flex-shrink:0; display:flex; align-items:center; justify-content:space-between;
    padding: 14px 40px; border-top: 1px solid var(--border-soft); font-size:14px; color: var(--text-dim);
  }
  footer .count b{ color: var(--text); font-weight:700; }
  footer .hint{ color: var(--text-faint); }

  .results-wrap::-webkit-scrollbar{ width:8px; }
  .results-wrap::-webkit-scrollbar-thumb{ background: var(--surface-3); border-radius:8px; }

  @media (max-width: 640px){
    header, .search-zone, .results-wrap, footer{ padding-left:18px; padding-right:18px; }
    .search-box input{ font-size:19px; height:58px; padding-left:52px; }
    .clock .time{ font-size:22px; }
    footer{ flex-direction:column; gap:6px; align-items:flex-start; }
  }
</style>
</head>
<body>
<div id="app">

  <header>
    <div class="brand">
      <img class="brand-mark" src="/img/LOGO.png" alt="Логотип Гормедтехника">
      <div class="brand-text">
        <div class="org">Гормедтехника</div>
        <div class="sub">Информационный киоск для посетителей</div>
      </div>
    </div>
    <div class="clock">
      <div class="time" id="clock-time">--:--</div>
      <div class="date" id="clock-date">—</div>
    </div>
  </header>

  <div class="search-zone">
    <div class="search-box">
      <svg class="icon-search" viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="7"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
      <input id="search-input" type="text" placeholder="Фамилия сотрудника или название подразделения" autocomplete="off" autofocus>
      <button class="clear-btn" id="clear-btn" aria-label="Очистить">&times;</button>
    </div>
  </div>

  <div class="results-wrap">
    <div class="results-grid" id="results-grid"></div>
    <div class="empty" id="empty-state" style="display:none;">
      <svg viewBox="0 0 24 24" fill="none" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="7"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
      <div class="t1">Сотрудник не найден</div>
      <div class="t2">Проверьте написание фамилии или введите название подразделения. Если сотрудник действительно работает в организации, обратитесь к охране на входе.</div>
    </div>
  </div>

  <footer>
    <div class="count">Найдено: <b id="count-num">0</b> сотрудников</div>
    <div class="hint">Найдите сотрудника и уточните номер кабинета и внутренний телефон</div>
  </footer>

</div>

<script>
// Данные подставлены сервером (Spring MVC + FreeMarker) из модели "employees" —
// см. AddressBookController#kiosk и ru.gmtmsk.addressbook.data.Employee.
// Признак "lack" используется только как флаг присутствия/отсутствия.
<#noautoesc>
const EMPLOYEES = [
<#list employees as emp>
  {
    name: "${emp.name?js_string}",
    role: "${(emp.position!"")?js_string}",
    dept: "${(emp.department!"Без отдела")?js_string}",
    room: "${(emp.office!"")?js_string}",
    phone: "${(emp.innerPhone!"")?js_string}",
    present: <#if (emp.lack!"")?trim == "">true<#else>false</#if>
  }<#if emp?has_next>,</#if>
</#list>
];
</#noautoesc>

const PALETTE = ["#375a7f","#00929b","#c9781e","#7a54c9","#2d8659","#a67c3d","#3e9b8a","#b8483d","#4f6b52","#8a4f7d"];
function colorForDept(name){
  let hash = 0;
  for (let i = 0; i < name.length; i++){ hash = (hash * 31 + name.charCodeAt(i)) >>> 0; }
  return PALETTE[hash % PALETTE.length];
}
function initials(fullName){
  const parts = fullName.trim().split(/\s+/);
  return (parts[0]?.[0] || "") + (parts[1]?.[0] || "");
}

let query = "";

const grid = document.getElementById("results-grid");
const emptyState = document.getElementById("empty-state");
const countNum = document.getElementById("count-num");
const input = document.getElementById("search-input");
const clearBtn = document.getElementById("clear-btn");

function matches(emp){
  if(!query) return true;
  const q = query.toLowerCase();
  return emp.name.toLowerCase().split(/\s+/).some(part => part.startsWith(q)) ||
         emp.name.toLowerCase().includes(q) ||
         emp.dept.toLowerCase().includes(q);
}

function el(tag, className, text){
  const node = document.createElement(tag);
  if(className) node.className = className;
  if(text !== undefined) node.textContent = text;
  return node;
}

function buildCard(emp){
  const color = colorForDept(emp.dept);

  const card = el("div", "card");
  card.style.setProperty("--dept-color", color);

  const top = el("div", "card-top");
  const avatar = el("div", "avatar", initials(emp.name));
  avatar.style.background = color;

  const info = el("div", "card-info");
  info.appendChild(el("p", "card-name", emp.name));
  info.appendChild(el("p", "card-role", emp.role));

  const meta = el("div", "card-meta");
  meta.appendChild(el("span", "tag", emp.dept));
  if(emp.room){
    meta.appendChild(el("span", "tag", "Каб. №" + emp.room));
  }

  const presence = el("span", "presence " + (emp.present ? "in" : "out"));
  presence.appendChild(el("span", "presence-dot"));
  presence.appendChild(document.createTextNode(emp.present ? "В офисе" : "Отсутствует"));
  meta.appendChild(presence);

  info.appendChild(meta);
  top.appendChild(avatar);
  top.appendChild(info);

  const phoneRow = el("div", "phone-row");
  phoneRow.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.362 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.338 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>';
  const phoneText = el("div");
  phoneText.appendChild(el("p", "phone-label", "Внутренний телефон"));
  phoneText.appendChild(el("p", "phone-number", emp.phone));
  phoneRow.appendChild(phoneText);

  card.appendChild(top);
  card.appendChild(phoneRow);
  return card;
}

function render(){
  const list = EMPLOYEES.filter(matches);
  grid.innerHTML = "";
  countNum.textContent = list.length;

  if(list.length === 0){
    emptyState.style.display = "block";
    grid.style.display = "none";
    return;
  }
  emptyState.style.display = "none";
  grid.style.display = "grid";

  list.forEach(emp => grid.appendChild(buildCard(emp)));
}

input.addEventListener("input", () => {
  query = input.value.trim();
  clearBtn.classList.toggle("show", query.length > 0);
  render();
});
clearBtn.addEventListener("click", () => {
  input.value = "";
  query = "";
  clearBtn.classList.remove("show");
  input.focus();
  render();
});

function tickClock(){
  const now = new Date();
  const time = now.toLocaleTimeString("ru-RU", { hour: "2-digit", minute: "2-digit" });
  const date = now.toLocaleDateString("ru-RU", { weekday: "long", day: "numeric", month: "long" });
  document.getElementById("clock-time").textContent = time;
  document.getElementById("clock-date").textContent = date;
}
tickClock();
setInterval(tickClock, 1000 * 15);

render();
</script>
</body>
</html>

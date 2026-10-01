package ru.gmtmsk.addressbook.controller;

import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.MailException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ru.gmtmsk.addressbook.config.PassRequestForm;
import ru.gmtmsk.addressbook.service.PassRequestService;

// import java.security.Principal; // НА ВЫРОСТ: заявитель из Spring Security (см. requesterName ниже)
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Заказ временного пропуска для посетителей и автотранспорта.
 * Страница: GET /pass-request, отправка формы: POST /pass-request.
 * Заявитель (ФИО и e-mail) вводится в форме.
 */
@Controller
@RequestMapping("/pass-request")
public class PassRequestController {

    private static final Logger log = LoggerFactory.getLogger(PassRequestController.class);

    /** Ключ общей (не привязанной к полю) ошибки в карте errors, которую читает шаблон. */
    private static final String GLOBAL = "_global";

    private final PassRequestService service;

    public PassRequestController(PassRequestService service) {
        this.service = service;
    }

    @GetMapping
    public String form(Model model /*, Principal principal */) {
        PassRequestForm form = new PassRequestForm();
        form.getVisitors().add(new PassRequestForm.VisitorForm()); // одна пустая строка посетителя

        // ---- НА ВЫРОСТ: заявитель из авторизации ---------------------------------------------
        // Когда на портале появится вход, можно подставлять заявителя автоматически
        // (и добавить параметр Principal principal в сигнатуру метода):
        // form.setRequesterName(requesterName(principal));
        // --------------------------------------------------------------------------------------

        model.addAttribute("form", form);
        model.addAttribute("errors", Map.of());

        // ---- НА ВЫРОСТ: список «Мои заявки» -------------------------------------------------
        // Раскомментировать вместе с PassRequestService#findByRequesterEmail и блоком «Мои заявки»
        // в шаблоне pass-request.ftlh (нужно включить хранение заявок в БД).
        // Пока нет авторизации, список можно строить только по e-mail из формы.
        // model.addAttribute("myRequests", service.findByRequesterEmail(email));
        // -------------------------------------------------------------------------------------
        return "pass-request";
    }

    @PostMapping
    public String submit(@Valid @ModelAttribute("form") PassRequestForm form,
                         BindingResult binding,
                         Model model,
                         RedirectAttributes redirect /*, Principal principal */) {

        if (binding.hasErrors()) {
            model.addAttribute("errors", toErrorMap(binding));
            return "pass-request";
        }

        try {
            service.submit(form);
        } catch (MailException e) {
            log.error("Не удалось отправить заявку на пропуск", e);
            model.addAttribute("errors", Map.of(GLOBAL,
                    "Не удалось отправить заявку. Введённые данные сохранены в форме — "
                            + "повторите отправку позже или обратитесь в техническую поддержку."));
            return "pass-request";
        }

        // Post/Redirect/Get: обновление страницы не отправит заявку повторно
        redirect.addFlashAttribute("success", "Заявка отправлена. Ответ службы придёт на указанный адрес электронной почты.");
        return "redirect:/pass-request";
    }

    // ---- НА ВЫРОСТ: список «Мои заявки» отдельной страницей (если понадобится) -----------------
    // @GetMapping("/my")
    // public String myRequests(Model model, Principal principal) {
    //     model.addAttribute("myRequests", service.findByRequesterEmail(/* e-mail или логин из principal */));
    //     return "pass-requests-my";
    // }
    // -------------------------------------------------------------------------------------------

    // ---- НА ВЫРОСТ: определение заявителя через Spring Security --------------------------------
    // Сейчас заявителя вводит сам пользователь. Если на портале включат авторизацию,
    // имя можно брать из Principal (логин AD/LDAP); если пользователь хранится иначе
    // (например, в сессии), замените реализацию.
    // private String requesterName(Principal principal) {
    //     return principal != null ? principal.getName() : "не определён";
    // }
    // -------------------------------------------------------------------------------------------

    /** Преобразует ошибки валидации в карту «путь поля → сообщение» для шаблона. */
    private Map<String, String> toErrorMap(BindingResult binding) {
        Map<String, String> errors = new LinkedHashMap<>();
        for (FieldError fe : binding.getFieldErrors()) {
            String message = fe.isBindingFailure()
                    ? "Некорректное значение — проверьте формат"
                    : fe.getDefaultMessage();
            errors.putIfAbsent(fe.getField(), message);
        }
        if (binding.hasGlobalErrors()) {
            errors.put(GLOBAL, binding.getGlobalErrors().stream()
                    .map(ObjectError::getDefaultMessage)
                    .collect(Collectors.joining(". ")));
        }
        return errors;
    }
}

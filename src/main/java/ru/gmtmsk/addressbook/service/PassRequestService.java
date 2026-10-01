package ru.gmtmsk.addressbook.service;

import org.springframework.stereotype.Service;
import ru.gmtmsk.addressbook.config.PassRequestForm;

// import java.util.List;                       // НА ВЫРОСТ (БД)
// import org.springframework.mail.MailException; // НА ВЫРОСТ (БД)

@Service
public class PassRequestService {

    private final PassMailService mailService;

    // ---- НА ВЫРОСТ: хранение заявок в БД --------------------------------------------------
    // private final PassRequestRepository repository;
    //
    // public PassRequestService(PassMailService mailService, PassRequestRepository repository) {
    //     this.mailService = mailService;
    //     this.repository = repository;
    // }
    // ---------------------------------------------------------------------------------------

    public PassRequestService(PassMailService mailService) { // при включении БД — удалить этот конструктор
        this.mailService = mailService;
    }

    /**
     * Принимает заявку: отправляет письмо (и, когда включим БД, сохраняет заявку).
     * Метод намеренно БЕЗ @Transactional: запись в БД должна остаться, даже если письмо не ушло.
     */
    public void submit(PassRequestForm form) {

        mailService.send(form); // при включении БД — удалить эту строку и раскомментировать блок ниже

        // ---- НА ВЫРОСТ: сохранение заявки + статус отправки ---------------------------------
        // PassRequest entity = repository.save(PassRequest.from(form)); // статус NEW
        // try {
        //     mailService.send(form);
        //     entity.setStatus(PassRequest.Status.SENT);
        // } catch (MailException e) {
        //     entity.setStatus(PassRequest.Status.SEND_FAILED); // заявка не потеряна, её можно отправить повторно
        //     throw e;
        // } finally {
        //     repository.save(entity);
        // }
        // -------------------------------------------------------------------------------------
    }

    // ---- НА ВЫРОСТ: список «Мои заявки» -----------------------------------------------------
    // Пока на портале нет авторизации, заявки ищутся по e-mail заявителя. Это не защита:
    // любой может ввести чужой адрес. Когда появится вход (Principal), искать по логину.
    // public List<PassRequest> findByRequesterEmail(String email) {
    //     return repository.findByRequesterEmailIgnoreCaseOrderByCreatedAtDesc(email);
    // }
    // ---------------------------------------------------------------------------------------
}

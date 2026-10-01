package ru.gmtmsk.addressbook.data;

// =====================================================================================
// НА ВЫРОСТ: хранение заявок в БД. Весь файл закомментирован.
//
// Чтобы включить:
//   1. Добавить зависимость spring-boot-starter-data-jpa и драйвер вашей СУБД.
//   2. Раскомментировать этот файл и PassRequestRepository.java.
//   3. В PassRequestService переключить submit() и findByRequester() (там всё помечено).
//   4. В PassRequestController и pass-request.ftlh раскомментировать «Мои заявки».
//   5. Создать таблицы (Flyway/Liquibase или spring.jpa.hibernate.ddl-auto=update на тесте):
//        pass_request, pass_request_visitor (автомобиль хранится в строке посетителя).
//   6. Getters/setters у сущности и вложенных классов — Lombok (@Getter/@Setter) или IDE.
//      Они нужны и JPA, и шаблону «Мои заявки».
// =====================================================================================

/*
import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Embeddable;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Table;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "pass_request")
public class PassRequest {

    public enum Status {
        NEW("Создана"),
        SENT("Отправлена"),
        SEND_FAILED("Ошибка отправки"); // заявка сохранена, письмо не ушло — можно повторить

        private final String title;
        Status(String title) { this.title = title; }
        public String getTitle() { return title; }
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "requester_name", nullable = false, length = 150)
    private String requesterName;

    @Column(name = "requester_email", nullable = false, length = 254)
    private String requesterEmail;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Status status = Status.NEW;

    @ElementCollection
    @CollectionTable(name = "pass_request_visitor", joinColumns = @JoinColumn(name = "request_id"))
    private List<Visitor> visitors = new ArrayList<>();

    @Embeddable
    public static class Visitor {
        @Column(name = "full_name", nullable = false, length = 150) private String fullName;
        @Column(nullable = false, length = 300)                     private String purpose;
        @Column(name = "arrival_at", nullable = false)              private LocalDateTime arrivalAt;
        @Column(name = "departure_at", nullable = false)            private LocalDateTime departureAt;

        @Enumerated(EnumType.STRING)
        @Column(name = "travel_mode", nullable = false, length = 10)
        private PassRequestForm.TravelMode travelMode;              // ON_FOOT / BY_CAR

        @Column(name = "car_brand", length = 100)                   private String carBrand;   // только при BY_CAR
        @Column(name = "car_plate", length = 12)                    private String carPlate;   // только при BY_CAR

        // getters/setters
        public boolean isByCar() { return travelMode == PassRequestForm.TravelMode.BY_CAR; }
    }

    // Собирает сущность из формы.
    public static PassRequest from(PassRequestForm form) {
        PassRequest r = new PassRequest();
        r.requesterName = form.getRequesterName();
        r.requesterEmail = form.getRequesterEmail();
        for (PassRequestForm.VisitorForm f : form.getVisitors()) {
            Visitor v = new Visitor();
            v.setFullName(f.getFullName());
            v.setPurpose(f.getPurpose());
            v.setArrivalAt(f.getArrivalAt());
            v.setDepartureAt(f.getDepartureAt());
            v.setTravelMode(f.getTravelMode());
            v.setCarBrand(f.isByCar() ? f.getCarBrand() : null);
            v.setCarPlate(f.isByCar() ? f.getCarPlate() : null);
            r.visitors.add(v);
        }
        return r;
    }

    // Дата подачи для таблицы «Мои заявки».
    public String getCreatedAtText() {
        return createdAt.format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm"));
    }

    // getters/setters: id, requesterName, requesterEmail, createdAt, status, visitors
}
*/

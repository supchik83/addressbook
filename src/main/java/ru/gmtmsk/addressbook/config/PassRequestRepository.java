package ru.gmtmsk.addressbook.config;

// НА ВЫРОСТ: хранение заявок в БД. Раскомментировать вместе с PassRequest.java
// (инструкция — в шапке PassRequest.java).

// import org.springframework.data.jpa.repository.JpaRepository;
//
// import java.util.List;
//
// public interface PassRequestRepository extends JpaRepository<PassRequest, Long> {
//
//     // Для списка «Мои заявки»: новые сверху.
//     // Коллекции visitors/vehicles ленивые и читаются в шаблоне: это работает, пока включён
//     // spring.jpa.open-in-view (по умолчанию true). Если его отключат — добавить в PassRequest
//     // @Fetch(FetchMode.SUBSELECT) на обе коллекции. Не использовать @EntityGraph сразу на
//     // две List-коллекции: Hibernate выбросит MultipleBagFetchException.
//     List<PassRequest> findByRequesterEmailIgnoreCaseOrderByCreatedAtDesc(String email);
// }

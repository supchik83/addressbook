package ru.gmtmsk.addressbook.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.util.HtmlUtils;
import ru.gmtmsk.addressbook.config.PassRequestForm;

import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * Формирует и отправляет письмо с заявкой на пропуск.
 * Ошибки отправки выбрасываются как org.springframework.mail.MailException.
 */
@Service
public class PassMailService {

    private static final DateTimeFormatter DT = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm");

    private final JavaMailSender mailSender;
    private final String[] to;
    private final String from;

    public PassMailService(JavaMailSender mailSender,
                           @Value("${pass.mail.to}") String[] to,      // через запятую: a@x.ru,b@x.ru
                           @Value("${pass.mail.from}") String from) {
        this.mailSender = mailSender;
        this.to = to;
        this.from = from;
    }

    public void send(PassRequestForm form) {
        String subject = "Заявка на временный пропуск: посетителей — " + form.getVisitors().size()
                + ", на автомобиле — " + form.getVisitorsWithCar().size();
        String html = buildHtml(form);

        mailSender.send(message -> {
            MimeMessageHelper helper = new MimeMessageHelper(message, false, StandardCharsets.UTF_8.name());
            helper.setFrom(from);
            helper.setTo(to);
            helper.setReplyTo(form.getRequesterEmail()); // ответ службы пропусков уйдёт заявителю
            helper.setSubject(subject); // только числа — пользовательский ввод в тему не попадает
            helper.setText(html, true);
        });
    }

    private String buildHtml(PassRequestForm form) {
        StringBuilder sb = new StringBuilder();
        sb.append("<div style=\"font-family:Arial,sans-serif;font-size:14px;color:#1f2933\">");
        sb.append("<p>Заявитель: <b>").append(esc(form.getRequesterName())).append("</b><br>")
          .append("Электронная почта: ").append(esc(form.getRequesterEmail())).append("<br>")
          .append("Подана: ").append(LocalDateTime.now().format(DT)).append("</p>");

        List<String[]> visitorRows = new ArrayList<>();
        for (PassRequestForm.VisitorForm v : form.getVisitors()) {
            visitorRows.add(new String[]{v.getFullName(), v.getPurpose(),
                    fmt(v.getArrivalAt()), fmt(v.getDepartureAt()), v.getTravelMode().getTitle()});
        }
        appendTable(sb, "Посетители",
                new String[]{"ФИО", "Цель визита", "Прибытие", "Убытие", "Как прибудет"}, visitorRows);

        // Отдельная таблица для КПП: автомобили с привязкой к посетителю. Время — как у посетителя.
        List<PassRequestForm.VisitorForm> withCar = form.getVisitorsWithCar();
        if (!withCar.isEmpty()) {
            List<String[]> carRows = new ArrayList<>();
            for (PassRequestForm.VisitorForm v : withCar) {
                carRows.add(new String[]{v.getCarBrand(), v.getCarPlate(), v.getFullName(),
                        fmt(v.getArrivalAt()), fmt(v.getDepartureAt())});
            }
            appendTable(sb, "Автотранспорт",
                    new String[]{"Марка", "Госномер", "Посетитель", "Въезд", "Выезд"}, carRows);
        }

        return sb.append("</div>").toString();
    }

    private void appendTable(StringBuilder sb, String title, String[] head, List<String[]> rows) {
        String cell = "border:1px solid #d7dce2;padding:6px 10px;text-align:left;";
        sb.append("<h3 style=\"margin:18px 0 6px\">").append(title).append("</h3>");
        sb.append("<table style=\"border-collapse:collapse\"><tr>");
        for (String h : head) {
            sb.append("<th style=\"").append(cell).append("background:#eef6f5\">").append(h).append("</th>");
        }
        sb.append("</tr>");
        for (String[] row : rows) {
            sb.append("<tr>");
            for (String value : row) {
                sb.append("<td style=\"").append(cell).append("\">").append(esc(value)).append("</td>");
            }
            sb.append("</tr>");
        }
        sb.append("</table>");
    }

    private String fmt(LocalDateTime t) {
        return t == null ? "" : t.format(DT);
    }

    /** Весь пользовательский ввод экранируется — в письмо не попадёт чужая разметка. */
    private String esc(String s) {
        return s == null ? "" : HtmlUtils.htmlEscape(s);
    }
}

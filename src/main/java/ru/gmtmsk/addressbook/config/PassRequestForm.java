package ru.gmtmsk.addressbook.config;

import jakarta.validation.Valid;
import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Форма заявки на временный пропуск.
 * В заявке один заявитель и несколько посетителей. Каждый посетитель прибывает
 * пешком или на автомобиле; автомобиль (марка и госномер) относится к своему посетителю
 * и въезжает/выезжает в те же дату и время, что и он.
 * Для Spring Boot 2.x замените jakarta.validation.* на javax.validation.*
 */
public class PassRequestForm {

    // ------------------------------------------------------------------
    // Заявитель (тот, кто заказывает пропуск и кому придёт ответ)
    // ------------------------------------------------------------------
    @NotBlank(message = "Укажите ФИО заявителя")
    @Size(max = 150, message = "ФИО — не более 150 символов")
    @Pattern(regexp = "^[\\p{L}][\\p{L}\\s.'’-]*$",
            message = "ФИО может содержать только буквы, пробелы, точку, дефис и апостроф")
    private String requesterName;

    @NotBlank(message = "Укажите адрес электронной почты")
    @Size(max = 254, message = "Адрес — не более 254 символов")
    @Email(regexp = "^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", message = "Введите адрес в формате name@example.ru")
    private String requesterEmail;

    @Valid
    @NotEmpty(message = "Добавьте хотя бы одного посетителя")
    @Size(max = 20, message = "В одной заявке не более 20 посетителей")
    private List<VisitorForm> visitors = new ArrayList<>();

    public String getRequesterName() { return requesterName; }
    public void setRequesterName(String requesterName) { this.requesterName = squeeze(requesterName); }

    public String getRequesterEmail() { return requesterEmail; }
    public void setRequesterEmail(String requesterEmail) {
        this.requesterEmail = requesterEmail == null ? null : requesterEmail.trim();
    }

    public List<VisitorForm> getVisitors() { return visitors; }
    public void setVisitors(List<VisitorForm> visitors) { this.visitors = visitors; }

    /** Посетители, приезжающие на автомобиле (для письма). */
    public List<VisitorForm> getVisitorsWithCar() {
        return visitors.stream().filter(VisitorForm::isByCar).toList();
    }

    // ------------------------------------------------------------------
    // Как прибудет посетитель
    // ------------------------------------------------------------------
    public enum TravelMode {
        ON_FOOT("Пешком"),
        BY_CAR("На автомобиле");

        private final String title;

        TravelMode(String title) { this.title = title; }

        public String getTitle() { return title; }
    }

    // ------------------------------------------------------------------
    // Общая часть: период пребывания
    // ------------------------------------------------------------------
    public abstract static class PassPeriod {

        /** Формат значения для <input type="datetime-local"> */
        private static final DateTimeFormatter INPUT_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

        @NotNull(message = "Укажите дату и время прибытия")
        @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
        private LocalDateTime arrivalAt;

        @NotNull(message = "Укажите дату и время убытия")
        @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
        private LocalDateTime departureAt;

        public LocalDateTime getArrivalAt() { return arrivalAt; }
        public void setArrivalAt(LocalDateTime arrivalAt) { this.arrivalAt = arrivalAt; }

        public LocalDateTime getDepartureAt() { return departureAt; }
        public void setDepartureAt(LocalDateTime departureAt) { this.departureAt = departureAt; }

        @AssertTrue(message = "Прибытие не может быть раньше сегодняшней даты")
        public boolean isArrivalNotInPast() {
            return arrivalAt == null || !arrivalAt.toLocalDate().isBefore(LocalDate.now());
        }

        @AssertTrue(message = "Убытие должно быть позже прибытия")
        public boolean isPeriodValid() {
            return arrivalAt == null || departureAt == null || departureAt.isAfter(arrivalAt);
        }

        /** Значения для повторного заполнения полей формы (шаблон). */
        public String getArrivalInput() {
            return arrivalAt == null ? "" : arrivalAt.format(INPUT_FORMAT);
        }

        public String getDepartureInput() {
            return departureAt == null ? "" : departureAt.format(INPUT_FORMAT);
        }
    }

    // ------------------------------------------------------------------
    // Посетитель (при необходимости — с автомобилем)
    // ------------------------------------------------------------------
    public static class VisitorForm extends PassPeriod {

        // Буквы, допустимые в российских госномерах (есть и в кириллице, и в латинице)
        private static final String CYRILLIC = "АВЕКМНОРСТУХ";
        private static final String LATIN    = "ABEKMHOPCTYX";

        /** Формат: Е123ВХ 977 (регион 3 цифры) или Е123ВХ 77 (регион 2 цифры). */
        private static final java.util.regex.Pattern PLATE =
                java.util.regex.Pattern.compile("^[АВЕКМНОРСТУХ]\\d{3}[АВЕКМНОРСТУХ]{2} \\d{2,3}$");

        @NotBlank(message = "Укажите ФИО")
        @Size(max = 150, message = "ФИО — не более 150 символов")
        @Pattern(regexp = "^[\\p{L}][\\p{L}\\s.'’-]*$",
                message = "ФИО может содержать только буквы, пробелы, точку, дефис и апостроф")
        private String fullName;

        @NotBlank(message = "Укажите цель посещения")
        @Size(max = 300, message = "Цель — не более 300 символов")
        private String purpose;

        private TravelMode travelMode = TravelMode.ON_FOOT;

        // Поля автомобиля обязательны только при travelMode = BY_CAR (проверки — в методах ниже).
        // Пустые значения хранятся как null.
        @Size(max = 100, message = "Марка — не более 100 символов")
        private String carBrand;

        private String carPlate;

        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = squeeze(fullName); }

        public String getPurpose() { return purpose; }
        public void setPurpose(String purpose) { this.purpose = squeeze(purpose); }

        public TravelMode getTravelMode() { return travelMode; }
        public void setTravelMode(TravelMode travelMode) {
            this.travelMode = travelMode == null ? TravelMode.ON_FOOT : travelMode;
        }

        public String getCarBrand() { return carBrand; }
        public void setCarBrand(String carBrand) { this.carBrand = blankToNull(squeeze(carBrand)); }

        public String getCarPlate() { return carPlate; }
        public void setCarPlate(String carPlate) { this.carPlate = blankToNull(normalizePlate(carPlate)); }

        /** Приезжает на автомобиле (используется и шаблоном, и письмом). */
        public boolean isByCar() { return travelMode == TravelMode.BY_CAR; }

        @AssertTrue(message = "Укажите марку автомобиля")
        public boolean isCarBrandFilled() { return !isByCar() || carBrand != null; }

        @AssertTrue(message = "Укажите госномер")
        public boolean isCarPlateFilled() { return !isByCar() || carPlate != null; }

        @AssertTrue(message = "Формат номера: Е123ВХ 977 или Е123ВХ 77 (регион — 2 или 3 цифры)")
        public boolean isCarPlateFormatValid() {
            return !isByCar() || carPlate == null || PLATE.matcher(carPlate).matches();
        }

        /** Верхний регистр, латиница → кириллица, без пробелов, затем пробел перед регионом. */
        static String normalizePlate(String raw) {
            if (raw == null) {
                return null;
            }
            StringBuilder sb = new StringBuilder();
            for (char ch : raw.toUpperCase(Locale.ROOT).toCharArray()) {
                if (Character.isWhitespace(ch)) {
                    continue;
                }
                int i = LATIN.indexOf(ch);
                sb.append(i >= 0 ? CYRILLIC.charAt(i) : ch);
            }
            String s = sb.toString();
            // 6 символов «буква-3 цифры-2 буквы» + регион из 2 или 3 цифр
            return (s.length() == 8 || s.length() == 9) ? s.substring(0, 6) + " " + s.substring(6) : s;
        }
    }

    /** Обрезает пробелы по краям и схлопывает повторяющиеся внутри. */
    private static String squeeze(String s) {
        return s == null ? null : s.trim().replaceAll("\\s+", " ");
    }

    private static String blankToNull(String s) {
        return s == null || s.isBlank() ? null : s;
    }
}

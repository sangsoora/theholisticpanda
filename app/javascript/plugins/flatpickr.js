import flatpickr from "flatpickr";
require("flatpickr/dist/themes/dark.css");
flatpickr(".timepicker", {
  enableTime: true,
  disableMobile: "true",
  noCalendar: true,
  dateFormat: "H:i",
  minuteIncrement: 30,
  time_24hr: true
});

flatpickr(".datepicker", {
  enableTime: false,
  dateFormat: "M d, Y",
  minDate: new Date().setDate(new Date().getDate() + 1)
});

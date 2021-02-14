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

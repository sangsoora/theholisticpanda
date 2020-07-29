import flatpickr from "flatpickr";
require("flatpickr/dist/themes/dark.css");
flatpickr(".datepicker", {
  enableTime: true,
  disableMobile: "true",
  dateFormat: "d-m-Y H:i",
  minuteIncrement: 10,
  minDate: "today",
  defaultDate: new Date(),
  position: "below"
});
flatpickr(".timepicker", {
  enableTime: true,
  disableMobile: "true",
  noCalendar: true,
  dateFormat: "H:i",
  minuteIncrement: 10,
  defaultDate: new Date()
});

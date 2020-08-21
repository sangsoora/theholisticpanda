import flatpickr from "flatpickr";
require("flatpickr/dist/themes/dark.css");
flatpickr(".datepicker", {
  enableTime: true,
  disableMobile: "true",
  dateFormat: "d-m-Y H:i",
  minuteIncrement: 15,
  minDate: "today",
  defaultDate: new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate(), 0,0,0,0)
});
flatpickr(".timepicker", {
  enableTime: true,
  disableMobile: "true",
  noCalendar: true,
  dateFormat: "H:i",
  minuteIncrement: 15,
  defaultDate: new Date()

});

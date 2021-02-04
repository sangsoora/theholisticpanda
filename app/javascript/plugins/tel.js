import intlTelInput from 'intl-tel-input';
import utilsScript from 'intl-tel-input/build/js/utils.js';
import 'intl-tel-input/build/css/intlTelInput.css';

const initIntlTelInput = () => {
  if (document.getElementById('user_phone_number')) {
    const input = document.getElementById('user_phone_number');
    const errorMsg = document.getElementById('tel-error-msg');
    const validMsg = document.getElementById('tel-valid-msg');
    var errorMap = ["Invalid number", "Invalid country code", "Too short", "Too long", "Invalid number"];
    var iti = intlTelInput(input, {
      formatOnInit: true,
      separateDialCode: true,
      initialCountry: "ca",
      preferredCountries: ["ca", "us"],
      utilsScript
    });

    var reset = function() {
      input.classList.remove("error");
      errorMsg.innerHTML = "";
      errorMsg.classList.add("hidden");
      validMsg.classList.add("hidden");
    };

    // on blur: validate
    input.addEventListener('blur', function() {
      reset();
      if (input.value.trim()) {
        if (iti.isValidNumber()) {
          validMsg.classList.remove("hidden");
          document.getElementById('validated_number').value = iti.getNumber();
        } else {
          input.classList.add("error");
          var errorCode = iti.getValidationError();
          errorMsg.innerHTML = errorMap[errorCode];
          errorMsg.classList.remove("hidden");
          document.getElementById('validated_number').value = '';
        }
      }
    });

    // on keyup / change flag: reset
    input.addEventListener('change', reset);
    input.addEventListener('keyup', reset);

  }
}

export { initIntlTelInput };

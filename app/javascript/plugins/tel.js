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
  if (document.getElementById('user_phone_number_1')) {
    const input1 = document.getElementById('user_phone_number_1');
    const errorMsg1 = document.getElementById('tel-error-msg-1');
    const validMsg1 = document.getElementById('tel-valid-msg-1');
    var errorMap1 = ["Invalid number", "Invalid country code", "Too short", "Too long", "Invalid number"];
    var iti1 = intlTelInput(input1, {
      formatOnInit: true,
      separateDialCode: true,
      initialCountry: "ca",
      preferredCountries: ["ca", "us"],
      utilsScript
    });

    var reset1 = function() {
      input1.classList.remove("error");
      errorMsg1.innerHTML = "";
      errorMsg1.classList.add("hidden");
      validMsg1.classList.add("hidden");
    };

    // on blur: validate
    input1.addEventListener('blur', function() {
      reset1();
      if (input1.value.trim()) {
        if (iti1.isValidNumber()) {
          validMsg1.classList.remove("hidden");
          document.getElementById('validated_number_1').value = iti1.getNumber();
        } else {
          input1.classList.add("error");
          var errorCode1 = iti1.getValidationError();
          errorMsg1.innerHTML = errorMap1[errorCode1];
          errorMsg1.classList.remove("hidden");
          document.getElementById('validated_number_1').value = '';
        }
      }
    });

    // on keyup / change flag: reset
    input1.addEventListener('change', reset1);
    input1.addEventListener('keyup', reset1);
  }
}

export { initIntlTelInput };

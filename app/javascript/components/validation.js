const initValidation = () => {
  if (document.getElementById('old-password')) {
    if (document.getElementById('password1')) {
      const input = document.getElementById('password1');
      const confirm = document.getElementById('password2');
      const inputMsg = document.getElementsByClassName('text-muted')[1];
      const confirmMsg = document.getElementsByClassName('text-muted')[2];
      input.addEventListener('blur', (e)=> {
        if (!new RegExp(/.{8,}/).test(input.value)) {
          inputMsg.innerText = 'Password should have more than 8 characters.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[\d])[\d]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 lowercase, 1 uppercase and 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        }  else if (new RegExp(/^(?=.*[a-z])(?=.*[\d])[a-z\d]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 uppercase and 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[\d])(?=.*[@$!%*?&])[\d@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 lowercase and 1 uppercase.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[A-Z])(?=.*[\d])[A-Z\d]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 lowercase and 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])(?=.*[\d])(?=.*[@$!%*?&])[a-z\d@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 uppercase.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[\d])[a-zA-Z\d]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[A-Z])(?=.*[\d])(?=.*[@$!%*?&])[A-Z\d@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 lowercase.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])[a-z]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 number, 1 uppercase and 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])(?=.*[A-Z])[a-zA-Z]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 number and 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])(?=.*[@$!%*?&])[a-z@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 number and 1 uppercase.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[@$!%*?&])[a-zA-Z@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Too short';
          inputMsg.setAttribute('style', 'color: red !important');
          inputMsg.innerText = 'Password should have at least 1 number.';
        } else if (new RegExp(/^(?=.*[A-Z])[A-Z]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 number, 1 lowercase and 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[A-Z])(?=.*[@$!%*?&])[A-Z@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 number and 1 lowercase.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[@$!%*?&])[@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 number, 1 lowercase and 1 uppercase.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = '';
          if (confirm.value != '') {
            if (input.value != confirm.value) {
              confirmMsg.innerText = 'Passwords don\'t match.';
              confirmMsg.setAttribute('style', 'color: red !important');
            } else {
              confirmMsg.innerText = '';
            }
          }
        }
      })
      confirm.addEventListener('blur', (e) => {
        if (input.value != confirm.value) {
          confirmMsg.innerText = 'Passwords don\'t match.';
          confirmMsg.setAttribute('style', 'color: red !important');
        } else {
          confirmMsg.innerText = '';
        }
      })
    }
  } else {
    if (document.getElementById('password1')) {
      const input = document.getElementById('password1');
      const confirm = document.getElementById('password2');
      const inputMsg = document.getElementsByClassName('text-muted')[0];
      const confirmMsg = document.getElementsByClassName('text-muted')[1];
      input.addEventListener('blur', (e)=> {
        if (!new RegExp(/.{8,}/).test(input.value)) {
          inputMsg.innerText = 'Password should have more than 8 characters.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[\d])[\d]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 lowercase, 1 uppercase and 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        }  else if (new RegExp(/^(?=.*[a-z])(?=.*[\d])[a-z\d]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 uppercase and 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[\d])(?=.*[@$!%*?&])[\d@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 lowercase and 1 uppercase.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[A-Z])(?=.*[\d])[A-Z\d]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 lowercase and 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])(?=.*[\d])(?=.*[@$!%*?&])[a-z\d@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 uppercase.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[\d])[a-zA-Z\d]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[A-Z])(?=.*[\d])(?=.*[@$!%*?&])[A-Z\d@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 lowercase.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])[a-z]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 number, 1 uppercase and 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])(?=.*[A-Z])[a-zA-Z]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 number and 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])(?=.*[@$!%*?&])[a-z@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 number and 1 uppercase.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[@$!%*?&])[a-zA-Z@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Too short';
          inputMsg.setAttribute('style', 'color: red !important');
          inputMsg.innerText = 'Password should have at least 1 number.';
        } else if (new RegExp(/^(?=.*[A-Z])[A-Z]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 number, 1 lowercase and 1 special character.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[A-Z])(?=.*[@$!%*?&])[A-Z@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 number and 1 lowercase.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[@$!%*?&])[@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = 'Password should have at least 1 number, 1 lowercase and 1 uppercase.';
          inputMsg.setAttribute('style', 'color: red !important');
        } else if (new RegExp(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/).test(input.value)) {
          inputMsg.innerText = '';
          if (confirm.value != '') {
            if (input.value != confirm.value) {
              confirmMsg.innerText = 'Passwords don\'t match.';
              confirmMsg.setAttribute('style', 'color: red !important');
            } else {
              confirmMsg.innerText = '';
            }
          }
        }
      })
      confirm.addEventListener('blur', (e) => {
        if (input.value != confirm.value) {
          confirmMsg.innerText = 'Passwords don\'t match.';
          confirmMsg.setAttribute('style', 'color: red !important');
        } else {
          confirmMsg.innerText = '';
        }
      })
    }
  }
}

export { initValidation };

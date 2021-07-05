const initShowPassword = () => {
  if (document.querySelectorAll('.password-control')) {
    document.querySelectorAll('.password-control').forEach((eye) => {
      eye.addEventListener('click', (e) => {
        let el = eye.previousElementSibling;
        if (el.type === 'password') {
           eye.innerText = 'Hide password';
           el.type = 'text';
        } else {
           eye.innerText = 'Show password';
           el.type = 'password';
        }
      })
    });
  }
}

export { initShowPassword };

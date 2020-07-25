const initUpdateApplicationForm = () => {
  const form = document.getElementById('new_practitioner');
  if (form) {
    $(".language-choice").click(function(){
      $(this).toggleClass("active");
    });
    $(".specialty-choice").click(function(){
      $(this).toggleClass("active");
    });
  }
}

export { initUpdateApplicationForm };

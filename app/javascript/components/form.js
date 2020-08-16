const initUpdateForm = () => {
  const form = document.getElementById('new_practitioner');
  if (form) {
    $(".language-choice").click(function(){
      $(this).toggleClass("active");
    });
    $(".specialty-choice").click(function(){
      $(this).toggleClass("active");
    });
  }
  const specialtiesForm = document.getElementById('specialties_form');
  if (specialtiesForm) {
    $('.specialty-choice').on("click", function (e){
      const active = document.querySelector('.active');
      e.currentTarget.classList.toggle('active');
      if (active !== null) {
        active.classList.remove('active');
      }
    });
  }
  const languagesForm = document.getElementById('languages_form');
  if (languagesForm) {
    $('.language-choice').on("click", function (e){
      const active = document.querySelector('.active');
      e.currentTarget.classList.toggle('active');
      if (active !== null) {
        active.classList.remove('active');
      }
    });
  }
  const workingdaysForm = document.getElementById('workingdays_form');
  if (workingdaysForm) {
    $(".workingday-choice").click(function(){
      $(this).toggleClass("active");
    });
  }
  const filterForm = document.getElementById('filter-form');
  if (filterForm) {
    $(".language-choice").click(function(){
      if ($(this).hasClass("active")) {
        $(this).removeClass("active");
        $('#language-' + $(this)[0].previousElementSibling.value).remove();
      } else {
        $(this).addClass("active");
        $( "#selected-languages" ).append( "<p id='language-" + $(this)[0].previousElementSibling.value + "'>" + $(this)[0].innerText + "</p>" );
      }
    });
    $(".specialty-choice").click(function(){
      if ($(this).hasClass("active")) {
        $(this).removeClass("active");
        $('#specialty-' + $(this)[0].previousElementSibling.value).remove();
        if ( $('#selected-specialties').children().length === 0 ) {
          $("#health-goal-selector").removeClass('hidden');
        }
      } else {
        $(this).addClass("active");
        $( "#selected-specialties" ).append( "<p id='specialty-" + $(this)[0].previousElementSibling.value + "'>" + $(this)[0].innerText + "</p>" );
        if (!$("#health-goal-selector").hasClass('hidden')) {
          $("#health-goal-selector").addClass('hidden');
        }
      }
    });
    $(".health-goal-choice").click(function(){
      if ($(this).hasClass("active")) {
        $(this).removeClass("active");
        $('#health-goal-' + $(this)[0].previousElementSibling.value).remove();
        if ( $('#selected-health-goals').children().length === 0 ) {
          $("#specialty-selector").removeClass('hidden');
        }
      } else {
        $(this).addClass("active");
        $( "#selected-health-goals" ).append( "<p id='health-goal-" + $(this)[0].previousElementSibling.value + "'>" + $(this)[0].innerText + "</p>" );
        if (!$("#specialty-selector").hasClass('hidden')) {
          $("#specialty-selector").addClass('hidden');
        }
      }
    });
  }

}

export { initUpdateForm };

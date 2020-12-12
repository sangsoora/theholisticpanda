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
  const healthgoalsForm = document.getElementById('healthgoals_form');
  if (healthgoalsForm) {
    $('.health-goal-choice').on("click", function (e){
      const active = document.querySelector('.active');
      e.currentTarget.classList.toggle('active');
      if (active !== null) {
        active.classList.remove('active');
      }
    });
  }
  const filterForm = document.getElementById('filter-form');
  if (filterForm) {
    $(".language-choice").click(function(){
      if ($(this).hasClass("active")) {
        $(this).removeClass("active");
        document.getElementById('language-pop').innerText = 'Languages (' + $('.language-choice.active').length + ')'
        if ( $('.language-choice.active').length === 0 ) {
          document.getElementById('language-pop').innerText = 'Languages'
        }
      } else {
        $(this).addClass("active");
        document.getElementById('language-pop').innerText = 'Languages (' + $('.language-choice.active').length + ')'
      }
    });
    $(".specialty-choice").click(function(){
      if ($(this).hasClass("active")) {
        $(this).removeClass("active");
        document.getElementById('specialty-pop').innerText = 'Specialties (' + $('.specialty-choice.active').length + ')'
        if ( $('.specialty-choice.active').length === 0 ) {
          document.getElementById('specialty-pop').innerText = 'Specialties'
        }
      } else {
        $(this).addClass("active");
        document.getElementById('specialty-pop').innerText = 'Specialties (' + $('.specialty-choice.active').length + ')'

      }
    });

  }
  const topFilterForm = document.getElementById('top-filter-form');
  if (topFilterForm) {
    $(".health-goal-choice").click(function(){
      if ($(this).hasClass("active")) {
        $(this).removeClass("active");
        healthGoalSelectBoxBtn.innerHTML = 'Health Goals (' + $('.health-goal-choice.active').length + ')&nbsp;&nbsp;<i class="fas fa-chevron-down"></i>'
        if ( $('.health-goal-choice.active').length === 0 ) {
          healthGoalSelectBoxBtn.innerHTML = 'Choose Health Goals&nbsp;&nbsp;<i class="fas fa-chevron-down"></i>'
        }
      } else {
        $(this).addClass("active");
        healthGoalSelectBoxBtn.innerHTML = 'Health Goals (' + $('.health-goal-choice.active').length + ')&nbsp;&nbsp;<i class="fas fa-chevron-down"></i>'
      }
    });
  }
}

export { initUpdateForm };

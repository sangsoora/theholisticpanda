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
          $("#condition-selector").removeClass('hidden');
        }
      } else {
        $(this).addClass("active");
        $( "#selected-specialties" ).append( "<p id='specialty-" + $(this)[0].previousElementSibling.value + "'>" + $(this)[0].innerText + "</p>" );
        if (!$("#condition-selector").hasClass('hidden')) {
          $("#condition-selector").addClass('hidden');
        }
      }
    });
    $(".condition-choice").click(function(){
      if ($(this).hasClass("active")) {
        $(this).removeClass("active");
        $('#condition-' + $(this)[0].previousElementSibling.value).remove();
        if ( $('#selected-conditions').children().length === 0 ) {
          $("#specialty-selector").removeClass('hidden');
        }
      } else {
        $(this).addClass("active");
        $( "#selected-conditions" ).append( "<p id='condition-" + $(this)[0].previousElementSibling.value + "'>" + $(this)[0].innerText + "</p>" );
        if (!$("#specialty-selector").hasClass('hidden')) {
          $("#specialty-selector").addClass('hidden');
        }
      }
    });
  }

}

export { initUpdateForm };

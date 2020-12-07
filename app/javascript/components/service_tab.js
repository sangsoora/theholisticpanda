const initServiceTab = () => {
  $(".jobs-wrapper").on("click",".cat",function(e){
    $(".cat").removeClass("active");
    $(this).addClass("active");
  });
}

export { initServiceTab };

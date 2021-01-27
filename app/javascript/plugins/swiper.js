import Swiper from 'swiper/bundle';
// import Swiper styles
import 'swiper/swiper-bundle.css';

const initSpecialtySwiper = () => {
  if (document.getElementById('explore-specialties')) {
    var mySwiper = new Swiper('.swiper-container', {
    // Optional parameters
      slidesPerView: 7,
      slidesPerGroup: 7,
      loop: true,
      loopFillGroupWithBlank: false,

      // Navigation arrows
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },

      // And if we need scrollbar
      scrollbar: {
        el: '.swiper-scrollbar',
      },
    });
  }
};

export { initSpecialtySwiper };

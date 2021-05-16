import Swiper from 'swiper/bundle';
// import Swiper styles
import 'swiper/swiper-bundle.css';

const initSwiper = () => {
  if (document.getElementById('explore-specialties-desktop')) {
    var mySwiper = new Swiper('#explore-specialties-desktop', {
    // Optional parameters
      slidesPerView: 6,
      slidesPerGroup: 6,
      loop: true,
      loopFillGroupWithBlank: false,

      // Navigation arrows
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
      autoplay: {
        delay: 6000,
        disableOnInteraction: false,
      },

      // And if we need scrollbar
      scrollbar: {
        el: '.swiper-scrollbar',
      },
    });
  }
  if (document.getElementById('explore-specialties-mobile')) {
    var mySwiper = new Swiper('#explore-specialties-mobile', {
    // Optional parameters
      slidesPerView: 4,
      slidesPerGroup: 4,
      loop: true,
      loopFillGroupWithBlank: false,

      // Navigation arrows
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
      autoplay: {
        delay: 6000,
        disableOnInteraction: false,
      },

      // And if we need scrollbar
      scrollbar: {
        el: '.swiper-scrollbar',
      },
    });
  }
  if (document.getElementById('practitioners-swiper')) {
    var mySwiper = new Swiper('#practitioners-swiper', {
    // Optional parameters
      autoplay: {
        delay: 4000,
        disableOnInteraction: false,
      },
      loop: true,
      // Navigation arrows

      // And if we need scrollbar
      scrollbar: {
        el: '.swiper-scrollbar',
      },
    });
  }
};

export { initSwiper };

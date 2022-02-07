import Swiper from 'swiper/bundle';
// import Swiper styles
import 'swiper/swiper-bundle.css';

const initSwiper = () => {
  if (document.getElementById('explore-specialties-desktop')) {
    var specialtiesDesktopSwiper = new Swiper('#explore-specialties-desktop', {
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
    });
  }
  if (document.getElementById('explore-specialties-mobile')) {
    var specialtiesMobileSwiper = new Swiper('#explore-specialties-mobile', {
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
    });
  }
  if (document.getElementById('practitioners-swiper')) {
    var practitionersSwiper = new Swiper('#practitioners-swiper', {
    // Optional parameters
      autoplay: {
        delay: 4000,
        disableOnInteraction: false,
      },
      loop: true,
    });
  }
  if (document.getElementById('blog-banner-swiper')) {
    var blogSwiper = new Swiper('#blog-banner-swiper', {
    // Optional parameters
      autoplay: {
        delay: 6000,
        disableOnInteraction: true,
      },
      loop: true,
      // Navigation arrows
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
    });
  }
  if (document.getElementById('offer-slider-desktop')) {
    var offerDesktopSwiper = new Swiper('#offer-slider-desktop', {
      spaceBetween: 14,
      slidesPerView: 5,
      loop:true,
      speed: 45000,
      preloadImages: false,
    });
    function infinite() {
        offerDesktopSwiper.slideTo(offerDesktopSwiper.slides.length);
        offerDesktopSwiper.once('transitionEnd', function(){
            offerDesktopSwiper.slideTo(offerDesktopSwiper.params.slidesPerView, 0, false);
            setTimeout(function () {
                infinite();
            }, 0);
        });
    }
    infinite();
  }
  if (document.getElementById('offer-slider-mobile')) {
    var offerMobileSwiper = new Swiper('#offer-slider-mobile', {
      spaceBetween: 20,
      slidesPerView: 2,
      slidesPerGroup: 2,
      loop: true,
      loopFillGroupWithBlank: false,
      autoplay: {
        delay: 6000,
        disableOnInteraction: true,
      },
    });
  }
  if (document.getElementById('community-slider')) {
    var communitySwiper = new Swiper('#community-slider', {
      autoplay: {
        delay: 12000,
        disableOnInteraction: false,
      },
      speed: 1500,
      loop: true,
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
    });
  }
};

export { initSwiper };

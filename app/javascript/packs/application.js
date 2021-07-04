/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
import 'bootstrap';
import '../plugins/flatpickr';
import "cropperjs/dist/cropper.css";
import '../plugins/swiper';
import '../plugins/tel';

import { initOpenSideNavbar } from '../components/navbar';
import { initSwiper } from '../plugins/swiper';
import { initUpdateForm } from '../components/form';
import { previewImageOnFileSelect } from '../components/image_cropper';
import { initConversationScroll } from '../components/conversation_scroll';
import { previewBannerOnFileSelect } from '../components/banner_upload';
import { initIntlTelInput } from '../plugins/tel';
import { initValidation } from '../components/validation';
import { initShowPassword } from '../components/show_password';
// document.addEventListener("scroll", () => {
//   // Call your JS functions here
// });

document.addEventListener('DOMContentLoaded', () => {
  initOpenSideNavbar();
  initUpdateForm();
  previewImageOnFileSelect();
  initConversationScroll();
  previewBannerOnFileSelect();
  initSwiper();
  initIntlTelInput();
  initValidation();
  initShowPassword();
  $(function() {
    setTimeout(function(){
      $('.alert').slideUp(500);
    }, 2000);
  });
});

// document.addEventListener('turbolinks:load', () => {
//   initUpdateForm();
//   previewImageOnFileSelect();
//   initConversationScroll();
// });

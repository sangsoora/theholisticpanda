const initUpdateNavbarOnScroll = () => {
  const navbar = document.querySelector('.navbar-holistic');
  if (navbar) {
    window.addEventListener('scroll', () => {
      if (window.scrollY >= window.innerHeight) {
        navbar.classList.add('navbar-holistic-white');
      } else {
        navbar.classList.remove('navbar-holistic-white');
      }
    });
  }
}

export { initUpdateNavbarOnScroll };

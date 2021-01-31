const initOpenSideNavbar = () => {
  const open = document.getElementById("open-side");
  const close = document.getElementById("close-side");
  open.addEventListener('click', e => {
    document.getElementById("side-nav").style.width = "100vw";
  })
  close.addEventListener('click', e => {
    document.getElementById("side-nav").style.width = "0";
  });
}

export { initOpenSideNavbar };

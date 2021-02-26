const bannerCanvas  = document.getElementById('banner-canvas');
const bannerPreview = document.getElementById('banner-preview');

const dataURLtoFile = (dataurl, filename) => {
  let arr = dataurl.split(','),
      mime = arr[0].match(/:(.*?);/)[1],
      bstr = atob(arr[1]),
      n = bstr.length,
      u8arr = new Uint8Array(n);

  while(n--){
      u8arr[n] = bstr.charCodeAt(n);
  }

  return new File([u8arr], filename, {type:mime});
}

const displayBannerPreview = (input) => {
  if (input.files && input.files[0]) {
    const bannerReader = new FileReader();
    bannerReader.onload = (e) => {
      const context = bannerCanvas.getContext("2d");
      const img = new Image();
      img.onload = () => {
        context.canvas.height = img.height;
        context.canvas.width  = img.width;
        context.drawImage(img, 0, 0);

        document.getElementById("btnBannerUpload").disabled = false;
      };
      img.src = e.currentTarget.result;
    }
    bannerReader.readAsDataURL(input.files[0]);
  }
}
const previewBannerOnFileSelect = () => {
  let input = document.getElementById('banner-input');
  if (input) {
    input.addEventListener('change', () => {
      displayBannerPreview(input);
    })
  }
}
export { previewBannerOnFileSelect };

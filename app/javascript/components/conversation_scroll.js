const initConversationScroll = () => {

  $(document).ready(function() {
    var conversationbox = document.getElementById('conversationbox');
    var messages = $('#conversationbox');

    if (conversationbox) {
      function init() {
        messages.scrollTop(messages[0].scrollHeight);
      }
      window.setTimeout(init, 50);
    }
  });
}

export { initConversationScroll };

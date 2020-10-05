if (document.getElementById('conversationbox')) {
  var id = document.getElementById('conversationbox').dataset.conversationid;

  App.conversation = App.cable.subscriptions.create({ channel: "ConversationChannel", id: id }, {

    connected: function() {},

    disconnected: function() {},

    received: function(data) {
      var conversationbox = $('#conversationbox');
      var message = data['message'];
      var userId = $(conversationbox).attr('data-userId');
      var senderId = $(message).attr('data-senderId');

      var messageDiv = document.createElement('div');
      messageDiv.innerHTML = message;
      if (conversationbox) {
        if (userId === senderId) {
          messageDiv.classList.add('my-message-bubble','my-msg');
          var messageOuterDiv = document.createElement('div');
          messageOuterDiv.classList.add('col-8','offset-4','d-flex','justify-content-end');
          messageOuterDiv.appendChild(messageDiv);
        } else {
          messageDiv.classList.add('other-message-bubble','other-msg');
          var messageOuterDiv = document.createElement('div');
          messageOuterDiv.classList.add('col-8','d-flex');
          messageOuterDiv.appendChild(messageDiv);
        }
        conversationbox.append(messageOuterDiv);
        conversationbox.scrollTop(conversationbox[0].scrollHeight);
      }
    }
  });
}


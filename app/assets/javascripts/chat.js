document.addEventListener("DOMContentLoaded", () => {
    const chatMessages = document.getElementById('chat-messages');
    const chatForm = document.getElementById('chat-form');
    const messageInput = document.getElementById('message-input');
  
    // Initialize Action Cable connection
    const cable = ActionCable.createConsumer('/cable');
  
    // Subscribe to the chat channel
    const chatChannel = cable.subscriptions.create('ChatChannel', {
      received: function(data) {
        chatMessages.insertAdjacentHTML('beforeend', `<div>${data.message}</div>`);
        chatMessages.scrollTop = chatMessages.scrollHeight;
      }
    });
  
    // Submit message form
    chatForm.addEventListener('submit', function(event) {
      event.preventDefault();
      const messageContent = messageInput.value.trim();
      if (messageContent !== '') {
        chatChannel.send({ message: messageContent });
        messageInput.value = '';
      }
    });
  });
  
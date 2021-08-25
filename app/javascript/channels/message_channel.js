import consumer from "./consumer"

window.addEventListener('load', () => {
  console.log('message channel');
  const el_messages = document.getElementById('messages');
  if (!el_messages) { return; }

  console.log('message channel create');
  consumer.subscriptions.create('MessageChannel', {
    connected() {
      console.log('connected!!!');
    },

    disconnected() {
      console.log('disconnected!!!');
    },

    received(res) {
      const message = JSON.parse(res.data);
      console.log(message);

      const el_message = document.getElementById('message_template').content.cloneNode(true);
      el_message.querySelector('.user-name').textContent = message.user.name;
      el_message.querySelector('.message').textContent = message.content;
      el_messages.insertAdjacentElement('afterbegin', el_message.children[0]);
    }
  });
});

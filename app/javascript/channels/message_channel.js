import consumer from "./consumer"

window.addEventListener('load', () => {
  console.log('message channel');
  const el_messages = document.getElementById('messages');
  if (!el_messages) { return; }

  const el_message_template = document.getElementById('message_template');
  const current_user_name = document.getElementById('current_user_name').textContent;
  const room_hashid = location.pathname.split('/').pop();

  console.log('message channel create');
  const channel = consumer.subscriptions.create({
    channel: 'MessageChannel',
    room_hashid: room_hashid,
  }, {
    connected() {
      console.log('connected!!!');
      // channel.send({ sent_by: "Paul", body: "This is a cool chat app." });
      const el_message = el_message_template.content.cloneNode(true);
      el_message.querySelector('.user-name').textContent = 'master';
      el_message.querySelector('.message').textContent = `ようこそ、${current_user_name}さん！`;
      el_messages.insertAdjacentElement('afterbegin', el_message.children[0]);
    },

    disconnected() {
      console.log('disconnected!!!');
      // location.href = '/';
    },

    received(res) {
      const message = JSON.parse(res.data);
      console.log(message);

      const el_message = el_message_template.content.cloneNode(true);
      el_message.querySelector('.user-name').textContent = message.user.name;
      el_message.querySelector('.message').textContent = message.content;
      el_messages.insertAdjacentElement('afterbegin', el_message.children[0]);
    }
  });
});

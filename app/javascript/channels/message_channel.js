import consumer from "./consumer"

window.addEventListener('load', () => {
  console.log('message channel');
  const el_messages = document.getElementById('messages');
  if (!el_messages) { return; }

  // room, current_userの情報取得
  const room_hashid = location.pathname.split('/').pop();
  const current_user_name = document.getElementById('current_user_name').textContent;

  // メッセージ送信
  axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : document.getElementsByName('csrf-token')[0]?.content
  };
  const el_message_text_field = document.getElementById('message_text_field');
  document.getElementById('message_send_btn').addEventListener('click', (e) => {
    e.preventDefault();
    console.log('click!');
    const formData = new FormData(document.getElementById('message_form'));
    axios.post(`/rooms/${room_hashid}/messages`, formData)
          .then(res => {
            el_message_text_field.value = '';// 送信成功したらメッセージ欄を空にする
          })
          .catch(error => {
            alert('エラーが発生しました');
          });
  });

  // リアルタイムメッセージ受信
  const el_message_template = document.getElementById('message_template');
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

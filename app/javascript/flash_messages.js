function hideFlashMessages() {
  const flashMessages = document.querySelectorAll('.alert');
  flashMessages.forEach(message => {
      setTimeout(() => {
          message.classList.add('fade'); // CSSでフェードアウト効果を定義してください。
          setTimeout(() => {
              message.remove(); // フェードアウト後、要素を削除します。
          }, 500); // フェードアウトの持続時間
      }, 3000); // メッセージが表示されてから消えるまでの時間
  });
}

// ページが完全にロードされた後にフラッシュメッセージを隠す処理を実行します。
document.addEventListener('DOMContentLoaded', hideFlashMessages);
document.addEventListener('turbo:load', hideFlashMessages); // Turboを使用している場合

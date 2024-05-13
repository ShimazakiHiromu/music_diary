document.addEventListener('DOMContentLoaded', () => {
    const flashMessages = document.querySelectorAll('.alert');
  
    flashMessages.forEach(message => {
      setTimeout(() => {
        message.classList.add('fade');
        setTimeout(() => {
          message.remove();
        }, 500); // CSSのフェードアウトアニメーションの時間（0.5秒）
      }, 3000); // 3秒後にメッセージを消す
    });
  });

document.addEventListener('DOMContentLoaded', hideFlashMessages);
document.addEventListener('turbo:load', hideFlashMessages); // Turbo対応
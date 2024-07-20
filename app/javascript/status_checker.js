document.addEventListener('DOMContentLoaded', function() {
    const videoStatusCheckers = document.querySelectorAll('.videoStatusChecker');
    const redirectUrl = videoStatusCheckers[0] ? videoStatusCheckers[0].dataset.redirectUrl : null;

    if (videoStatusCheckers.length === 0 && redirectUrl) {
        window.location.href = redirectUrl;
        return;
    }

    let checkInterval = 2000;  // チェック間隔を2秒に設定
    let errorCount = 0;  // エラーカウントを初期化

    function checkVideoStatus() {
        Promise.all(Array.from(videoStatusCheckers).map(container => {
            return fetch(container.dataset.checkUrl)
                .then(response => response.json())
                .then(data => {
                    // ステータスに応じたUIの更新
                    if (data.status === 'converted') {
                        container.textContent = '変換完了！ビデオを再生できます。';
                    } else if (data.status === 'processing') {
                        container.textContent = '変換中...';
                    }
                    return data;
                })
                .catch(error => {
                    console.error('Error fetching video status:', error);
                    throw error;  // エラーを投げて次のcatchブロックで捕捉
                });
        })).then(results => {
            const allConverted = results.every(data => data.status === 'converted');
            if (allConverted && redirectUrl) {
                window.location.href = redirectUrl;  // すべて変換済みならリダイレクト
            } else {
                setTimeout(checkVideoStatus, checkInterval);  // 未完了なら再チェック
            }
        }).catch(error => {
            if (++errorCount > 3) {  // 3回以上エラーが発生した場合
                alert('ビデオステータスのチェックに問題が発生しました。ページをリロードしてください。');
            } else {
                setTimeout(checkVideoStatus, checkInterval);  // エラー発生時も再チェック
            }
        });
    }

    checkVideoStatus();  // 初回実行
});

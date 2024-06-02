document.addEventListener('DOMContentLoaded', function() {
    const videoStatusCheckers = document.querySelectorAll('.videoStatusChecker');
    const redirectUrl = videoStatusCheckers[0] ? videoStatusCheckers[0].dataset.redirectUrl : null;

    // ビデオが0件の場合、即座にリダイレクト
    if (videoStatusCheckers.length === 0 && redirectUrl) {
        window.location.href = redirectUrl;
        return;
    }

    let checkInterval = 2000; // チェック間隔を2秒に設定

    function checkVideoStatus() {
        Promise.all(Array.from(videoStatusCheckers).map(container => {
            const checkUrl = container.dataset.checkUrl;
            return fetch(checkUrl).then(response => response.json());
        })).then(results => {
            const allConverted = results.every(data => data.status === 'converted');
            if (allConverted && redirectUrl) {
                window.location.href = redirectUrl; // すべて変換済みならリダイレクト
            } else {
                setTimeout(checkVideoStatus, checkInterval); // 未完了なら再チェック
            }
        }).catch(error => {
            console.error('Error fetching video status:', error);
            setTimeout(checkVideoStatus, checkInterval); // エラー発生時も再チェック
        });
    }

    checkVideoStatus(); // 初回実行
});

import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import interactionPlugin from '@fullcalendar/interaction'; // 日付クリック等のインタラクション用

document.addEventListener("turbo:load", function() {
  var calendarEl = document.getElementById('calendar');
  if (!calendarEl) return; // カレンダーの要素がない場合は何もしない

  var diaryDates = JSON.parse(calendarEl.dataset.dates); // 日記の日付データを取得

  var calendar = new Calendar(calendarEl, {
    plugins: [ dayGridPlugin, interactionPlugin ],
    initialView: 'dayGridMonth',
    locale: 'ja',
    events: diaryDates.map(date => ({
      title: '🎵',
      start: date,
      display: 'background'
    })),
    dateClick: function(info) {
      // 日付クリック時の処理
      window.location.href = `/diaries/date/${info.dateStr}`;  // サーバーにリクエストを送る
    }
  });
  calendar.render();
});

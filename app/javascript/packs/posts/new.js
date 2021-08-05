$(function(){
  function buildCountRehabilitationForm(n) { //追加するフォームのhtml
    const html = 
      `<li class="count-${n}">
        <input name="rehabilitations[${n}][name]" placeholder="例）スクワット" type="text" id="rehabilitations_name" />
        <input name="rehabilitations[${n}][count]" placeholder="30" type="text" id="rehabilitations_count" />
        <label for="rehabilitations_counts">Counts</label>
        <button type="button" id="delete-count-rehabilitation-btn">削除</button>
      </li>`;
    return html;
  }

  function buildTimeRehabilitationForm(n) {  
    const html = 
      `<li class="time-${n}">
        <input name="rehabilitations[${n}][name]" placeholder="例）ランニング" type="text" id="rehabilitations_name" />
        <input name="rehabilitations[${n}][time]" placeholder="5" type="text" id="rehabilitations_time" />
        <label for="rehabilitations_minutes">Minutes</label>
        <button type="button" id="delete-time-rehabilitation-btn">削除</button>
      </li>`;
    return html;
  }

  let num = 0 //フォームに付ける番号
  let countIndex = []; //numを格納する配列
  let timeIndex = []; //numを格納する配列

  $("#add-count-rehabilitation-btn").on("click", function() { //フォーム追加ボタンのクリックでイベント発火
    if (countIndex.length + timeIndex.length > 9) return; //フォームを追加できる最大数は10
    $("#count-rehabilitation-form").append(buildCountRehabilitationForm(num)); //フォームを作成
    if (countIndex.length) $(`.count-${countIndex.slice(-1)[0]}`).children('button').remove(); //フォームの追加が2回目以降の場合、前のフォームの削除ボタンを削除
    countIndex.push(num)
    num++;
  })

  $("#add-time-rehabilitation-btn").on("click", function() {
    if (countIndex.length + timeIndex.length > 9) return;
    $("#time-rehabilitation-form").append(buildTimeRehabilitationForm(num)); 
    if (timeIndex.length) $(`.time-${timeIndex.slice(-1)[0]}`).children('button').remove();
    timeIndex.push(num)
    num++;
  })

  $("#count-rehabilitation-form").on("click", "#delete-count-rehabilitation-btn", function() { //フォーム削除ボタンのクリックでイベント発火
    $(this).parent().remove(); //フォームを削除
    countIndex.pop(); //配列の最後を削除
    $(`.count-${countIndex.slice(-1)[0]}`).append(`<button type="button" id="delete-count-rehabilitation-btn">削除</button>`); //最後のフォームにボタンを追加
  })

  $("#time-rehabilitation-form").on("click", "#delete-time-rehabilitation-btn", function() { 
    $(this).parent().remove();
    timeIndex.pop();
    $(`.time-${timeIndex.slice(-1)[0]}`).append(`<button type="button" id="delete-time-rehabilitation-btn">削除</button>`);
  })
})
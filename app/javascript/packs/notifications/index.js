$(function(){
  $(".close-box").on("click", function() { //フォーム削除ボタンのクリックでイベント発火
    $("#notifications-box").html(""); //boxを空にする
  })
})
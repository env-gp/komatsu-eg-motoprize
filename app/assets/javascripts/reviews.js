// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
document.addEventListener('turbolinks:load', function() {

  document.querySelectorAll('.delete').forEach(function(a) {
    a.addEventListener('ajax:success', function() {
        var td = a.parentNode;
        var tr = td.parentNode;
        tr.style.display = 'none';
    });
  });

  document.getElementById('btn-evaluation').onclick = function() {
    var result = window.confirm('レビューコメントに入力されている内容が削除されますが、よろしいですか？');
    if ( result ) {
      document.getElementById('review_body').value = '【デザイン】\n【エンジン性能】\n【走行性能】\n【乗り心地】\n【取り回し】\n【燃費】\n【価格】\n【総評】'
      document.getElementById('evaluation_item').disabled = true;
    }
  };
});

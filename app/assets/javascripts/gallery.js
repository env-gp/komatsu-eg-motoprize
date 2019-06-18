$(document).on('turbolinks:load', function() {
  $(function() {
    $('.gallery').each(function(){
      $(this).magnificPopup({
        delegate: 'a',
        type:'image',
        gallery: {
          enabled: true
        }
      });
    });
  });
});
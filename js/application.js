$.domReady(function () {
  $('.btn--twitter').bind('click', function(e) {
    var width  = 575,
        height = 400,
        url    = this.href,
        opts   = 'status=1' +
                 ',width='  + width  +
                 ',height=' + height;

    window.open(url, 'twitter', opts);

    e.preventDefault();
    return false;
  });
});
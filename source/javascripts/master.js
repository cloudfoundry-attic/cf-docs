$(document).ready(function(){
  $('a#search').click(function () {
    $('#organization_bar .navbar .nav>li a').css("padding","11px 20px 8px");
    $('#organization_bar .navbar .nav>li a#docs').css("padding","14px 20px");
    $('#organization_bar .navbar .nav>li a#search2').css("padding","11px 10px 8px");
    $('#search-on').show();
    $('#search-off').hide();
  });
  $('.cancel-x').click(function () {
    $('#organization_bar .navbar .nav>li a').css("padding","11px 63px 8px");
    $('#organization_bar .navbar .nav>li a#docs').css("padding","14px 20px");
    $('#organization_bar .navbar .nav>li a#search2, #organization_bar .navbar .nav>li a#search').css("padding","16px 20px 15px");
    $('#organization_bar .navbar .nav>li a#getinvolved').css("padding","11px 92px 8px");
    $('#organization_bar .navbar .nav>li#docs-off .docs-list-list a').css("padding","0"); 
    $('#search-on').hide();
    $('#search-off').show();
  });
  $('#docs-list, #docs-off, a#docs').mouseenter(function () {
    $('#icon-docs').css("background-position","0 -30px");
  });
  $('#docs-list, #docs-off, a#docs').mouseleave(function () {
    $('#icon-docs').css("background-position","0 0");
  });
  $('li#docs-off').hoverIntent(function () {
    $('#docs-list').slideToggle(500);
  });
});
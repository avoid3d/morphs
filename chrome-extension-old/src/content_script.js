var endpoint = 'http://morphs.io:5000/upload-google-results'
//var endpoint = 'http://localhost:5000/upload-google-results'
var morphic_id = /morphic_id:(\d+)/.exec(window.location.href)[1];

function jumpToPageBottom() {
    $('html, body').scrollTop($(document).height() - $(window).height());
}

$('html').bind("DOMSubtreeModified", function() {
    jumpToPageBottom();
});

window.setTimeout(function() {
    $.post(endpoint, {
        html: document.getElementsByTagName('html')[0].innerHTML,
        morphic_id: morphic_id,
    }, function(data) {
        console.log(data);
    })
}, 5);

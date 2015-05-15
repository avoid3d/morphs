console.log('injected')

window.setTimeout(function() {
    $.post('http://localhost:5000/upload-google-results', {
        html: document.getElementsByTagName('html')[0].innerHTML,
        search_query: 'hello world',
    }, function(data) {
        console.log(data);
    })
}, 0);

function editComment(button) {
    var commentDiv = button.closest('.comment');
    var commentText = commentDiv.querySelector('.comment-text');
    var commentEdit = commentDiv.querySelector('.comment-edit');

    commentText.style.display = 'none';
    commentEdit.style.display = 'block';

    // Change button class
    button.className = 'btn btn-outline-success';
    button.innerHTML = '<i class="fa fa-check"></i>';

    // Change button onclick
    button.setAttribute('onclick', 'saveComment(this)');

}

function saveComment(button) {
    var commentDiv = button.closest('.comment');
    var commentText = commentDiv.querySelector('.comment-text');
    var commentEdit = commentDiv.querySelector('.comment-edit');

    // Send post request to save the comment
    var commentId = commentDiv.getAttribute('id');
    var comment = commentEdit.value;
    var data = {
        comment: comment
    };
    console.log(data);
    console.log(commentId);

    var url = '/modify_comment/' + commentId;
    var request = new XMLHttpRequest();
    request.open('POST', url, true);

    // Set the content type of the request
    request.setRequestHeader('Content-Type', 'application/json');

    // Handle the response from the server
    request.onreadystatechange = function() {
        if (request.readyState == 4 && request.status == 200) {
            // Handle successful response, if needed
            console.log('Comment saved successfully');
        } else {
            // Handle error or other responses
            console.error('Error saving comment');
        }
    };

    // Convert data to JSON and send the request
    request.send(JSON.stringify(data));

    // Refresh the page
    window.location = "/";
}
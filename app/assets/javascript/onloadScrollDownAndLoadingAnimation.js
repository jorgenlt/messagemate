scrollDownAction = () => {
  window.scrollTo(0, document.body.scrollHeight);
  const loaderContainer = document.querySelector('.loader-container');
  loaderContainer.classList.add('d-none');
}

scrollDown = () => {
    /*
      The short pause allows any required callback functions
      to execute before actually highlighting, and allows
      the JQuery $(document).ready wrapper to finish.
    */
    setTimeout(function() {
        scrollDownAction();
    }, 200);
}

/*
  Only trigger the highlighter after document fully loaded.  This is
  necessary for cases where page load takes a significant length
  of time to fully load.
*/
if (document.readyState == 'complete') {
    scrollDown();
} else {
    document.onreadystatechange = function () {
        if (document.readyState === "complete") {
            scrollDown();
        }
    }
}

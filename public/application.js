function handleKeyPress(e) {
	var evt = e || window.event;
  if (document.activeElement.tagName == 'INPUT' || document.activeElement.tagName == 'TEXTAREA') {
    return true;
  }
  else {
    var c = evt.charCode;
    switch (c) {
      case 116: scroll(0,0); break; // t: top
      case 101: scroll(0, document.body.scrollHeight); // e: end
      case 110: document.getElementById('wikindle_footer').getElementsByTagName('a')[0].focus(); break; // n: nav
      case 115: goToSearch(); break; // s: search
      case 102: window.location.href = '/feedback'; break; // f: feedback
      case 104: window.location.href = '/help'; break; // h: help
    }
    return false;
  }
}

function goToSearch() {
  setTimeout(function() {
    var el = document.getElementById('search-field')
    el.focus();
  }, 1);
}

document.addEventListener('DOMContentLoaded', function() {
  document.body.addEventListener('keypress', handleKeyPress, false)
}, false);


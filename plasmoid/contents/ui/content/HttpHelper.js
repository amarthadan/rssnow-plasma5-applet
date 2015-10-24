/*Code borrowed from
Martin Grimme  <martin.grimme _AT_ gmail.com> and his project
https://github.com/pycage/tidings. Many thanks.*/

function host(url) {
  var idx = url.search("://");
  var s = url.substring(idx + 3);
  var idx2 = s.search("/");

  return url.substring(0, idx + idx2 + 3);
}

function favIcon(data) {
  var idx = data.search(/<link .*rel *=.*shortcut icon/i);
  if (idx === -1) {
    return "../img/favicon.png";
  }

  var s = data.substring(idx);
  var idx2 = s.search(">");
  s = s.substring(0, idx2);

  idx = s.search("href");
  s = s.substring(idx + 4);
  idx = s.search(/[^= "']/);
  s = s.substring(idx);
  idx = s.search(/[ "']/);

  return s.substring(0, idx);
}

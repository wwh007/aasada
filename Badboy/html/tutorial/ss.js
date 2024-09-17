/**
 * set a cookie
 */
function setCookie(name, value, expires, path, domain, secure)
{
  document.cookie= name + "=" + escape(value);
}

/**
 * gets the value of a cookie.
 */
function getCookie(name)
{
    var dc = document.cookie;
    var prefix = name + "=";
    var begin = dc.indexOf("; " + prefix);
    if (begin == -1) {
        begin = dc.indexOf(prefix);
        if (begin != 0) return null;
    }
    else {
        begin += 2;
    }
    var end = document.cookie.indexOf(";", begin);
    if (end == -1) {
        end = dc.length;
    }
    return unescape(dc.substring(begin + prefix.length, end));
}

function posx(obj) {
  var curleft = 0;
  if (obj.offsetParent) {
    while (obj.offsetParent) {
      curleft += obj.offsetLeft
      obj = obj.offsetParent;
    }
  }
  else if (obj.x)
    curleft += obj.x;
  return curleft;
}

function posy(obj) {
  var curtop = 0;
  if (obj.offsetParent) {
    while (obj.offsetParent) {
      curtop += obj.offsetTop
      obj = obj.offsetParent;
    }
  }
  else if (obj.y)
    curtop += obj.y;
  return curtop;
}



function SSItem(name,price) {
  this.name=name;
  this.price=price;
}

function el(id) {
  return document.getElementById(id);
}

function hide(id) {
  el(id).style.display='none';
}

function show(id) {
  el(id).style.display='block';
}


var items= [ 
  new SSItem("Surf'n Net","10.95"),
  new SSItem("Surf'n Flippers","13.50"),
  new SSItem("Surf'n Headphones","6.95"),
  new SSItem("Surf'n Towel","12.00"),
  ];

function Page(id, resultId) {
  this.id = id;
  this.resultId = resultId;
}

Page.prototype.show = function() {
  for(i=0;i<pages.length;i++) {
    if(pages[i] != this)
      pages[i].hide();
  }
  el(this.id).style.display='block';
  el('nextImg').style.display='none';
  el('desc').innerHTML = el(this.id+'-desc').innerHTML;
  if(currentPage == 0) {
    el('pageTitle').innerHTML="Welcome to the Badboy Tutorial!";
  }
  else
    el('pageTitle').innerHTML="Badboy Tutorial (cont.)";
}

Page.prototype.hide = function() {
  el(this.id).style.display='none';
  el(this.id+'-res').style.display='none';
  el('tlcnr').style.display='none';
  el('trcnr').style.display='none';
  el('blcnr').style.display='none';
  el('brcnr').style.display='none';
  el('resbshadow').style.display='none';
  el('reshshadow').style.display='none';
}

Page.prototype.result = function() {
  var resId = this.id+'-res';
  if(el(resId)) {
    el(resId).style.display='block';
    var resX = posx(el(resId));
    var resY = posy(el(resId));
    var resW = el(resId).offsetWidth;
    var resH = el(resId).offsetHeight;

    el('tlcnr').style.display = 'block';
    el('tlcnr').style.top = resY + 'px';
    el('tlcnr').style.left = resX + 'px';

    el('blcnr').style.display = 'block';
    el('blcnr').style.left = resX + 'px';
    el('blcnr').style.top = (resY + resH - 18) + 'px';

    el('brcnr').style.display = 'block';
    el('brcnr').style.left = (resX + resW - 22) + 'px';
    el('brcnr').style.top = (resY + resH - 17) + 'px';

    el('trcnr').style.display = 'block';
    el('trcnr').style.left = (resX + resW - 19) + 'px';
    el('trcnr').style.top = (resY) + 'px';

    el('resbshadow').style.display='block';
    el('resbshadow').style.left = (resX + 30)+ 'px';
    el('resbshadow').style.width = (resW - 35)+ 'px';
    el('resbshadow').style.top = (resY + resH -4) + 'px';

    el('reshshadow').style.display='block';
    el('reshshadow').style.left = (resX + resW - 4)+ 'px';
    el('reshshadow').style.height = (resH - 30)+ 'px';
    el('reshshadow').style.top = (resY + 16) + 'px';

  }
  if(currentPage < pages.length-1) {
    el('nextImg').style.display='block';
  }
}

var pages = [ 
  new Page('intro', 'cataloglink'),
  new Page('assertion','assertionadded'),
  new Page('paramvar','item1'),
  new Page('variable'),
  new Page('navigation','purchase'),
  new Page('loops',''),
  new Page('play','')
];

var currentPage = 0;

function nextPage() {
  currentPage++;
  pages[currentPage].show();
}

function previousPage() {
  currentPage--;
  pages[currentPage].show();
}

function surfnClick(id) {
  var page = pages[currentPage];
  if(page.resultId == id) {
    page.result();
  }
}

function result() {
  pages[currentPage].result();
}

function init() {
}


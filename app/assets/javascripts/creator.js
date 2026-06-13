
const cd = {};

$.fn.random = function() {
  return this.eq(Math.floor(Math.random() * this.length));
}

cd.setupDisplayNamesClickHandlers = () => {
  const $displayNames = $('.display-name');
  const $displayContent = $('.display-content');
  $displayNames.click((event) => {
    const $element = $(event.target);
    cd.selectedDisplayName = $element.data('name').trim();
    $displayNames.removeClass('selected');
    $element.addClass('selected');
    const index = $element.data('index');
    const content = $(`#contents_${index}`).val();
    $displayContent.val(content);
  });
  $displayNames.random().click()[0].scrollIntoView(); // scrollIntoView is a DOM method, not jQuery
};

cd.urlParams = () => {
  const url = window.location.search;
  return url.substring(url.indexOf('?') + 1);
};

cd.urlParam = (name) => {
  const params = new URLSearchParams(window.location.search);
  return params.get(name);
};

cd.goto = (url) => window.location = url;

cd.toJSON = (s) => {                                  // "x=1&y=2&z=3"
  const args = s.split('&');                          // [ "x=1", "y=2", "z=3" ]
  const elements = args.map((arg) => arg.split('=')); // [ ["x","1"],["y","2"],["z","3"]]
  const obj = elements.reduce((m,a) => {
    m[a[0]] = decodeURIComponent(a[1]);
    return m;
  }, {});                            // { "x":"1", "y":"2", "z":"3" }
  return JSON.stringify(obj);        // '{ "x":"1", "y":"2", "z":"3" }'
};

//= = = = = = = = = = = = = = = = = = = = = = = = = = = = =

cd.setupHoverTips = function(nodes) {
  nodes.each(function() {
    const node = $(this);
    const setTipCallBack = () => {
      const tip = node.data('tip');
      cd.showHoverTip(node, tip);
    };
    cd.setTip(node, setTipCallBack);
  });
};

cd.setTip = (node, setTipCallBack) => {
  // The speed of the mouse could easily exceed
  // the speed of any getJSON callback...
  // The mouse-has-left attribute caters for this.
  node.mouseenter(() => {
    node.removeClass('mouse-has-left');
    setTipCallBack(node);
  });
  node.mouseleave(() => {
    node.addClass('mouse-has-left');
    cd.hoverTipContainer().empty();
  });
};

cd.showHoverTip = (node, tip) => {
  if (node.attr('disabled') || node.hasClass('mouse-has-left')) {
    return;
  }
  // Replaces the jQuery UI position() plug-in (https://jqueryui.com/position/)
  // call: { my:'top', at:'bottom', of:node, collision:'fit' }
  // ie place the tip's top-center just below node, kept within the viewport.
  const hoverTip = $('<div>', {
    'class': 'hover-tip'
  }).html(tip);
  // Attach to the DOM first so the tip can be measured.
  cd.hoverTipContainer().html(hoverTip);

  const nodeOffset = node.offset();
  const atCenterX = nodeOffset.left + (node.outerWidth() / 2);
  const belowNodeY = nodeOffset.top + node.outerHeight();
  let left = atCenterX - (hoverTip.outerWidth() / 2); // my:'top' (center horizontally)
  let top = belowNodeY;                               // at:'bottom'

  // collision:'fit' - keep the tip inside the viewport.
  const $window = $(window);
  const minLeft = $window.scrollLeft();
  const minTop = $window.scrollTop();
  const maxLeft = minLeft + $window.width() - hoverTip.outerWidth();
  const maxTop = minTop + $window.height() - hoverTip.outerHeight();
  left = Math.max(minLeft, Math.min(left, maxLeft));
  top = Math.max(minTop, Math.min(top, maxTop));

  hoverTip.css('position', 'absolute').offset({ left: left, top: top });
};

cd.hoverTipContainer = () => {
  return $('#hover-tip-container');
};

cd.setupHomeIcon = () => {
  const $homeIcon = () => $('.home-icon');
  $homeIcon().show().click(() => cd.goto('/'));
  cd.setupHoverTips($homeIcon());
};

cd.windowOpen = (url) => {
  const opened = window.open(url, '_blank');
  if (opened) {
    opened.focus();
  } else {
    alert('Please, allow popups for this website.');
  }
}

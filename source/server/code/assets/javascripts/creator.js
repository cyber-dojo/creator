
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
  $displayNames.random().click().scrollIntoView();
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
  if (!node.attr('disabled')) {
    if (!node.hasClass('mouse-has-left')) {
      // position() is the jQuery UI plug-in
      // https://jqueryui.com/position/
      const hoverTip = $('<div>', {
        'class': 'hover-tip'
      }).html(tip).position({
        my: 'top',
        at: 'bottom',
        of: node,
        collision: 'fit'
      });
      cd.hoverTipContainer().html(hoverTip);
    }
  }
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

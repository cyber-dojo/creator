
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
  const random = (n) => Math.floor(Math.random() * n);
  const any = random($displayNames.length);
  $displayNames.random().click().scrollIntoView();
};

cd.urlParams = () => {
  const url = window.location.search;
  return url.substring(url.indexOf('?') + 1);
};

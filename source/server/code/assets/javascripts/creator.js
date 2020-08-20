
const cd = {};

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
  $displayNames[any].click().scrollIntoView();
};

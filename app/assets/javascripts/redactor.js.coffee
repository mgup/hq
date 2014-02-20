$ ->
  $('.rich-text-redactor').redactor({
    lang: 'ru',
    buttons: ['formatting',  '|', 'table', '|', 'bold', 'italic', 'underline', '|',
              'alignleft', 'aligncenter', 'alignright', 'justify', '|',
              'orderedlist', 'unorderedlist', 'outdent', 'indent', '|',
              'image', 'link'],
    convertVideoLinks: true
  })
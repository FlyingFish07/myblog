$(function() {
    $('#post_category_list').selectize({
      persist: false,
      hideSelected: true,
      createOnBlur: true,
      create: true,
      valueField: 'name',
      labelField: 'name',
      delimiter: ',',
      searchField: ['name'],
      sortField: [
        {field: 'name', direction: 'asc'}
      ],
      options: JSON.parse($('#category_value_list').text())
    });
    $('#post_tag_list').selectize({
      persist: false,
      hideSelected: true,
      createOnBlur: true,
      create: true,
      valueField: 'name',
      labelField: 'name',
      delimiter: ',',
      searchField: ['name'],
      sortField: [
        {field: 'name', direction: 'asc'}
      ],
      options: JSON.parse($('#tag_value_list').text())
    });
});
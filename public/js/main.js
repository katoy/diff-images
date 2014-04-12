$(function(){

// Pageing を設定すると、hover での画像ポップアップが無効になる？
  var listOptions = {
    valueNames: [ 'idx', 'name'],
    page: 100,
    plugins: [
        [ 'paging', {
            pagingClass: "topPaging",
   	    outerWindow: 2,
            left: 2,
            right: 2
        }],
        [ 'paging', {
            pagingClass: "bottomPaging",
   	    innerWindow: 2,
            left: 2,
            right: 2
        }]
    ]
  };

//  var listOptions = {
//    valueNames: [ 'idx', 'name'],
//    page: 900
//  };

  var diffList = new List('diff_list', listOptions);

  imagePreview();
});

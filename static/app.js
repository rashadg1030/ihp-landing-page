$(document).on('ready turbolinks:load', () => {
    // Init sortable.
    document.querySelectorAll('.js-sortable').forEach(function (elem) {
        if (Boolean(elem.jsSortableInitialized) === false) {
            Sortable.create(elem, {
                handle: '.sortable-handle',
                animation: 150,
            });
            elem.jsSortableInitialized = true;
        }
    });

    // Init TinyMCE
    tinymce.remove();
    tinymce.init({
        selector: '#tinymce',
        setup: function (editor) {
            editor.on('change', function () {
                editor.save();
            });
        },
    });
});

// https://github.com/brookhong/Surfingkeys

mapkey('u', 'page up', 'Normal.scroll("pageUp")');

map('<Ctrl-[>', '<Esc>');

mapkey('F', '#1Open a link in new tab', 'Hints.create("", Hints.dispatchMouseClick, {tabbed: true})');

mapkey('L', '#4Go forward in history', 'history.go(1)');
mapkey('H', '#4Go back in history', 'history.go(-1)');

unmap('<Ctrl-i>');

// set theme
settings.theme = '\
.sk_theme { \
    background: #fff; \
    color: #000; \
} \
.sk_theme tbody { \
    color: #000; \
} \
.sk_theme input { \
    color: #000; \
} \
.sk_theme .url { \
    color: #555; \
} \
.sk_theme .annotation { \
    color: #555; \
} \
.sk_theme .focused { \
    background: #f0f0f0; \
}';

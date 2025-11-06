const Themes = Object.freeze({
    light: "light",
    dark: "dark"
});
const data_key = 'iits-theme';

//determines if the user has a set theme
function detectColorScheme() {
    let theme = Themes.light; //default to light

    //local storage is used to override OS theme settings
    if (localStorage.getItem(data_key)) {
        if (localStorage.getItem(data_key) === Themes.dark) {
            theme = Themes.dark;
        }
    } else if (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches) {
        //OS theme setting detected as dark
        theme = Themes.dark;
    }

    localStorage.setItem(data_key, theme);
    document.documentElement.setAttribute("data-theme", theme);
    return theme
}

//function that changes the theme, and sets a localStorage variable to track the theme between page loads
function switchTheme(e) {
    let toggleSwitch = document.querySelector('input');
    let newTheme = e.target.checked ? Themes.dark : Themes.light;
    localStorage.setItem(data_key, newTheme);
    document.documentElement.setAttribute('data-theme', newTheme);
    toggleSwitch.checked = e.target.checked;
}

const initialTheme = detectColorScheme();

function init() {
    //identify the toggle switch HTML element
    const toggleSwitch = document.querySelector('input');

    //listener for changing themes
    toggleSwitch.addEventListener('change', switchTheme, false);

    //pre-check the dark-theme checkbox if dark-theme is set
    if (initialTheme === Themes.dark) {
        toggleSwitch.checked = true;
    }
}

const Themes = Object.freeze({
    light: "light",
    dark: "dark"
});
const data_key = 'iits-theme';

// Determines if the user has a set theme
function detectColorScheme() {
    let theme = Themes.light; // default to light

    // Local storage is used to override OS theme settings
    if (localStorage.getItem(data_key)) {
        theme = localStorage.getItem(data_key) === Themes.dark ? Themes.dark : Themes.light;
    } else if (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches) {
        // OS theme setting detected as dark
        theme = Themes.dark;
    }

    localStorage.setItem(data_key, theme);
    document.documentElement.setAttribute("data-theme", theme);
    return theme;
}

// Function that changes the theme and sets localStorage
function switchTheme(e) {
    const toggleSwitch = document.querySelector('.switch__input');
    const newTheme = e.target.checked ? Themes.dark : Themes.light;

    localStorage.setItem(data_key, newTheme);
    document.documentElement.setAttribute('data-theme', newTheme);
    toggleSwitch.checked = e.target.checked;
    toggleSwitch.setAttribute('aria-checked', e.target.checked);
}

const initialTheme = detectColorScheme();

// Update indicator appearance
function updateIndicator(indicator, status, statusText) {
    indicator.className = `status-indicator ${status}`;
    indicator.setAttribute('data-status', statusText);
}

// Check service status using fetch with proper error handling
async function checkServiceStatus(url, indicator) {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 5000); // 5 second timeout

    try {
        const response = await fetch(url, {
            method: 'GET',
            cache: 'no-cache',
            signal: controller.signal,
            redirect: 'follow'
        });

        clearTimeout(timeoutId);

        // Check status codes
        if (response.ok) {
            // 200-299 range
            updateIndicator(indicator, 'online', `Online (${response.status})`);
        } else if (response.status >= 300 && response.status < 400) {
            // Redirects - consider as online
            updateIndicator(indicator, 'online', `Online (${response.status})`);
        } else if (response.status === 404) {
            updateIndicator(indicator, 'offline', `Not Found (404)`);
        } else if (response.status >= 500) {
            updateIndicator(indicator, 'offline', `Server Error (${response.status})`);
        } else {
            updateIndicator(indicator, 'offline', `Error (${response.status})`);
        }

    } catch (error) {
        clearTimeout(timeoutId);

        if (error.name === 'AbortError') {
            updateIndicator(indicator, 'offline', 'Timeout');
        } else if (error.name === 'TypeError') {
            // Network error, CORS, or DNS failure
            // Try iframe method as fallback for CORS-restricted resources
            checkViaIframe(url, indicator);
        } else {
            updateIndicator(indicator, 'offline', 'Connection Failed');
        }
    }
}

// Fallback method using iframe for CORS-restricted resources
function checkViaIframe(url, indicator) {
    const iframe = document.createElement('iframe');
    iframe.style.display = 'none';
    iframe.style.position = 'absolute';
    iframe.style.width = '1px';
    iframe.style.height = '1px';

    let timeoutId;
    let hasResponded = false;

    const cleanup = () => {
        if (timeoutId) clearTimeout(timeoutId);
        if (iframe.parentNode) {
            document.body.removeChild(iframe);
        }
    };

    iframe.onload = function() {
        if (hasResponded) return;
        hasResponded = true;

        try {
            // Try to access iframe content - if successful, same origin and loaded
            const iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
            if (iframeDoc) {
                updateIndicator(indicator, 'online', 'Online');
            }
        } catch (e) {
            // Cross-origin - but it loaded, so service is up
            updateIndicator(indicator, 'online', 'Online (CORS)');
        }

        cleanup();
    };

    iframe.onerror = function() {
        if (hasResponded) return;
        hasResponded = true;
        updateIndicator(indicator, 'offline', 'Failed to Load');
        cleanup();
    };

    // Timeout after 5 seconds
    timeoutId = setTimeout(() => {
        if (hasResponded) return;
        hasResponded = true;
        updateIndicator(indicator, 'offline', 'Timeout');
        cleanup();
    }, 5000);

    document.body.appendChild(iframe);
    iframe.src = url;
}

// Check all services
function checkAllServices() {
    const tiles = document.querySelectorAll('.tile[data-url]');

    tiles.forEach((tile, index) => {
        const url = tile.getAttribute('data-url');
        const indicator = tile.querySelector('.status-indicator');

        if (url && indicator) {
            // Add a small random delay to avoid overwhelming the network
            setTimeout(() => {
                checkServiceStatus(url, indicator);
            }, index * 200); // Stagger by 200ms per service
        }
    });
}

// Recheck services periodically
function startPeriodicCheck() {
    // Check every 60 seconds
    setInterval(checkAllServices, 60000);
}

function init() {
    // Identify the toggle switch HTML element
    const toggleSwitch = document.querySelector('.switch__input');

    // Listener for changing themes
    toggleSwitch.addEventListener('change', switchTheme, false);

    // Pre-check the dark-theme checkbox if dark-theme is set
    if (initialTheme === Themes.dark) {
        toggleSwitch.checked = true;
        toggleSwitch.setAttribute('aria-checked', 'true');
    } else {
        toggleSwitch.setAttribute('aria-checked', 'false');
    }

    // Check service statuses on load (with a small delay to let page fully render)
    setTimeout(checkAllServices, 500);

    // Start periodic checks
    startPeriodicCheck();
}

// Listen for system theme changes
if (window.matchMedia) {
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
        if (!localStorage.getItem(data_key)) {
            const newTheme = e.matches ? Themes.dark : Themes.light;
            document.documentElement.setAttribute('data-theme', newTheme);
            const toggleSwitch = document.querySelector('.switch__input');
            toggleSwitch.checked = e.matches;
            toggleSwitch.setAttribute('aria-checked', e.matches);
        }
    });
}
const Themes = Object.freeze({
    light: "light",
    dark: "dark"
});
const data_key = 'kumoops-theme';

// ============================================================================
// STATE MANAGER - localStorage abstraction
// ============================================================================
const StateManager = {
    keys: {
        theme: 'kumoops-theme',
        favorites: 'kumoops-favorites',
        tileOrder: 'kumoops-tile-order',
        settings: 'kumoops-settings'
    },

    get(key, defaultValue = null) {
        try {
            const value = localStorage.getItem(key);
            return value ? JSON.parse(value) : defaultValue;
        } catch (e) {
            console.error('StateManager.get error:', e);
            return defaultValue;
        }
    },

    set(key, value) {
        try {
            localStorage.setItem(key, JSON.stringify(value));
            return true;
        } catch (e) {
            console.error('StateManager.set error:', e);
            return false;
        }
    },

    remove(key) {
        try {
            localStorage.removeItem(key);
            return true;
        } catch (e) {
            console.error('StateManager.remove error:', e);
            return false;
        }
    },

    getFavorites() {
        return this.get(this.keys.favorites, []);
    },

    setFavorites(favorites) {
        return this.set(this.keys.favorites, favorites);
    },

    getSettings() {
        return this.get(this.keys.settings, {
            viewMode: 'grid',
            hiddenCategories: [],
            showFavoritesFirst: true
        });
    },

    setSettings(settings) {
        return this.set(this.keys.settings, settings);
    }
};

// ============================================================================
// SEARCH MANAGER - Real-time search with keyboard shortcuts
// ============================================================================
const SearchManager = {
    searchInput: null,
    tiles: [],
    categories: [],

    init() {
        this.searchInput = document.querySelector('.search-input');
        if (!this.searchInput) return;

        this.tiles = Array.from(document.querySelectorAll('.tile'));
        this.categories = Array.from(document.querySelectorAll('.category'));

        // Search input listener
        this.searchInput.addEventListener('input', (e) => this.handleSearch(e.target.value));

        // "/" keyboard shortcut to focus search
        document.addEventListener('keydown', (e) => {
            if (e.key === '/' && !['INPUT', 'TEXTAREA'].includes(document.activeElement.tagName)) {
                e.preventDefault();
                this.searchInput.focus();
            }
            // ESC to clear search
            if (e.key === 'Escape' && document.activeElement === this.searchInput) {
                this.searchInput.value = '';
                this.handleSearch('');
                this.searchInput.blur();
            }
        });
    },

    handleSearch(query) {
        const searchTerm = query.toLowerCase().trim();
        let visibleCount = 0;

        if (!searchTerm) {
            // Show all tiles
            this.tiles.forEach(tile => tile.classList.remove('hidden'));
            this.categories.forEach(cat => cat.classList.remove('hidden'));
            this.removeNoResultsMessage();
            return;
        }

        // Filter tiles
        this.tiles.forEach(tile => {
            const name = (tile.dataset.name || '').toLowerCase();
            const description = (tile.dataset.description || '').toLowerCase();
            const category = (tile.dataset.category || '').toLowerCase();

            const matches = name.includes(searchTerm) ||
                          description.includes(searchTerm) ||
                          category.includes(searchTerm);

            if (matches) {
                tile.classList.remove('hidden');
                visibleCount++;
            } else {
                tile.classList.add('hidden');
            }
        });

        // Show/hide categories based on visible tiles
        this.categories.forEach(category => {
            const visibleTiles = category.querySelectorAll('.tile:not(.hidden)');
            if (visibleTiles.length > 0) {
                category.classList.remove('hidden');
            } else {
                category.classList.add('hidden');
            }
        });

        // Show no results message if needed
        if (visibleCount === 0) {
            this.showNoResultsMessage();
        } else {
            this.removeNoResultsMessage();
        }
    },

    showNoResultsMessage() {
        if (document.querySelector('.no-results')) return;
        const msg = document.createElement('p');
        msg.className = 'no-results';
        msg.textContent = 'No tiles found matching your search.';
        document.querySelector('.categories-container').insertAdjacentElement('beforebegin', msg);
    },

    removeNoResultsMessage() {
        const msg = document.querySelector('.no-results');
        if (msg) msg.remove();
    }
};

// ============================================================================
// FAVORITES MANAGER - Toggle favorites and show favorites category
// ============================================================================
const FavoritesManager = {
    favorites: [],
    favoritesCategory: null,

    init() {
        this.favorites = StateManager.getFavorites();
        this.setupFavoriteButtons();
        this.createFavoritesCategory();
        this.updateFavoritesDisplay();
    },

    setupFavoriteButtons() {
        document.addEventListener('click', (e) => {
            const btn = e.target.closest('.favorite-btn');
            if (!btn) return;

            e.preventDefault();
            e.stopPropagation();

            const tileUrl = btn.dataset.tileUrl;
            this.toggleFavorite(tileUrl);
        });

        // Keyboard support for favorite buttons
        document.addEventListener('keydown', (e) => {
            const btn = e.target.closest('.favorite-btn');
            if (!btn) return;

            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                e.stopPropagation();
                const tileUrl = btn.dataset.tileUrl;
                this.toggleFavorite(tileUrl);
            }
        });

        // Toggle info tooltip on click
        document.addEventListener('click', (e) => {
            const infoBtn = e.target.closest('.info-btn');
            if (!infoBtn) {
                // Close any open tooltip when clicking elsewhere
                document.querySelectorAll('.info-btn.active').forEach(btn => btn.classList.remove('active'));
                return;
            }

            e.preventDefault();
            e.stopPropagation();

            const wasActive = infoBtn.classList.contains('active');
            document.querySelectorAll('.info-btn.active').forEach(btn => btn.classList.remove('active'));
            if (!wasActive) {
                infoBtn.classList.add('active');
            }
        });
    },

    toggleFavorite(url) {
        const index = this.favorites.indexOf(url);

        if (index > -1) {
            this.favorites.splice(index, 1);
        } else {
            this.favorites.push(url);
        }

        StateManager.setFavorites(this.favorites);
        this.updateFavoritesDisplay();
    },

    updateFavoritesDisplay() {
        // Update button states
        document.querySelectorAll('.favorite-btn').forEach(btn => {
            const url = btn.dataset.tileUrl;
            if (this.favorites.includes(url)) {
                btn.classList.add('active');
                btn.setAttribute('aria-pressed', 'true');
            } else {
                btn.classList.remove('active');
                btn.setAttribute('aria-pressed', 'false');
            }
        });

        // Update favorites category
        this.updateFavoritesCategory();
    },

    createFavoritesCategory() {
        const container = document.querySelector('.categories-container');
        if (!container) return;

        const favCat = document.createElement('div');
        favCat.className = 'category favorites-category hidden';
        favCat.innerHTML = `
            <div class="category-header">
                <h2 class="category-title">
                    <svg class="category-icon" width="20" height="20" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M8 1.33334L10.06 5.50667L14.6667 6.18001L11.3333 9.42667L12.12 14.0133L8 11.8467L3.88 14.0133L4.66667 9.42667L1.33333 6.18001L5.94 5.50667L8 1.33334Z" fill="currentColor" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    Favorites
                </h2>
                <span class="category-count">0</span>
            </div>
            <div class="tiles"></div>
        `;

        container.insertBefore(favCat, container.firstChild);
        this.favoritesCategory = favCat;
    },

    updateFavoritesCategory() {
        if (!this.favoritesCategory) return;

        const tilesContainer = this.favoritesCategory.querySelector('.tiles');
        const countSpan = this.favoritesCategory.querySelector('.category-count');

        // Clear existing tiles
        tilesContainer.innerHTML = '';

        if (this.favorites.length === 0) {
            this.favoritesCategory.classList.add('hidden');
            return;
        }

        // Clone favorite tiles (exclude tiles already in favorites category)
        let actualFavoritesCount = 0;
        this.favorites.forEach(url => {
            // Find tile in any non-favorites category
            const originalTile = document.querySelector(`.category:not(.favorites-category) .tile[data-url="${url}"]`);
            if (originalTile) {
                const clone = originalTile.cloneNode(true);
                // Ensure favorite button is active in clone
                const favBtn = clone.querySelector('.favorite-btn');
                if (favBtn) {
                    favBtn.classList.add('active');
                    favBtn.setAttribute('aria-pressed', 'true');
                }
                tilesContainer.appendChild(clone);
                actualFavoritesCount++;
            }
        });

        // Only show category if we actually found tiles
        if (actualFavoritesCount === 0) {
            this.favoritesCategory.classList.add('hidden');
            // Clean up favorites that don't exist anymore
            this.favorites = [];
            StateManager.setFavorites(this.favorites);
        } else {
            countSpan.textContent = actualFavoritesCount;
            this.favoritesCategory.classList.remove('hidden');
        }
    }
};

// ============================================================================
// SETTINGS MANAGER - Settings panel and view modes
// ============================================================================
const SettingsManager = {
    settings: null,
    modal: null,
    categoriesContainer: null,

    init() {
        this.settings = StateManager.getSettings();
        this.modal = document.querySelector('.settings-modal');
        this.categoriesContainer = document.querySelector('.categories-container');

        if (!this.modal) return;

        this.setupEventListeners();
        this.applySettings();
    },

    setupEventListeners() {
        // Settings button
        const settingsBtn = document.querySelector('.settings-btn');
        if (settingsBtn) {
            settingsBtn.addEventListener('click', () => this.openModal());
        }

        // Close button
        const closeBtn = document.querySelector('.settings-close');
        if (closeBtn) {
            closeBtn.addEventListener('click', () => this.closeModal());
        }

        // Overlay click
        const overlay = document.querySelector('.settings-overlay');
        if (overlay) {
            overlay.addEventListener('click', () => this.closeModal());
        }

        // ESC key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.modal.getAttribute('aria-hidden') === 'false') {
                this.closeModal();
            }
        });

        // View mode buttons
        document.querySelectorAll('.view-mode-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const mode = btn.dataset.mode;
                this.setViewMode(mode);
            });
        });

        // Show favorites first toggle
        const favToggle = document.getElementById('show-favorites-first');
        if (favToggle) {
            favToggle.checked = this.settings.showFavoritesFirst;
            favToggle.addEventListener('change', (e) => {
                this.settings.showFavoritesFirst = e.target.checked;
                this.saveSettings();
                this.applySettings();
            });
        }

        // Reset button
        const resetBtn = document.querySelector('.reset-btn');
        if (resetBtn) {
            resetBtn.addEventListener('click', () => this.resetSettings());
        }
    },

    openModal() {
        this.modal.setAttribute('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';

        // Focus first interactive element
        const firstButton = this.modal.querySelector('.view-mode-btn');
        if (firstButton) {
            setTimeout(() => firstButton.focus(), 100);
        }
    },

    closeModal() {
        this.modal.setAttribute('aria-hidden', 'true');
        document.body.style.overflow = '';

        // Return focus to settings button
        const settingsBtn = document.querySelector('.settings-btn');
        if (settingsBtn) settingsBtn.focus();
    },

    setViewMode(mode) {
        this.settings.viewMode = mode;
        this.saveSettings();
        this.applySettings();

        // Update button states
        document.querySelectorAll('.view-mode-btn').forEach(btn => {
            if (btn.dataset.mode === mode) {
                btn.classList.add('active');
                btn.setAttribute('aria-pressed', 'true');
            } else {
                btn.classList.remove('active');
                btn.setAttribute('aria-pressed', 'false');
            }
        });
    },

    applySettings() {
        // Apply view mode
        document.body.setAttribute('data-view-mode', this.settings.viewMode);

        // Apply favorites first
        if (this.settings.showFavoritesFirst && FavoritesManager.favoritesCategory) {
            this.categoriesContainer.insertBefore(
                FavoritesManager.favoritesCategory,
                this.categoriesContainer.firstChild
            );
        }
    },

    saveSettings() {
        StateManager.setSettings(this.settings);
    },

    resetSettings() {
        this.settings = {
            viewMode: 'grid',
            hiddenCategories: [],
            showFavoritesFirst: true
        };
        this.saveSettings();
        this.applySettings();

        // Update UI
        document.querySelectorAll('.view-mode-btn').forEach(btn => {
            if (btn.dataset.mode === 'grid') {
                btn.classList.add('active');
                btn.setAttribute('aria-pressed', 'true');
            } else {
                btn.classList.remove('active');
                btn.setAttribute('aria-pressed', 'false');
            }
        });

        const favToggle = document.getElementById('show-favorites-first');
        if (favToggle) favToggle.checked = true;
    }
};

// ============================================================================
// DRAG & DROP MANAGER - Reorder tiles within categories
// ============================================================================
const DragDropManager = {
    tileOrder: {},
    draggedElement: null,
    draggedCategory: null,

    init() {
        this.tileOrder = StateManager.get(StateManager.keys.tileOrder, {});
        this.setupDraggable();
        this.applyOrder();
    },

    setupDraggable() {
        // Desktop drag & drop
        document.addEventListener('dragstart', (e) => {
            const tile = e.target.closest('.tile');
            if (!tile) return;

            this.draggedElement = tile;
            this.draggedCategory = tile.closest('.category').querySelector('.category-title').textContent.trim();
            tile.classList.add('dragging');
            e.dataTransfer.effectAllowed = 'move';
        });

        document.addEventListener('dragend', (e) => {
            const tile = e.target.closest('.tile');
            if (!tile) return;

            tile.classList.remove('dragging');
            this.draggedElement = null;
            this.draggedCategory = null;
        });

        document.addEventListener('dragover', (e) => {
            e.preventDefault();
            const tile = e.target.closest('.tile');
            if (!tile || tile === this.draggedElement) return;

            const category = tile.closest('.category');
            const categoryName = category.querySelector('.category-title').textContent.trim();

            // Only allow reorder within same category
            if (categoryName !== this.draggedCategory) return;

            const tilesContainer = category.querySelector('.tiles');
            const afterElement = this.getDragAfterElement(tilesContainer, e.clientY);

            if (afterElement == null) {
                tilesContainer.appendChild(this.draggedElement);
            } else {
                tilesContainer.insertBefore(this.draggedElement, afterElement);
            }
        });

        document.addEventListener('drop', (e) => {
            e.preventDefault();
            this.saveOrder();
        });

        // Touch support for mobile
        let touchStartY = 0;
        let touchElement = null;

        document.addEventListener('touchstart', (e) => {
            const tile = e.target.closest('.tile');
            if (!tile || e.target.closest('.favorite-btn')) return;

            touchElement = tile;
            touchStartY = e.touches[0].clientY;
        }, { passive: true });

        document.addEventListener('touchmove', (e) => {
            if (!touchElement) return;

            const touchY = e.touches[0].clientY;
            const diff = Math.abs(touchY - touchStartY);

            // Only enable drag for long press-like movement
            if (diff > 10) {
                touchElement.classList.add('dragging');
            }
        }, { passive: true });

        document.addEventListener('touchend', () => {
            if (touchElement) {
                touchElement.classList.remove('dragging');
                touchElement = null;
            }
        });
    },

    getDragAfterElement(container, y) {
        const draggableElements = [...container.querySelectorAll('.tile:not(.dragging)')];

        return draggableElements.reduce((closest, child) => {
            const box = child.getBoundingClientRect();
            const offset = y - box.top - box.height / 2;

            if (offset < 0 && offset > closest.offset) {
                return { offset: offset, element: child };
            } else {
                return closest;
            }
        }, { offset: Number.NEGATIVE_INFINITY }).element;
    },

    saveOrder() {
        document.querySelectorAll('.category').forEach(category => {
            const categoryName = category.querySelector('.category-title').textContent.trim();
            const tiles = category.querySelectorAll('.tile');
            const order = Array.from(tiles).map(tile => tile.dataset.url);

            if (order.length > 0) {
                this.tileOrder[categoryName] = order;
            }
        });

        StateManager.set(StateManager.keys.tileOrder, this.tileOrder);
    },

    applyOrder() {
        Object.keys(this.tileOrder).forEach(categoryName => {
            const category = Array.from(document.querySelectorAll('.category')).find(cat => {
                const title = cat.querySelector('.category-title');
                return title && title.textContent.trim() === categoryName;
            });

            if (!category) return;

            const tilesContainer = category.querySelector('.tiles');
            const order = this.tileOrder[categoryName];

            order.forEach(url => {
                const tile = tilesContainer.querySelector(`.tile[data-url="${url}"]`);
                if (tile) {
                    tilesContainer.appendChild(tile);
                }
            });
        });
    }
};

// ============================================================================
// USER INFO MANAGER - User menu with Keycloak userinfo + JWT fallback
// ============================================================================
const UserInfoManager = {
    init() {
        const menu = document.getElementById('user-menu');
        if (!menu) return;

        this.menu = menu;
        this.setupDropdown();

        const userinfoUrl = menu.dataset.userinfoUrl;
        const token = this.getAccessToken();

        if (userinfoUrl && token) {
            this.fetchUserinfo(userinfoUrl, token);
        } else if (token) {
            this.displayFromJwt(token);
        }
    },

    setupDropdown() {
        const btn = document.getElementById('user-menu-btn');
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            const isOpen = this.menu.classList.toggle('open');
            btn.setAttribute('aria-expanded', isOpen);
        });

        document.addEventListener('click', (e) => {
            if (!this.menu.contains(e.target)) {
                this.menu.classList.remove('open');
                btn.setAttribute('aria-expanded', 'false');
            }
        });

        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.menu.classList.contains('open')) {
                this.menu.classList.remove('open');
                btn.setAttribute('aria-expanded', 'false');
            }
        });
    },

    getAccessToken() {
        try {
            const cookies = document.cookie.split(';').reduce((acc, c) => {
                const [key, ...val] = c.trim().split('=');
                acc[key] = val.join('=');
                return acc;
            }, {});

            if (cookies['kc-access']) return cookies['kc-access'];

            let chunked = '';
            for (let i = 0; ; i++) {
                const chunk = cookies['kc-access-' + i];
                if (!chunk) break;
                chunked += chunk;
            }
            return chunked || null;
        } catch (e) {
            return null;
        }
    },

    fetchUserinfo(url, token) {
        fetch(url, {
            headers: { 'Authorization': 'Bearer ' + token }
        })
        .then(res => res.ok ? res.json() : Promise.reject(res.status))
        .then(info => {
            this.display({
                name: info.name || info.preferred_username || info.email,
                email: info.email || '',
                groups: this.extractGroupsFromUserinfo(info)
            });
        })
        .catch(() => this.displayFromJwt(token));
    },

    displayFromJwt(token) {
        try {
            const parts = token.split('.');
            if (parts.length !== 3) return;

            const base64 = parts[1].replace(/-/g, '+').replace(/_/g, '/');
            const json = decodeURIComponent(
                atob(base64).split('').map(c =>
                    '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2)
                ).join('')
            );
            const payload = JSON.parse(json);
            this.display({
                name: payload.name || payload.preferred_username || payload.email,
                email: payload.email || '',
                groups: this.extractGroupsFromJwt(payload)
            });
        } catch (e) {
            console.debug('UserInfoManager: could not decode JWT', e);
        }
    },

    extractGroupsFromUserinfo(info) {
        const groups = [];
        if (Array.isArray(info.groups)) {
            info.groups.forEach(g => groups.push(g.replace(/^\//, '')));
        }
        return [...new Set(groups)];
    },

    extractGroupsFromJwt(payload) {
        const groups = [];
        if (Array.isArray(payload.groups)) {
            payload.groups.forEach(g => groups.push(g.replace(/^\//, '')));
        }
        if (payload.resource_access) {
            for (const [client, access] of Object.entries(payload.resource_access)) {
                if (client === 'account' || client === 'broker') continue;
                if (Array.isArray(access.roles)) {
                    access.roles.forEach(r => groups.push(r));
                }
            }
        }
        return [...new Set(groups)];
    },

    display({ name, email, groups }) {
        if (!name) return;

        document.getElementById('user-menu-name').textContent = name;
        document.getElementById('user-menu-fullname').textContent = name;
        document.getElementById('user-menu-email').textContent = email;

        const context = this.menu.dataset.context;
        const contextEl = document.getElementById('user-menu-context');
        if (context) {
            contextEl.textContent = context;
        } else {
            contextEl.style.display = 'none';
        }

        const groupsContainer = document.getElementById('user-menu-groups');
        const groupsSection = document.getElementById('user-menu-groups-section');

        if (groups.length > 0) {
            groupsContainer.innerHTML = groups
                .map(g => '<span class="user-menu-group-tag">' + g + '</span>')
                .join('');
        } else {
            groupsSection.style.display = 'none';
        }

        this.menu.classList.remove('hidden');
    }
};

// ============================================================================
// SERVICE WORKER MANAGER - Offline support and caching
// ============================================================================
const ServiceWorkerManager = {
    init() {
        if ('serviceWorker' in navigator) {
            window.addEventListener('load', () => {
                navigator.serviceWorker.register('/sw.js')
                    .then((registration) => {
                        console.log('ServiceWorker registered:', registration.scope);
                    })
                    .catch((error) => {
                        console.log('ServiceWorker registration failed:', error);
                    });
            });
        }
    }
};

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

    // Initialize new managers
    UserInfoManager.init();
    SearchManager.init();
    FavoritesManager.init();
    SettingsManager.init();
    DragDropManager.init();
    ServiceWorkerManager.init();
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
document.addEventListener('DOMContentLoaded', function () {
  const logoImage = document.getElementById('logoImage');
  const darkModeRadio = document.getElementById('darkModeRadio');
  const lightModeRadio = document.getElementById('lightModeRadio');
  const tiles = document.querySelectorAll('.tile:not(.disabled)');
  const defaultThemeRadio = document.getElementById('defaultTheme');

  function applyTheme(newColorScheme) {
    document.documentElement.setAttribute('data-theme', newColorScheme);
    localStorage.setItem('theme', newColorScheme);
    if (newColorScheme === 'dark') {
      logoImage.setAttribute('src', 'reev_black.svg');
    } else {
      logoImage.setAttribute('src', 'reev_white.svg');
    }
  }

  darkModeRadio.addEventListener('change', function () {
    applyTheme('dark');
  });

  lightModeRadio.addEventListener('change', function () {
    applyTheme('light');
  });

  defaultThemeRadio.addEventListener('change', function () {
    document.documentElement.removeAttribute('data-theme');
    localStorage.removeItem('theme');
    localStorage.removeItem('lastAnimationTime');
    window.location.reload();
  });

  // Get the last animation time from local storage
  const lastAnimationTime = localStorage.getItem('lastAnimationTime');

  // Check if the last animation happened within the last hour
  const ONE_HOUR_IN_MILLISECONDS = 60 * 60 * 1000;
  const currentTime = new Date().getTime();
  if (!lastAnimationTime || currentTime - lastAnimationTime >= ONE_HOUR_IN_MILLISECONDS) {
    // If the last animation is more than an hour ago or doesn't exist, perform the animation
    tiles.forEach((tile, index) => {
      // Add individual animation delay to each tile
      tile.style.animation = `flyInTile 1s ease-in-out ${index * 0.2}s`;
    });

    // Store the current time as the last animation time in local storage
    localStorage.setItem('lastAnimationTime', currentTime);
  } else {
    // If the last animation is within the last hour, remove the animation class
    tiles.forEach((tile) => {
      tile.classList.add('no-animation');
    });
  }

  const currentTheme = localStorage.getItem('theme');
  if (currentTheme === 'dark') {
    darkModeRadio.checked = true;
    applyTheme('dark');
  } else {
    lightModeRadio.checked = true;
    applyTheme('light');
  }

  function handleColorSchemeChange(event) {
    const newColorScheme = event.matches ? 'dark' : 'light';
    const oldColorScheme = localStorage.getItem('theme');
    if (newColorScheme !== oldColorScheme) {
      console.log(`Color scheme changed. Old: ${oldColorScheme}, New: ${newColorScheme}`);
      applyTheme(newColorScheme);
      if (newColorScheme !== oldColorScheme) {
        window.location.reload();
      }
    }
  }

  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', handleColorSchemeChange);
  window.matchMedia('(prefers-color-scheme: light)').addEventListener('change', handleColorSchemeChange);
  window.matchMedia('(prefers-color-scheme: no-preference)').addEventListener('change', handleColorSchemeChange);
});

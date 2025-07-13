const path = require('path');
const fs = require('fs');
const { app, BrowserWindow, screen, Menu } = require('electron')

Menu.setApplicationMenu(null)
if (process.argv.includes('--portable')) app.setPath('userData', path.join(__dirname, 'data'));
if (!process.argv.includes('--vsync')) {
  app.commandLine.appendSwitch('disable-frame-rate-limit');
  app.commandLine.appendSwitch('disable-gpu-vsync');
}

const createWindow = () => {
  const primaryDisplay = screen.getPrimaryDisplay();
  const { width, height } = primaryDisplay.workAreaSize;

  const win = new BrowserWindow({
    width: Math.floor(width * 0.85),
    height: Math.floor(height * 0.85),
    webPreferences: {
      devTools: false,
      contextIsolation: true,
      nodeIntegration: false,
      experimentalFeatures: true
    }
  });
  
  win.setMenuBarVisibility(false);
  win.setAutoHideMenuBar(true);

  win.loadURL('https://app.webmc.xyz/?plaf=desktop');

  win.webContents.on('did-finish-load', () => {
    const cssPath = path.join(__dirname, 'inject.css');
    const css = fs.readFileSync(cssPath, 'utf8');
    win.webContents.insertCSS(css).catch(err => console.error('CSS injection failed:', err));
  });
}

app.whenReady().then(() => {
  createWindow();
});
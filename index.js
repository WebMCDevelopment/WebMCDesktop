const path = require('path');
const { app, BrowserWindow, screen, Menu } = require('electron')

Menu.setApplicationMenu(null)
if (process.argv.includes('--portable')) app.setPath('userData', path.join(__dirname, 'data'));

const createWindow = () => {
  const primaryDisplay = screen.getPrimaryDisplay()
  const { width, height } = primaryDisplay.workAreaSize

  const win = new BrowserWindow({
    width: Math.floor(width * 0.85),
    height: Math.floor(height * 0.85),
    webPreferences: {
      devTools: false,
      contextIsolation: true,
      nodeIntegration: false,
      experimentalFeatures: true
    }
  })
  
  win.setMenuBarVisibility(false);
  win.setAutoHideMenuBar(true);

  win.loadURL('https://webmc.xyz/?plaf=desktop');
}

app.whenReady().then(() => {
  createWindow();
});
// FF6-themed Overview Module for AGS
// Part of the FF6-themed Hyprland configuration
// Based on JaKooLit's configuration with FF6 styling

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Variables from '../../variables.js';
import UserOptions from '../../user_options.js';

// FF6 theme colors
const {
    menuBlue,
    menuBlueDark,
    menuBlueLight,
    menuBorder,
    menuText,
    menuHighlight,
    menuShadow
} = Variables.colors;

// FF6 theme settings
const {
    borderRadius,
    borderWidth,
    windowOpacity
} = Variables.theme;

// Overview settings
const {
    scale,
    workspaceIndicatorSize,
    marginTop,
    marginBottom,
    padding,
    spacing,
    windowSpacing,
    indicatorColor,
    activeIndicatorColor
} = Variables.overview;

// Sound effects
const playSoundEffect = (sound) => {
    if (Variables.sounds.enabled) {
        const soundPath = `${App.configDir}/sounds/${sound}`;
        Utils.execAsync(['paplay', soundPath]).catch(print);
    }
};

// Create a workspace indicator in FF6 style
const WorkspaceIndicator = (index) => {
    const active = Hyprland.active.workspace.id === index;
    const occupied = Hyprland.getWorkspace(index)?.windows > 0;
    
    return Widget.Box({
        className: `ff6-workspace-indicator ${active ? 'active' : ''} ${occupied ? 'occupied' : ''}`,
        css: `
            min-width: ${workspaceIndicatorSize}px;
            min-height: ${workspaceIndicatorSize}px;
            border-radius: ${borderRadius};
            background-color: ${active ? activeIndicatorColor : indicatorColor};
            border: ${borderWidth} solid ${menuBorder};
            margin: 2px;
        `,
        child: Widget.Label({
            label: UserOptions.workspaces.workspaceNames[index - 1] || index.toString(),
            css: `
                color: ${menuText};
                font-size: 10px;
                font-weight: bold;
            `,
        }),
    });
};

// Create workspace indicators row
const WorkspaceIndicators = () => {
    const indicators = [];
    
    for (let i = 1; i <= UserOptions.workspaces.workspaceCount; i++) {
        indicators.push(WorkspaceIndicator(i));
    }
    
    return Widget.Box({
        className: 'ff6-workspace-indicators',
        css: `
            background-color: ${menuBlueDark};
            border-radius: ${borderRadius};
            padding: ${padding}px;
            margin-bottom: ${spacing}px;
        `,
        spacing: spacing,
        children: indicators,
    });
};

// Create a window thumbnail in FF6 style
const WindowThumbnail = (window) => {
    return Widget.Box({
        className: 'ff6-window-thumbnail',
        css: `
            background-color: ${menuBlue};
            border: ${borderWidth} solid ${menuBorder};
            border-radius: ${borderRadius};
            padding: ${padding}px;
            margin: ${spacing}px;
        `,
        child: Widget.Hyprland.Thumbnail({
            window: window,
            css: `
                min-width: 200px;
                min-height: 120px;
            `,
        }),
        on_clicked: () => {
            playSoundEffect(Variables.sounds.confirm);
            Hyprland.messageAsync(`dispatch focuswindow address:${window.address}`);
            App.closeWindow('overview');
        },
    });
};

// Create workspace with windows
const Workspace = (workspace) => {
    const windows = Hyprland.getWindowsOnWorkspace(workspace.id);
    
    return Widget.Box({
        className: 'ff6-workspace',
        vertical: true,
        css: `
            background-color: ${menuBlueDark};
            border: ${borderWidth} solid ${menuBorder};
            border-radius: ${borderRadius};
            padding: ${padding}px;
            margin: ${spacing}px;
        `,
        children: [
            // Workspace header
            Widget.Box({
                className: 'ff6-workspace-header',
                css: `
                    background-color: ${menuBlue};
                    border-radius: ${borderRadius};
                    padding: ${padding / 2}px;
                    margin-bottom: ${spacing}px;
                `,
                children: [
                    Widget.Label({
                        label: UserOptions.workspaces.workspaceNames[workspace.id - 1] || `Workspace ${workspace.id}`,
                        css: `
                            color: ${menuText};
                            font-weight: bold;
                        `,
                    }),
                ],
            }),
            
            // Windows container
            Widget.Box({
                className: 'ff6-windows-container',
                css: `
                    padding: ${padding / 2}px;
                `,
                spacing: windowSpacing,
                children: windows.map(window => WindowThumbnail(window)),
            }),
        ],
    });
};

// Main overview widget
const Overview = () => {
    // Play menu open sound when overview is shown
    playSoundEffect(Variables.sounds.menuOpen);
    
    return Widget.Window({
        name: 'overview',
        className: 'ff6-overview',
        exclusivity: 'exclusive',
        focusable: true,
        popup: true,
        visible: false,
        css: `
            background-color: rgba(0, 0, 0, 0.7);
        `,
        child: Widget.Box({
            className: 'ff6-overview-container',
            vertical: true,
            css: `
                margin: ${marginTop}px 0 ${marginBottom}px 0;
                padding: ${padding}px;
            `,
            children: [
                // Workspace indicators
                WorkspaceIndicators(),
                
                // Workspaces container
                Widget.Box({
                    className: 'ff6-workspaces-container',
                    css: `
                        background-color: ${menuBlue};
                        border: ${borderWidth} solid ${menuBorder};
                        border-radius: ${borderRadius};
                        padding: ${padding}px;
                    `,
                    spacing: spacing,
                    children: Hyprland.workspaces.map(workspace => Workspace(workspace)),
                }),
            ],
        }),
        setup: self => {
            // Close on Escape key
            self.keybind('Escape', () => {
                playSoundEffect(Variables.sounds.menuClose);
                App.closeWindow('overview');
            });
            
            // Toggle with Super key
            if (UserOptions.general.showOverviewOnSuper) {
                self.keybind('Super', () => {
                    playSoundEffect(Variables.sounds.menuClose);
                    App.closeWindow('overview');
                });
            }
        },
    });
};

export default Overview;

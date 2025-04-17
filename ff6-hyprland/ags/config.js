"use strict";
import GLib from 'gi://GLib';
import App from 'resource:///com/github/Aylur/ags/app.js'
import userOptions from './modules/.configuration/user_options.js';
import Overview from './modules/overview/main.js';

// FF6-themed configuration for Aylur's GTK Shell
// Part of the FF6-themed Hyprland configuration

const COMPILED_STYLE_DIR = `${GLib.get_user_config_dir()}/ags/user/`

// FF6 theme colors
const FF6_COLORS = {
    menuBlue: '#112855',
    menuBlueDark: '#0A1A3A',
    menuBlueLight: '#3B7DFF',
    menuBorder: '#3B7DFF',
    menuText: '#FFFFFF',
    menuHighlight: '#FFD700',
    menuShadow: '#000000',
};

async function applyStyle() {
    App.resetCss();
    App.applyCss(`${COMPILED_STYLE_DIR}/style.css`);
    console.log('[LOG] FF6-themed styles loaded');
}
applyStyle().catch(print);

const Windows = () => [
    Overview()
];

const CLOSE_ANIM_TIME = 210;

App.config({
    css: `${COMPILED_STYLE_DIR}/style.css`,
    stackTraceOnError: true,
    closeWindowDelay: {
        'sideright': CLOSE_ANIM_TIME,
        'sideleft': CLOSE_ANIM_TIME,
        'osk': CLOSE_ANIM_TIME,
    },
    windows: Windows().flat(1),
});

// FF6-themed variables for AGS
// Part of the FF6-themed Hyprland configuration

export default {
    // FF6 menu theme colors
    colors: {
        menuBlue: '#112855',
        menuBlueDark: '#0A1A3A',
        menuBlueLight: '#3B7DFF',
        menuBorder: '#3B7DFF',
        menuText: '#FFFFFF',
        menuHighlight: '#FFD700',
        menuShadow: '#000000',
    },
    
    // FF6 theme settings
    theme: {
        borderRadius: '6px',
        borderWidth: '2px',
        fontSize: '14px',
        fontFamily: 'JetBrains Mono',
        padding: '8px',
        margin: '4px',
        windowOpacity: 0.9,
        menuOpacity: 0.95,
    },
    
    // Overview settings
    overview: {
        scale: 0.15,
        workspaceIndicatorSize: 20,
        marginTop: 8,
        marginBottom: 8,
        padding: 8,
        spacing: 8,
        windowSpacing: 8,
        indicatorColor: '#3B7DFF',
        activeIndicatorColor: '#FFD700',
    },
    
    // Animation settings
    animation: {
        duration: 200,
        easing: 'ease-out',
    },
    
    // Sound effects
    sounds: {
        enabled: true,
        menuOpen: 'menu_open.wav',
        menuClose: 'menu_close.wav',
        select: 'cursor.wav',
        confirm: 'confirm.wav',
        error: 'error.wav',
    },
};

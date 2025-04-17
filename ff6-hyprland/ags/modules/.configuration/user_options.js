// FF6-themed user options configuration
// Part of the FF6-themed Hyprland configuration

export default {
    // General settings
    general: {
        // Whether to show the desktop overview when Super key is pressed
        showOverviewOnSuper: true,
        
        // Whether to play FF6 sound effects
        playSoundEffects: true,
        
        // Animation speed (lower is faster)
        animationSpeed: 200,
    },
    
    // Appearance settings
    appearance: {
        // Use FF6 menu styling
        useFF6Theme: true,
        
        // Border style
        borderStyle: 'solid',
        
        // Use rounded corners
        useRoundedCorners: true,
        
        // Use shadows
        useShadows: true,
    },
    
    // Workspace settings
    workspaces: {
        // Number of workspaces to show in overview
        workspaceCount: 10,
        
        // Names for workspaces (FF6 character names)
        workspaceNames: [
            "Terra", "Locke", "Edgar", "Sabin", 
            "Cyan", "Gau", "Celes", "Setzer", 
            "Shadow", "Mog"
        ],
        
        // Whether to show workspace names
        showWorkspaceNames: true,
    },
    
    // Window settings
    windows: {
        // Whether to show window titles in overview
        showWindowTitles: true,
        
        // Whether to show window icons in overview
        showWindowIcons: true,
        
        // Whether to group windows by application
        groupWindowsByApp: false,
    },
};

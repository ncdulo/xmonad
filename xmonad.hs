--
-- An example, simple ~/.xmonad/xmonad.hs file.
-- It overrides a few basic settings, reusing all the other defaults.
--

import XMonad
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.WindowArranger
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Data.Ratio ((%))
import System.IO

-- Setup the simple stuff
myModMask               = mod4Mask
myTerminal              = "urxvtc"
myBorderWidth           = 2
myFocusedBorderColor    = "#cd8b00"
myNormalBorderColor     = "#cccccc"
myWorkspaces            = ["1:home","2:term","3:irc","4:dev","5:im", "6:media", "7:*", "8:*", "9:*"]
-- Set system specific commands here for ease of change down the line
myDmenuCmd              = "exe=`yeganesh -x -- -p 'Run: ' -fn '-*-terminus-medium-r-normal-*-14-*-*-*-*-*-*-*' -i` && eval \"exec $exe\""
myReloadCmd             = "xmonad --recompile; xmonad --restart; /home/ncdulo/.xmonad/xmobar_reload"
myLockCmd               = "xscreensaver-command -lock"
myTopBarCmd             = "/usr/bin/xmobar /home/ncdulo/.xmonad/topxmobar"
myBottomBarCmd          = "/usr/bin/xmobar /home/ncdulo/.xmonad/bottomxmobar"

-- Setup our layouts
-- We are using per workspace layouts, window spacing and smart borders
myLayout = smartBorders $ mouseResize $ windowArrange (onWorkspace "5:im" pidginLayout $  onWorkspace "2:term" gridLayout $ Mirror tiledLayout ||| tiledLayout ||| Full)
    where
        tiledLayout = Tall nmaster1 delta ratio
        nmaster1 = 1
        ratio = 3/5
        delta = 5/100
        gridLayout = Grid
        pidginLayout = spacing 4 $ withIM(18/100) (Role "buddy_list") gridLayout

-- Setup out manage hooks
-- We are pushing certain window types onto certain workspaces here
myManageHook = composeAll
    [ className =? "Chromium"           --> doShift "1:home"
    , className =? "URxvt"              --> doShift "2:term"
    , className =? "Pidgin"             --> doShift "5:im"
    , className =? "xchat"              --> doShift "3:irc"
    , className =? "smplayer"           --> doShift "6:media"
    , className =? "xscreensaver-demo"  --> doFloat
    , className =? "Steam"              --> doFloat
    , manageDocks
    ]

-- Setup our startup hook
-- Fix borked java applications
myStartupHook = setWMName "LG3D"

-- Main function!
main = do
    -- Two seperate xmobar's for our layout. Top is window/workspace info. Bottom is system info/weather/date
    bottomBar <- spawnPipe myBottomBarCmd
    topBar <- spawnPipe myTopBarCmd
    xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
        { startupHook = myStartupHook
        , manageHook = myManageHook <+> manageHook defaultConfig
        , layoutHook = avoidStruts $ myLayout
        -- Put together some output formatting for xmobar
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn topBar
            , ppTitle = xmobarColor "gray" "" . shorten 150
            , ppCurrent = xmobarColor "white" "" . wrap "[" "]" . xmobarStrip
            , ppHidden = xmobarColor "gray" ""
            , ppVisible = xmobarColor "gray" ""
            , ppUrgent = xmobarColor "black" "white" . wrap "[" "]" . xmobarStrip
            , ppLayout = xmobarColor "gray" ""
            , ppSep = " | "
            }
        , workspaces = myWorkspaces
        , modMask               = myModMask
        , terminal              = myTerminal
        , borderWidth           = myBorderWidth
        , normalBorderColor     = myNormalBorderColor
        , focusedBorderColor    = myFocusedBorderColor
        } `additionalKeys`                  -- Override some keybinds here and create some new ones
        [ ((myModMask, xK_r), spawn myDmenuCmd)
        , ((myModMask, xK_p), spawn myDmenuCmd)
        , ((myModMask, xK_z), spawn myLockCmd)
        , ((myModMask, xK_q), spawn myReloadCmd)
        , ((myModMask, xK_b), sendMessage ToggleStruts)
        , ((myModMask, xK_Tab), goToSelected defaultGSConfig)
        , ((myModMask, xK_Return), spawn myTerminal)
        ]

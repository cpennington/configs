import Data.Ratio ((%))
import XMonad
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.SpawnOn
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Hooks.SetWMName
import XMonad.Layout.IM
import XMonad.Layout.LayoutScreens
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Spiral
import XMonad.Layout.TwoPane
import XMonad.ManageHook
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import XMonad.Util.EZConfig
import XMonad.Util.Run
import qualified Data.Map as M
import qualified XMonad.StackSet as W

myManageHook = composeAll
    [ title =? "Do"                             --> doIgnore
    , resource =? "gvim"                        --> doF (W.shift "dev")
    , className =? "Shiretoko"                  --> doF (W.shift "web")
    , className =? "Firefox"                    --> doF (W.shift "web")
    , className =? "Thunderbird"                --> doF (W.shift "mail")
    , className =? "Pidgin"                     --> doF (W.shift "im")
    , className =? "Xmessage"                   --> doFloat
    , resource =? "urxvt" <&&> title =? "Irssi" --> doF (W.shift "im")
    , resource =? "urxvt" <&&> title =? "Sup"   --> doF (W.shift "mail")
    , resource =? "sunbird-bin"                 --> doF (W.shift "mail")
    ]

myLayoutHook = desktopLayoutModifiers $ 
    Full ||| (Tall 1 (3/100) (3/4)) ||| (spiral (3%4)) ||| (TwoPane (3/100) (1/2))

myWorkspaceHotkeys = [ ("web", 'w')
                     , ("dev", 'd')
                     , ("term", 't')
                     , ("mail", 'm')
                     , ("im", 's')
                     , ("vm", 'v')
                     , ("calendar", 'l')
                     , ("pandora", 'p')]

makeLauncher yargs run exec close = concat ["exe=`yeganesh ", yargs, " -- -t` && ", run, " ", exec, "$exe", close]
launcher     = makeLauncher "" "eval" "\"exec " "\""
termLauncher = makeLauncher "-p withterm" "exec urxvt -e" "" ""

-- By default, Ctrl-C in a prompt hangs XMonad. This is bad,
-- so we quit the prompt instead
safePromptKeymap = M.fromList [((controlMask, xK_c), quit)] `M.union` promptKeymap defaultXPConfig
safePromptConfig = defaultXPConfig { promptKeymap = safePromptKeymap}

goToScreen :: ScreenId -> X ()
goToScreen id = do
    ws <- screenWorkspace id
    whenJust ws (windows . W.view)

myNewKeys sp = [ ("M-" ++ m ++ [key], windows $ f w)
               | (f, m)   <- [(W.greedyView, ""), (W.shift, "S-")]
               , (w, key) <- myWorkspaceHotkeys
               ] ++
               [ ("M-" ++ [key], goToScreen sc)
               | (key, sc) <- zip ['1' .. '9'] [0..]
               ] ++
               [ ("M-g", sshPrompt safePromptConfig)
               , ("M-c", xmonadPrompt safePromptConfig)
               , ("M-r", shellPrompt safePromptConfig)
               , ("M-.", safeSpawn "xcalib" ["-invert", "-alter"])
               , ("M-<Space>", spawnHere sp launcher)
               , ("M-S-<Space>", spawnHere sp termLauncher)
               , ("M-C-<Space>", sendMessage NextLayout)
               ]

myConfig sp = gnomeConfig
    { manageHook  = manageHook gnomeConfig <+> myManageHook
    , layoutHook  = myLayoutHook
    , startupHook = startupHook gnomeConfig >> checkKeymap (myConfig sp) (myNewKeys sp) >> setWMName "LG3D"
    , workspaces  = map fst myWorkspaceHotkeys
    , terminal    = "urxvt"
    }
    `additionalKeysP` (myNewKeys sp)

main = do
    sp <- mkSpawner
    xmonad $ myConfig sp


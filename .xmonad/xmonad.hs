import Data.Ratio ((%))
import Data.List (isInfixOf)
import XMonad
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.SpawnOn
import XMonad.Config.Desktop
import XMonad.Config.Xfce
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
import XMonad.Hooks.Place (placeHook, smart)
import qualified Data.Map as M
import qualified XMonad.StackSet as W

(=<?) :: Query String -> String -> Query Bool
p =<? s = isInfixOf <$> pure s <*> p

orM = fmap or . sequence

myManageHook = composeAll
    [ title =? "Do"                           --> doIgnore
    , className =? "Xmessage"                 --> doFloat
    , appName =? "google-chrome"              --> doF (W.shift "web")
    , appName =? "code"                       --> doF (W.shift "dev")
    , appName =? "xfce4-appfinder"            --> (placeHook (smart (0.5, 0.5)) <+> doFloat)
    , orM [ appName =<? "mail.google.com"
          , appName =<? "inbox.google.com"
          , appName =<? "calendar.google.com"
          ]                                   --> doF (W.shift "mail")
    , orM [ appName =? "hexchat"
          , appName =<? "hipchat"
          , appName =<? "slack"
          , title   =<? "Gitter"
          , appName =? "crx_gnadlgpnphkacgbdoldkidkjngbjljoc"
          ]                                   --> doF (W.shift "im")
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
                     , ("pandora", 'p')
                     , ("editor", 'h')]

terminalCmd = "xfce4-terminal --hide-menubar"

makeLauncher yargs run exec close = concat ["exe=`yeganesh ", yargs, "` && ", run, " ", exec, "$exe", close]
launcher     = makeLauncher "" "eval" "\"exec " "\""
termLauncher = makeLauncher "-p withterm" ("exec " ++ terminalCmd ++ " -e") "" ""

-- By default, Ctrl-C in a prompt hangs XMonad. This is bad,
-- so we quit the prompt instead
safePromptKeymap = M.fromList [((controlMask, xK_c), quit)] `M.union` promptKeymap defaultXPConfig
safePromptConfig = defaultXPConfig { promptKeymap = safePromptKeymap}

goToScreen :: ScreenId -> X ()
goToScreen id = do
    ws <- screenWorkspace id
    whenJust ws (windows . W.view)

splitScreen = layoutSplitScreen 2 (Tall 1 (3/100) (1/2))

myNewKeys = [ ("M-" ++ m ++ [key], windows $ f w)
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
             , ("M-'", rescreen)
             , ("M-S-'", splitScreen)
             , ("M-,", safeSpawn "xfce4-display-settings" ["--minimal"])
             , ("M-<Space>", safeSpawn "xfce4-appfinder" ["--collapsed"])
             ]

myConfig = xfceConfig
    { manageHook  = manageSpawn <+> myManageHook <+> manageHook xfceConfig
    , layoutHook  = myLayoutHook
    , startupHook = startupHook xfceConfig >> checkKeymap myConfig myNewKeys >> setWMName "LG3D" >> splitScreen
    , workspaces  = map fst myWorkspaceHotkeys
    , terminal    = terminalCmd
    }
    `additionalKeysP` myNewKeys

main = xmonad myConfig


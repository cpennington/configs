import XMonad
import XMonad.Config.Gnome
import XMonad.ManageHook
import XMonad.Layout.Spiral
import XMonad.Config.Desktop
import qualified XMonad.StackSet as W
import XMonad.Layout.PerWorkspace
import XMonad.Layout.IM
import Data.Ratio ((%))
import XMonad.Util.EZConfig
import XMonad.Actions.PhysicalScreens
import XMonad.Layout.TwoPane
import XMonad.Prompt
import XMonad.Prompt.Ssh
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad
import qualified Data.Map as M

myManageHook = composeAll
    [ title =? "Do"                             --> doIgnore
    , resource =? "gvim"                        --> doF (W.shift "dev")
    , className =? "Shiretoko"                  --> doF (W.shift "web")
    , className =? "Thunderbird"                --> doF (W.shift "mail")
    , className =? "Pidgin"                     --> doF (W.shift "im")
    , className =? "Xmessage"                   --> doFloat
    , resource =? "urxvt" <&&> title =? "Irssi" --> doF (W.shift "im")
    , resource =? "urxvt" <&&> title =? "Sup"   --> doF (W.shift "mail")
    , resource =? "sunbird-bin"                 --> doF (W.shift "mail")
    ]

myLayoutHook = desktopLayoutModifiers $ 
    onWorkspace "terms" (spiral (1) ||| Full) $
    onWorkspace "im" (withIM (1%6) (Title "Buddy List") Full) $
    Full ||| (Tall 1 (3/100) (3/4)) ||| (spiral (3%4)) ||| (TwoPane (3/100) (1/2))

myWorkspaceHotkeys = [ ("web", 'w')
                     , ("dev", 'd')
                     , ("term", 't')
                     , ("mail", 'm')
                     , ("im", 's')]

-- By default, Ctrl-C in a prompt hangs XMonad. This is bad,
-- so we quit the prompt instead
safePromptKeymap = M.fromList [((controlMask, xK_c), quit)] `M.union` promptKeymap defaultXPConfig
safePromptConfig = defaultXPConfig { promptKeymap = safePromptKeymap}

myNewKeys = [ ("M-" ++ m ++ [key], windows $ f w)
            | (f, m)   <- [(W.greedyView, ""), (W.shift, "S-")]
            , (w, key) <- myWorkspaceHotkeys
            ] ++
            [ ("M-" ++ [key], viewScreen sc)
            | (key, sc) <- zip ['1' .. '9'] [0..]
            ] ++
            [ ("M-g", sshPrompt safePromptConfig)
            , ("M-c", xmonadPrompt safePromptConfig)
            , ("M-r", shellPrompt safePromptConfig)
            ]

myConfig = gnomeConfig
    { manageHook  = manageHook gnomeConfig <+> myManageHook
    , layoutHook  = myLayoutHook
    , startupHook = return () >> checkKeymap myConfig myNewKeys
    , workspaces  = map fst myWorkspaceHotkeys
    , terminal    = "urxvt"
    }
    `additionalKeysP` myNewKeys

main = xmonad myConfig


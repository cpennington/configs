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

myManageHook = composeAll
    [ resource =? "Do" --> doIgnore
    , resource =? "gvim" --> doF (W.shift "dev")
    , className =? "Shiretoko" --> doF (W.shift "web")
    , className =? "Thunderbird" --> doF (W.shift "mail")
    , className =? "Pidgin" --> doF (W.shift "im")
    , className =? "Xmessage" --> doFloat
    ]

myLayoutHook = desktopLayoutModifiers $ 
    onWorkspace "terms" (spiral (1) ||| Full) $
    onWorkspace "im" (withIM (1%6) (Title "Buddy List") Full) $
    Full ||| (Tall 1 (3/100) (3/4)) ||| (spiral (3%4))

myWorkspaceHotkeys = [ ("web", 'w')
                     , ("dev", 'd')
                     , ("term", 't')
                     , ("mail", 'm')
                     , ("im", 's')]

myNewKeys = [ ("M-" ++ m ++ [key], windows $ f w)
            | (f, m)   <- [(W.greedyView, ""), (W.shift, "S-")]
            , (w, key) <- myWorkspaceHotkeys
            ] ++
            [ ("M-" ++ [key], viewScreen sc)
            | (key, sc) <- zip ['1' .. '9'] [0..]
            ]

myConfig = gnomeConfig
    { manageHook = manageHook gnomeConfig <+> myManageHook
    , layoutHook = myLayoutHook
    , startupHook = return () >> checkKeymap myConfig myNewKeys
    , workspaces = map fst myWorkspaceHotkeys
    }
    `additionalKeysP` myNewKeys

main = xmonad myConfig


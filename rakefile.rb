HOME = [
    '.Xdefaults',
    '.bashrc',
    '.compleat',
    '.config/autostart',
    '.dmrc',
    '.emacs.d/init.el',
    '.gitconfig',
    '.irssi',
    '.offlineimap',
    '.offlineimaprc',
    '.profile',
    '.sup/config.yaml',
    '.sup/hooks',
    '.vim',
    '.vimrc',
    '.xmodmap',
    '.xmonad',
]

ROOT = [
    '/etc/X11/xorg.conf'
]

# Magic monkeypatch so that I can say "foo"/"bar"
# instead of File.join(["foo", "bar"])
class String
    def /(o)
        File.join(self, o.to_s)
    end
end

desc "Retrieve current config"
task :scour do
    HOME.each do |file|
        outfile = '.' / File.dirname(file)
        makedirs(outfile)
        cp_r(ENV['HOME'] / file, outfile, :remove_destination => true)
    end
    ROOT.each do |file|
        outfile = '.' / File.dirname(file)
        makedirs(outfile)
        cp_r(file, outfile, :remove_destination => true)
    end
end

task :deploy do

end

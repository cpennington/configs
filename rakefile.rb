HOME = [
    '.compleat/.',
    '.emacs.d/init.el',
    '.vim/.',
    '.xmodmap',
    '.xmonad/.',
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


task :scour do
    HOME.each do |file|
        outfile = '.' / file
        makedirs(File.dirname(outfile))
        cp_r(ENV['HOME'] / file, outfile)
    end
    ROOT.each do |file|
        outfile = '.' / file
        makedirs(File.dirname(outfile))
        cp_r(file, outfile)
    end
end

task :deploy do

end

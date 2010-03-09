def offlineimap(*folders)
  cmd = "offlineimap -q -u Noninteractive.Basic"
  cmd << " -f #{folders * ','}" unless folders.compact.empty?
  `#{cmd}`
end

def folder_names(sources)
  sources.map { |s| s.uri.split('/').last }
end

def inbox_sources(sources = Index.usual_sources)
  sources.find_all { |s| !s.archived? }.sort_by {|s| s.id }
end

say "Running offlineimap..."
log offlineimap()
say "Finished offlineimap run."

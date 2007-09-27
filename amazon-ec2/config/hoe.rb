require 'EC2/version'

AUTHOR = 'Glenn Rempe'  # can also be an array of Authors
EMAIL = "grempe@rubyforge.org"
DESCRIPTION = "An interface library that allows Ruby or Ruby on Rails applications to easily connect to the HTTP 'Query API' for the Amazon Web Services Elastic Compute Cloud (EC2) and manipulate server instances."
GEM_NAME = 'amazon-ec2' # what ppl will type to install your gem
RUBYFORGE_PROJECT = 'amazon-ec2' # The unix name for your project
HOMEPATH = "http://#{RUBYFORGE_PROJECT}.rubyforge.org"
DOWNLOAD_PATH = "http://rubyforge.org/projects/#{RUBYFORGE_PROJECT}"

@config_file = "~/.rubyforge/user-config.yml"
@config = nil
RUBYFORGE_USERNAME = "grempe"
def rubyforge_username
  unless @config
    begin
      @config = YAML.load(File.read(File.expand_path(@config_file)))
    rescue
      puts <<-EOS
ERROR: No rubyforge config file found: #{@config_file}
Run 'rubyforge setup' to prepare your env for access to Rubyforge
 - See http://newgem.rubyforge.org/rubyforge.html for more details
      EOS
      exit
    end
  end
  RUBYFORGE_USERNAME.replace @config["username"]
end


REV = nil 
# UNCOMMENT IF REQUIRED: 
# REV = `svn info`.each {|line| if line =~ /^Revision:/ then k,v = line.split(': '); break v.chomp; else next; end} rescue nil
VERS = EC2::VERSION::STRING + (REV ? ".#{REV}" : "")
RDOC_OPTS = ['--quiet', '--title', 'amazon-ec2 documentation',
    "--opname", "index.html",
    "--line-numbers", 
    "--main", "README.txt",
    "--inline-source"]

class Hoe
  def extra_deps 
    @extra_deps.reject! { |x| Array(x).first == 'hoe' } 
    @extra_deps
  end 
end

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
hoe = Hoe.new(GEM_NAME, VERS) do |p|
  p.author = AUTHOR 
  p.description = DESCRIPTION
  p.email = EMAIL
  p.summary = DESCRIPTION
  p.url = HOMEPATH
  p.rubyforge_name = RUBYFORGE_PROJECT if RUBYFORGE_PROJECT
  p.test_globs = ["test/**/test_*.rb"]
  p.clean_globs |= ['**/.*.sw?', '*.gem', '.config', '**/.DS_Store']  #An array of file patterns to delete on clean.
  
  # == Optional
  p.changes = p.paragraphs_of("History.txt", 0..1).join("\\n\\n")
  #p.extra_deps = []     # An array of rubygem dependencies [name, version], e.g. [ ['active_support', '>= 1.3.1'] ]
  p.extra_deps = [['xml-simple', '>= 1.0.11'], ['mocha', '>= 0.4.0'], ['test-spec', '>= 0.3.0'], ['rcov', '>= 0.8.0.2'], ['syntax', '>= 1.0.0'], ['RedCloth', '>= 3.0.4']]
  
  #p.spec_extras = {}    # A hash of extra values to set in the gemspec.
  p.spec_extras = {
    :extra_rdoc_files => ["README.txt", "History.txt", "License.txt"],
    :rdoc_options => RDOC_OPTS,
    :autorequire => "EC2"
  }
  
end

CHANGES = hoe.paragraphs_of('History.txt', 0..1).join("\\n\\n")
PATH    = (RUBYFORGE_PROJECT == GEM_NAME) ? RUBYFORGE_PROJECT : "#{RUBYFORGE_PROJECT}/#{GEM_NAME}"
hoe.remote_rdoc_dir = File.join(PATH.gsub(/^#{RUBYFORGE_PROJECT}\/?/,''), 'rdoc')

require 'fileutils'
require 'package'

class Autotools < Package
  property :configure_options

  def self.build
    puts "Additional configure_options being used: #{@configure_options.nil? || @configure_options.empty? ? '<no configure_options>' : @configure_options}".orange
    # Run autoreconf if necessary
    unless File.executable? './configure'
      if File.executable? './autogen.sh'
        system 'NOCONFIGURE=1 ./autogen.sh --no-configure || NOCONFIGURE=1 ./autogen.sh'
      elsif File.executable? './bootstrap'
        system 'NOCONFIGURE=1 ./bootstrap --no-configure || NOCONFIGURE=1 ./bootstrap'
      else
        system 'autoreconf -fiv'
      end
    end
    abort 'configure script not found!'.lightred unless File.file?('configure')
    FileUtils.chmod('+x', 'configure')
    if `grep -q /usr/bin/file configure`
      puts 'Using filefix.'.orange
      system 'filefix'
    end
    @mold_linker_prefix_cmd = CREW_LINKER == 'mold' ? 'mold -run ' : ''
    system "#{@mold_linker_prefix_cmd}./configure #{CREW_OPTIONS} #{@configure_options}"
    system 'make'
  end

  def self.install
    system 'make', "DESTDIR=#{CREW_DEST_DIR}", 'install'
  end

  def self.check
    puts 'Testing with make check.'.orange if @run_tests
    system 'make', 'check' if @run_tests
  end
end

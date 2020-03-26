require 'package'

class Pcre < Package
  description 'The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5.'
  homepage 'http://pcre.org/'
  version '8.44'
  source_url 'https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.bz2'
  source_sha256 '19108658b23b3ec5058edc9f66ac545ea19f9537234be1ec62b714c84399366d'

  binary_url ({
  })
  binary_sha256 ({
  })

  def self.build
    system "./configure", "--libdir=#{CREW_LIB_PREFIX}", "--enable-shared", "--disable-static", "--with-pic", "--enable-utf"
    system "make"
  end

  def self.install
    system "make", "DESTDIR=#{CREW_DEST_DIR}", "install"
  end

  def self.check
    system "make", "check"
  end
end

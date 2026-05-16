class RustSilk < Formula
  desc "SILK v3 encoder and decoder CLI"
  homepage "https://github.com/wangnov/rust-silk"
  version "0.1.3"
  license "BSD-3-Clause"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/wangnov/rust-silk/releases/download/v0.1.3/rust-silk-aarch64-apple-darwin.tar.xz"
      sha256 "cf2ce5e3d4803c10c92af355577ee0530ab9f08bf4eb24449febbb6ac6139b00"
    elsif Hardware::CPU.intel?
      url "https://github.com/wangnov/rust-silk/releases/download/v0.1.3/rust-silk-x86_64-apple-darwin.tar.xz"
      sha256 "1237ba03af81ff26e23e82bdbd56dba8ba17d5eff00fe75fdbb74e617e059111"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/wangnov/rust-silk/releases/download/v0.1.3/rust-silk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5dd608cb7409a0e0599690df24dab5193e6b4c8e2a99ffcf50be35cda1b117d1"
    elsif Hardware::CPU.intel?
      url "https://github.com/wangnov/rust-silk/releases/download/v0.1.3/rust-silk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d27abce91e7fc885e5e139803daf6f9aa0412f2d8610775d55d0196c392fdb02"
    else
      odie "unsupported Linux architecture"
    end
  end

  def install
    bin.install "rust-silk"
  end

  test do
    assert_match "SILK", shell_output("#{bin}/rust-silk --help 2>&1")
  end
end

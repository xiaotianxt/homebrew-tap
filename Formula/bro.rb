class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.4.2"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.2/bro-v1.4.2-aarch64-apple-darwin.tar.gz"
      sha256 "58691bcf99186a6bdbae97b702a77f018573e73f23afd60f81b8968c0cf90594"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.2/bro-v1.4.2-x86_64-apple-darwin.tar.gz"
      sha256 "199bb766b10fe0c007d05250beb2c6a945aaf7a2c2d2c56c32d6babd25e01520"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.2/bro-v1.4.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d6c5493ddff0a25c3cb210c1f5a1c6bfaec008c28a25d9d8002554cc0281acaf"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.2/bro-v1.4.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "45517f6dde54a80fe04fe9bfcfedaca92de673fa0f06c346c2f5b8d854ec8bc9"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.4.2/bro-extension-v1.4.2.zip"
    sha256 "410ad02493e880bea129dbb4ea6b7ea139541cb376abd1b1d6a36b7268702336"
  end

  def install
    if build.head?
      system "cargo", "install", "--locked", "--bin", "bro", "--root", prefix, "."
    else
      bin.install "bro"
    end

    resource("extension").stage do
      (share/"bro/extension").install Dir["*"]
    end
  end

  service do
    run [opt_bin/"bro", "serve"]
    keep_alive true
    log_path var/"log/bro.log"
    error_log_path var/"log/bro.err.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bro --version")
    assert_predicate share/"bro/extension/manifest.json", :exist?
  end
end

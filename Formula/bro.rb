class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.5.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.5.0/bro-v1.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "88dda4e099be7197ea08edf2befc9dd827350fc490ad15fbcf22c1a39d6252cc"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.5.0/bro-v1.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "b33ebbb77cf7ee54d230914534d8fbc7c5f0fb699725c61c6bde3c32af52d6d7"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.5.0/bro-v1.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6ac98f395088887a8d0691efe51d7cc59d086fe19121042a7781689918c2617d"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.5.0/bro-v1.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "18d89a8322870256ad4d1f11b2694b2b0399b89e245171a621b72dabd4aab951"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.5.0/bro-extension-v1.5.0.zip"
    sha256 "dea7d41e70fc468e61963b43aa19a27587648b7db28a5cee0623ecb08885ba8d"
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

class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "0.2.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.0/bro-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "4e60478106ba1d807b723a58de67bb5e72b8ca275ab429c451966e6bb6749e33"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.0/bro-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "1fc8cdd3f10ff279e26b5050736d5a6e66bf68eb734d2ae58ab2b93ea24de555"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.0/bro-v0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "72c2f100d96fd79f7025f084053e56ac2f1b826090b7f59bf91099731df3bab8"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.0/bro-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1a29f3b9c59547d2cd73213ea342fd4eec052c694369a1f797a719fd022560ce"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "install", "--locked", "--bin", "bro", "--root", prefix, "."
    else
      bin.install "bro"
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
  end
end

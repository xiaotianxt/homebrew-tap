class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.1.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.1.0/bro-v1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "1a4ae4ad7a510250f3b1b1907705c231814224a2a547e5132ce5628722f80bc1"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.1.0/bro-v1.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "9a4cc911bb4e6db07db02cd032700c14faeeeb3176c4eb0f5154de75cc3c8116"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.1.0/bro-v1.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "271a9988e4d37d3204bef698ff391bfd87046abc61165a80e3762cece3c68d5e"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.1.0/bro-v1.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "63da5749fbcfadebb4190354554d43779d293df2b76b58292fbb19e60b8f897a"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.1.0/bro-extension-v1.1.0.zip"
    sha256 "ec038a4f3108e3cd5aa567711405ca210dfcede53a715164b28da9e2a02b4fc1"
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

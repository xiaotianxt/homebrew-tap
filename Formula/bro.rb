class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.3.2"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.3.2/bro-v1.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "64ae2b8888925b50bf5f8c1d99facca4bc666930d0b1a2d9a234ac0a8c5a36b7"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.3.2/bro-v1.3.2-x86_64-apple-darwin.tar.gz"
      sha256 "1a6c07effe394619437b34473ffa75623da2ac0c92bc7dad558b421f772f8c65"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.3.2/bro-v1.3.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "33ca3506e243876f2e6d27bd466da4f81265763d03410c4541c73c6e3dc2e444"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.3.2/bro-v1.3.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e2aa8e3861bff1d718125948768eec794a1fde89757153b8df06f2c5a6a0bbfd"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.3.2/bro-extension-v1.3.2.zip"
    sha256 "700213309bc6e792998497b7dde97a4edea943841ce05a145887737a6d185847"
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

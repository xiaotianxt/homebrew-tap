class Bro < Formula
  desc "Local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "2.1.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.1.0/bro-v2.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "3e65c3d7a4f31de8b86b02c6abcaf4dc81eca917da77e44cd0f36e47539e1d61"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.1.0/bro-v2.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "5a82ed89eb2b7b2e78afe8debc9d03c524f88e8b2f1688b3003e1222e7786f43"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.1.0/bro-v2.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a9da0e537faf51da000c876dcda279d5a914f0473586750d93474031f917e40d"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.1.0/bro-v2.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "098758699fe9764492b0ce44c278a99ddcf2f305b7118a559bde4b21a1e33eae"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "go" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v2.1.0/bro-extension-v2.1.0.zip"
    sha256 "c34548f6e2a85958360250e1e1a43aafef8a5127be9eaf841e700cd34672eea5"
  end

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"bro"), "./cmd/bro"
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

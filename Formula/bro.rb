class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.3.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.3.1/bro-v1.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "19a3a8f04a71787df1c390d822b94c8a4b7cb63ee832c4c288e2b51256a2bcef"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.3.1/bro-v1.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "32acb54e24db734e3b4743c44a562a0de87f7b1d2abc8cd5fb5dc08a4be9747f"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.3.1/bro-v1.3.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "edb5eae88802999282d955f8d4f6a62563ef761d93dc45375e9b20a17fdfcae5"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.3.1/bro-v1.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "caaa38e0d25ab7db09b2d1b32e9e4ab04fcaefcf4f93154e3274cd56decb93f7"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.3.1/bro-extension-v1.3.1.zip"
    sha256 "b81a6c836138176805b6c74d4009050dc657c62dc64d32f3aa15b7ae6c5b5215"
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

class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.2.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.2.0/bro-v1.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "d6a2021ba53e65fbe06789ba294ba7babaa0321d0a54c14e7d612c071de87e35"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.2.0/bro-v1.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "873f3fc66c9db2bc1137682cd29f27e9b2d02ff50f27f8b1ac4f39316e6e3278"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.2.0/bro-v1.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "45790a422d77d9f42e2403106bda1c55edc994c2dab371ead8968e5378538a84"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.2.0/bro-v1.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3ef4bebf66dbee1d47f531d5d429795f8c36115ed9d0d8ae1a993b2420df23ea"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.2.0/bro-extension-v1.2.0.zip"
    sha256 "cf9567eb14a1be17ba80cb0e7f17ac3baa7c01e756857413b158b9d8178e64aa"
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

class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "0.2.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.4/bro-v0.2.4-aarch64-apple-darwin.tar.gz"
      sha256 "eee149af84d3878644340e1179ad5c8ad7d5873800b0460ebf1f199675fa1360"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.4/bro-v0.2.4-x86_64-apple-darwin.tar.gz"
      sha256 "9f9c296e4ef589823df8c1604eb85509e203456a2ee778737b7d1ceba3cb650c"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.4/bro-v0.2.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "42eb864c8069f8ab4dd4e3dde42e1a9af49bfa957167cebff4292c00cfced42c"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.4/bro-v0.2.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2c3f851585ce1764b49b0e7ab89c22af405b3b49d3327ea4a4c1b1b8a13cbf93"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v0.2.4/bro-extension-v0.2.4.zip"
    sha256 "cdac2829a7d3bbef7335345fb8cdfde70e80654bef3787b692d7ff48f12e9fa2"
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

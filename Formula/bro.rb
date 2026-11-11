class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.6.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.6.0/bro-v1.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "4ad53d8fa8c5a87466721c8e50eb47eebde162fb48b2acf5d41e7472defb6830"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.6.0/bro-v1.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "7ab4f6c65e35fbf8e387d30006ea5c922912657953c387727c0b2e3403c3f383"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.6.0/bro-v1.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "24c17e3e8b62d9554d7e43495948a0d192ba62031615e51b32daa5910fec0416"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.6.0/bro-v1.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "455993c1277e6d6076760b71d48286e0b004f083fc2192926114e2c72be7de8d"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.6.0/bro-extension-v1.6.0.zip"
    sha256 "0e66657d8f9572b2e614a302e429ae34b5a7a4a7626fc22882115b974abb8f95"
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

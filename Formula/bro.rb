class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.0.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.0/bro-v1.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "e1644e79032ce35b4af6b7f5f5a9e80d6e1b9e58c95f38c02933848cfc5c819e"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.0/bro-v1.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "9e3752e46e1291eff0e9a9594ef7450fd7f03dd4892b23d278497d85792c69aa"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.0/bro-v1.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7dac6f6fc4e2eea6d74a6dba1d3c65ab214dad12d903d458352e5b74a4baa412"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.0/bro-v1.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "865775f63e197c798f171c0fcc14e6851ea9ba88c606ebac263b7db8232cf4d3"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.0.0/bro-extension-v1.0.0.zip"
    sha256 "e1d60a7b55f453cf7f41c972d377e551c31419e6d77ed96ccb94ade75fd96e02"
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

class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.1.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.1.1/bro-v1.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "5d5295e0b93ec1015f0fe287dc66ff591bbf6462efc9b2b1b49df5cbe48d1d67"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.1.1/bro-v1.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "dc55cb06384c96fca448764528c6f9f6b66f34de1fe05840aee8d521af809774"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.1.1/bro-v1.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "224ddf515f429d554749a268efcefffebec1fc175f1a7ba3fa5e92735fc8e171"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.1.1/bro-v1.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d496d9ae27a54a02dab7b2b13d5c93fdc16820d7f2a7645aef4d566e5aab60c1"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.1.1/bro-extension-v1.1.1.zip"
    sha256 "243af810f1a9347c23579a840b84188ff124bf4e63b706b7120317c705cf3bb9"
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

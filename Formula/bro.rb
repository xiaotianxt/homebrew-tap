class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.1.2"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.1.2/bro-v1.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "31ab8067638d36f363c49d9337010eb3159a9c3d3ef80394bc8dbcf28775d679"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.1.2/bro-v1.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "9f2993451c1b4296f3725c06ebb0be44ed9476f8c27941133cc6a73d0bf22b7b"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.1.2/bro-v1.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f47659885693d1a0a400170dd8d5a1bfc2d65ab228b99235560f635341666d52"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.1.2/bro-v1.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ded420550c681bf64e836a5d7bb08893e0f74bb2eb18b126878f84637fdc484f"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.1.2/bro-extension-v1.1.2.zip"
    sha256 "2c77179081aa4a70b99b3cdd5d91aec318359ca22a9305799087355aa85f389f"
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

class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "0.2.3"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.3/bro-v0.2.3-aarch64-apple-darwin.tar.gz"
      sha256 "986f37f911ba3b55305d8ebf1fc7684c8c7f1e0d91a9abaace874918d3f8d68d"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.3/bro-v0.2.3-x86_64-apple-darwin.tar.gz"
      sha256 "50fb339b249da4dafeef77862f7eb08768ecdd9af70b7fb6d79dcea830ca301a"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.3/bro-v0.2.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "097bc9b150ab92de8798c7d267111a71f912e97871fc522bc30c61e1f1ae1337"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.3/bro-v0.2.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f894ec23b51f484575b22bbf1a200dca9b91a23bbebb8309e9851205e0768198"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v0.2.3/bro-extension-v0.2.3.zip"
    sha256 "0a58124cdda6b3e3f554f82fd7965fa725971f8b74de668b24b2f9551ebc5c32"
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

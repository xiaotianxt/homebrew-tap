class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.0.3"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.3/bro-v1.0.3-aarch64-apple-darwin.tar.gz"
      sha256 "c6d554024606219e71859cc9a34023edec8c80fd099998f209c338552bfb75bc"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.3/bro-v1.0.3-x86_64-apple-darwin.tar.gz"
      sha256 "8a3b645adc5cc634924f1797ddb85eb07f9ede7eb163484997336ef65b2cafe7"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.3/bro-v1.0.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c01dcee7b14785d5cc78229d93067c41d763a91b6693e3c7cd42c4ced13f5558"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.3/bro-v1.0.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e5d89cffc09de43f8a48b99103c96a1143bc591cb1035456bbe5ddfd404c295e"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.0.3/bro-extension-v1.0.3.zip"
    sha256 "a592fca044b6eca37eec7e9990f8f5ff4f5ef0c123f7c17f86919c0dcd330173"
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

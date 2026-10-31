class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.4.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.1/bro-v1.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "403607a60c96579ff652ebe8b72942ef0976e561fff784690869b97366b665cb"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.1/bro-v1.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "5a099feb383f4319999a7af352c0962d57ea70cf6b9bb2263f6d03b87166e213"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.1/bro-v1.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8119aef2d32c48dd4c91989987e13264158b3d0f2d2941e02e6a80575e8ad26d"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.1/bro-v1.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "12d271249d722bec19ca7e0e91fbe8c679e73b74371853cd18faf897de7eec33"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.4.1/bro-extension-v1.4.1.zip"
    sha256 "0be19e62c8e0639fe012592894f313aade08310e78e4d34e56af15d3257a5c5f"
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

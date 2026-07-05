class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "0.2.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.5/bro-v0.2.5-aarch64-apple-darwin.tar.gz"
      sha256 "58cdceab033987ebaa89984a7e2604834b6996027670c46a0827dcc437eaa1cb"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.5/bro-v0.2.5-x86_64-apple-darwin.tar.gz"
      sha256 "3167e5f005c0f23e73fdbed359e17b27c644d6664bf41446cf1712d9acdcbb28"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.5/bro-v0.2.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ba2ebfd97336da9c7501c8b1d30ec9c408de80f8c23555b82b7b61e93128e3b3"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.5/bro-v0.2.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "48d2df2836abc903b2d1b6e66b966ed749566721f2473ac3235006c418cd3b76"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v0.2.5/bro-extension-v0.2.5.zip"
    sha256 "f82ca24d1bce029e6738c5ee581d59b612506b1461ece3c05652a4edd6b6e5df"
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

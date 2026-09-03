class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.0.2"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.2/bro-v1.0.2-aarch64-apple-darwin.tar.gz"
      sha256 "2e970346edb0f102cd6af9e2dbe00b4d1758f11fde13303bb8832de252bf2d0a"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.2/bro-v1.0.2-x86_64-apple-darwin.tar.gz"
      sha256 "ece16c9afe937e5fc546d61b5d8a441b292b46a6972f43b5101b7f84b0a554e9"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.2/bro-v1.0.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8f96bd55a6fe59628f687f2b432f449aa23d72dcb8f6e6100fc5f319805b042f"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.2/bro-v1.0.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7bb0a83950ce8aa42b9adcb9965b0e8cddeb406764e972f78fd6ba9ecde4b0ed"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.0.2/bro-extension-v1.0.2.zip"
    sha256 "af718e33ae06e968105c8439339bc3ca9e52321cb71086a8cd0d48dee4d3e2c5"
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

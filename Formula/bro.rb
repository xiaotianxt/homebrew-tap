class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.4.3"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.3/bro-v1.4.3-aarch64-apple-darwin.tar.gz"
      sha256 "87772ed073492e0adeecbbe2803818ca6837d91191811bdf84200b2d5d1dec1f"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.3/bro-v1.4.3-x86_64-apple-darwin.tar.gz"
      sha256 "a6d40d90ec6ed4fb0fdcd7c932e4493da78e55c7ce46063446a5194b9292ae6d"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.3/bro-v1.4.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dd076bf0750029100b2bc2caad20e9d89df81b85e60ef164691bbf23369e5e53"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.3/bro-v1.4.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bdf4cd6e56dfbd3760aca6ec051e344433bfb2de2a6b1d603386b031f7d210a7"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.4.3/bro-extension-v1.4.3.zip"
    sha256 "07330c9bf7e10d71471b54a3ad4fea9acdb52e06ce832bb661277cda14811c9c"
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

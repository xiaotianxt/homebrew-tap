class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.4.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.0/bro-v1.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "5ddcb1625b3f94a9c1dec335b539a170ff50628dd693e474ac12222bf5c5934d"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.0/bro-v1.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "23c77a4cacc9b7b2b0bf29d9429a707dd242cc043d5e4c53f91358afc7d1f98f"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.0/bro-v1.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b9ac153cd4da1f80789d05d2533b577c6701a6d99ca59b5e1e52d64ab7c14378"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.0/bro-v1.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f77d33ad3ec496c58897e571c8a3da25f9d9af4c8cf5e95f0ecfd6b6729196f0"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.4.0/bro-extension-v1.4.0.zip"
    sha256 "8b334367184e070b1b3ad5de2778ec3c0d70e2516e7bdc4b69338ac6f1bcfbaa"
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
